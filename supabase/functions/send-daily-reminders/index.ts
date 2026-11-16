import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient, SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";
import { encodeBase64Url } from "https://deno.land/std@0.224.0/encoding/base64url.ts";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

type NotificationType = 'stories_missed' | 'daily_reminder' | 'plan_abandoned' | 'streak_lost';

interface UserToNotify {
  user_id: string;
  title: string;
  body: string;
  screen: string;
}

interface ServiceAccount {
  project_id: string;
  private_key: string;
  client_email: string;
}

// ============================================================
// FCM Direct Send (no dependency on send-notification function)
// ============================================================

async function createSignedJwt(serviceAccount: ServiceAccount): Promise<string> {
  const header = { alg: "RS256", typ: "JWT" };
  const now = Math.floor(Date.now() / 1000);
  const payload = {
    iss: serviceAccount.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  };

  const encodedHeader = encodeBase64Url(new TextEncoder().encode(JSON.stringify(header)));
  const encodedPayload = encodeBase64Url(new TextEncoder().encode(JSON.stringify(payload)));
  const unsignedToken = `${encodedHeader}.${encodedPayload}`;

  const pemContents = serviceAccount.private_key
    .replace(/-----BEGIN PRIVATE KEY-----/g, '')
    .replace(/-----END PRIVATE KEY-----/g, '')
    .replace(/\n/g, '');

  const binaryKey = Uint8Array.from(atob(pemContents), c => c.charCodeAt(0));

  const cryptoKey = await crypto.subtle.importKey(
    "pkcs8",
    binaryKey,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"]
  );

  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    cryptoKey,
    new TextEncoder().encode(unsignedToken)
  );

  const encodedSignature = encodeBase64Url(new Uint8Array(signature));
  return `${unsignedToken}.${encodedSignature}`;
}

async function getAccessToken(serviceAccount: ServiceAccount): Promise<string> {
  const jwt = await createSignedJwt(serviceAccount);

  const response = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Failed to get access token: ${error}`);
  }

  const data = await response.json();
  return data.access_token;
}

async function sendPushToDevice(
  token: string,
  title: string,
  body: string,
  data: Record<string, string>,
  platform: string,
  accessToken: string,
  projectId: string
): Promise<boolean> {
  const message: Record<string, unknown> = {
    message: {
      token,
      notification: { title, body },
      data,
    }
  };

  if (platform === 'android') {
    (message.message as Record<string, unknown>).android = {
      priority: "high",
      notification: { channel_id: "biblia_chat_channel", sound: "default" }
    };
  } else if (platform === 'ios') {
    (message.message as Record<string, unknown>).apns = {
      payload: { aps: { sound: "default", badge: 1 } }
    };
  }

  try {
    const response = await fetch(
      `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
      {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(message),
      }
    );
    return response.ok;
  } catch {
    return false;
  }
}

/**
 * Envía notificación directamente via FCM a un usuario (todos sus dispositivos)
 */
async function sendNotificationToUser(
  supabase: SupabaseClient,
  user: UserToNotify,
  accessToken: string,
  projectId: string
): Promise<boolean> {
  const { data: devices } = await supabase
    .from('user_devices')
    .select('device_token, platform')
    .eq('user_id', user.user_id);

  if (!devices || devices.length === 0) return false;

  const results = await Promise.all(
    devices.map(d => sendPushToDevice(
      d.device_token, user.title, user.body,
      { screen: user.screen }, d.platform,
      accessToken, projectId
    ))
  );

  return results.some(r => r);
}

// ============================================================
// Notification Logic
// ============================================================

function getLocalHour(timezone: string): number {
  try {
    const now = new Date();
    const localTime = new Date(now.toLocaleString('en-US', { timeZone: timezone }));
    return localTime.getHours();
  } catch {
    return -1;
  }
}

// Fecha (YYYY-MM-DD) en la zona horaria del usuario, con offset de días.
// daily_activity se escribe con la fecha LOCAL del dispositivo; calcular
// "hoy"/"ayer" en UTC desfasaba un día a los usuarios de América (a las
// 20:00 de Los Ángeles el "hoy" UTC ya es mañana) y se les avisaba de
// perder rachas que habían completado.
function getLocalDate(timezone: string, daysOffset = 0): string {
  const d = new Date(Date.now() + daysOffset * 86400000);
  try {
    return d.toLocaleDateString('en-CA', { timeZone: timezone });
  } catch {
    return d.toISOString().split('T')[0];
  }
}

// Pagina user_devices: PostgREST corta en 1000 filas por request — a partir
// de ~1000 dispositivos, los usuarios siguientes dejaban de recibir pushes
// en silencio, sin ningún error.
async function getUserIdsWithToken(supabase: SupabaseClient): Promise<Set<string>> {
  const ids = new Set<string>();
  const pageSize = 1000;
  for (let from = 0; ; from += pageSize) {
    const { data, error } = await supabase
      .from('user_devices')
      .select('user_id')
      .range(from, from + pageSize - 1);
    if (error) {
      console.error('getUserIdsWithToken:', error.message);
      break;
    }
    const rows = data || [];
    for (const d of rows) ids.add(d.user_id);
    if (rows.length < pageSize) break;
  }
  return ids;
}

// .in() con miles de ids genera URLs gigantes que PostgREST rechaza:
// trocear la lista y concatenar resultados.
async function selectInChunks<T>(
  buildQuery: (chunk: string[]) => PromiseLike<{ data: T[] | null; error: { message: string } | null }>,
  ids: string[],
  chunkSize = 200,
): Promise<T[]> {
  const all: T[] = [];
  for (let i = 0; i < ids.length; i += chunkSize) {
    const { data, error } = await buildQuery(ids.slice(i, i + chunkSize));
    if (error) {
      console.error('selectInChunks:', error.message);
      continue;
    }
    all.push(...(data || []));
  }
  return all;
}

// Perfiles (user_id + timezone) de todos los usuarios con token FCM
async function getProfilesWithToken(
  supabase: SupabaseClient,
): Promise<{ user_id: string; timezone: string | null }[]> {
  const userIdsWithToken = await getUserIdsWithToken(supabase);
  if (userIdsWithToken.size === 0) return [];
  return selectInChunks(
    (chunk) =>
      supabase.from('user_profiles').select('user_id, timezone').in('user_id', chunk),
    Array.from(userIdsWithToken),
  );
}

async function getUsersWhoMissedStories(
  supabase: SupabaseClient, targetHour: number
): Promise<UserToNotify[]> {
  const profiles = await getProfilesWithToken(supabase);

  // Candidatos: usuarios en la hora local objetivo
  const candidates = profiles.filter(u =>
    getLocalHour(u.timezone || 'America/New_York') === targetHour);
  if (candidates.length === 0) return [];

  // "Hoy" POR USUARIO en su zona horaria (coincide con la fecha local que
  // escribe la app en daily_activity)
  const todayByUser = new Map(candidates.map(u =>
    [u.user_id, getLocalDate(u.timezone || 'America/New_York')]));
  const todayDates = [...new Set(todayByUser.values())];

  const completedRows = await selectInChunks<{ user_id: string; activity_date: string }>(
    (chunk) =>
      supabase
        .from('daily_activity').select('user_id, activity_date')
        .eq('completed', true)
        .in('user_id', chunk)
        .in('activity_date', todayDates),
    candidates.map(u => u.user_id),
  );

  const completedKey = new Set(
    completedRows.map(r => `${r.user_id}:${r.activity_date}`));

  return candidates
    .filter(u => !completedKey.has(`${u.user_id}:${todayByUser.get(u.user_id)}`))
    .map(u => ({
      user_id: u.user_id,
      title: '🔥 Tu reflexión del día te espera',
      body: 'Dedica unos minutos a tu paz interior',
      screen: 'home',
    }));
}

async function getUsersForDailyReminder(supabase: SupabaseClient): Promise<UserToNotify[]> {
  const userIdsWithToken = await getUserIdsWithToken(supabase);
  if (userIdsWithToken.size === 0) return [];

  const users = await selectInChunks<{ user_id: string; timezone: string | null; reminder_time: string | null }>(
    (chunk) =>
      supabase
        .from('user_profiles').select('user_id, timezone, reminder_time')
        .eq('reminder_enabled', true).not('reminder_time', 'is', null)
        .in('user_id', chunk),
    Array.from(userIdsWithToken),
  );

  return users
    .filter(u => {
      const localHour = getLocalHour(u.timezone || 'America/New_York');
      const reminderHour = parseInt(u.reminder_time?.split(':')[0] || '8', 10);
      console.log(`User ${u.user_id}: localHour=${localHour}, reminderHour=${reminderHour}, tz=${u.timezone}`);
      return localHour === reminderHour;
    })
    .map(u => ({
      user_id: u.user_id,
      title: '🙏 Es tu momento de paz',
      body: 'Tu espacio de reflexión te espera',
      screen: 'home',
    }));
}

async function getUsersWithAbandonedPlans(
  supabase: SupabaseClient, targetHour: number
): Promise<UserToNotify[]> {
  const threeDaysAgo = new Date();
  threeDaysAgo.setDate(threeDaysAgo.getDate() - 3);
  const userIdsWithToken = await getUserIdsWithToken(supabase);
  if (userIdsWithToken.size === 0) return [];

  const plans = await selectInChunks<{ user_id: string; updated_at: string; plan_id: string }>(
    (chunk) =>
      supabase
        .from('user_plans').select('user_id, updated_at, plan_id')
        .eq('status', 'in_progress').lt('updated_at', threeDaysAgo.toISOString())
        .in('user_id', chunk),
    Array.from(userIdsWithToken),
  );
  if (plans.length === 0) return [];

  const planIds = [...new Set(plans.map(p => p.plan_id))];
  const { data: planData } = await supabase.from('plans').select('id, name').in('id', planIds);
  const planNames = new Map((planData || []).map(p => [p.id, p.name]));

  const userIds = [...new Set(plans.map(p => p.user_id))];
  const profiles = await selectInChunks<{ user_id: string; timezone: string | null }>(
    (chunk) =>
      supabase.from('user_profiles').select('user_id, timezone').in('user_id', chunk),
    userIds,
  );
  const tzMap = new Map(profiles.map(p => [p.user_id, p.timezone || 'America/New_York']));

  return plans
    .filter(p => getLocalHour(tzMap.get(p.user_id) || 'America/New_York') === targetHour)
    .map(p => ({
      user_id: p.user_id,
      title: `📚 ${planNames.get(p.plan_id) || 'Tu plan'} te espera`,
      body: 'Continúa donde lo dejaste',
      screen: 'home',
    }));
}

async function getUsersWhoLostStreak(
  supabase: SupabaseClient, targetHour: number
): Promise<UserToNotify[]> {
  const profiles = await getProfilesWithToken(supabase);

  // Candidatos: usuarios en la hora local objetivo
  const candidates = profiles.filter(p =>
    getLocalHour(p.timezone || 'America/New_York') === targetHour);
  if (candidates.length === 0) return [];

  // "Ayer" y "anteayer" POR USUARIO en su zona horaria
  const datesByUser = new Map(candidates.map(p => {
    const tz = p.timezone || 'America/New_York';
    return [p.user_id, {
      yesterday: getLocalDate(tz, -1),
      twoDaysAgo: getLocalDate(tz, -2),
    }];
  }));

  const allDates = [...new Set(
    [...datesByUser.values()].flatMap(d => [d.yesterday, d.twoDaysAgo]))];

  const activityRows = await selectInChunks<{ user_id: string; activity_date: string }>(
    (chunk) =>
      supabase
        .from('daily_activity').select('user_id, activity_date')
        .eq('completed', true)
        .in('user_id', chunk)
        .in('activity_date', allDates),
    candidates.map(c => c.user_id),
  );

  const completedKey = new Set(
    activityRows.map(r => `${r.user_id}:${r.activity_date}`));

  return candidates
    .filter(p => {
      const d = datesByUser.get(p.user_id)!;
      // Racha perdida = completó anteayer pero NO ayer
      return completedKey.has(`${p.user_id}:${d.twoDaysAgo}`) &&
        !completedKey.has(`${p.user_id}:${d.yesterday}`);
    })
    .map(p => ({
      user_id: p.user_id,
      title: '💪 Tu racha se rompió, ¡pero hoy puedes empezar de nuevo!',
      body: 'Vuelve a empezar tu racha hoy',
      screen: 'home',
    }));
}

// ============================================================
// Main Handler
// ============================================================

// ¿Llamada del backend? Acepta la service_role key (igualdad con el env),
// cualquier JWT cuyo payload tenga role=service_role (la FIRMA ya la
// verificó el gateway de Supabase antes de invocar la función, así que el
// payload es de fiar), o una secret key del formato nuevo (sb_secret_...).
// Un JWT anon o de usuario tiene role 'anon'/'authenticated' y NO pasa.
function isServiceRequest(token: string, serviceKey: string | undefined): boolean {
  if (!token) return false;
  if (serviceKey && token === serviceKey) return true;
  if (token.startsWith('sb_secret_')) return true;
  try {
    const payload = JSON.parse(
      atob(token.split('.')[1].replace(/-/g, '+').replace(/_/g, '/')));
    return payload?.role === 'service_role';
  } catch {
    return false;
  }
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    // --- Autorización ---
    // Solo el backend (service_role: el cron de GitHub Actions) puede
    // disparar recordatorios masivos. Sin este check, cualquiera con el
    // anon key del APK podía spamear pushes a toda la base de usuarios.
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
    const token = (req.headers.get('Authorization') ?? '').replace('Bearer ', '');
    if (!isServiceRequest(token, supabaseServiceKey)) {
      return new Response(
        JSON.stringify({ success: false, error: 'Forbidden' }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      );
    }

    const { type } = await req.json() as { type: NotificationType };
    if (!type) throw new Error('Missing required field: type');

    console.log(`Processing notification type: ${type}`);

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const firebaseJson = Deno.env.get('FIREBASE_SERVICE_ACCOUNT');
    if (!firebaseJson) throw new Error('FIREBASE_SERVICE_ACCOUNT not configured');

    const serviceAccount: ServiceAccount = JSON.parse(firebaseJson);
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    let users: UserToNotify[] = [];

    switch (type) {
      case 'stories_missed': users = await getUsersWhoMissedStories(supabase, 20); break;
      case 'daily_reminder': users = await getUsersForDailyReminder(supabase); break;
      case 'plan_abandoned': users = await getUsersWithAbandonedPlans(supabase, 18); break;
      case 'streak_lost': users = await getUsersWhoLostStreak(supabase, 9); break;
      default: throw new Error(`Unknown notification type: ${type}`);
    }

    console.log(`Found ${users.length} user(s) to notify for type: ${type}`);

    // Get FCM access token once for all sends
    let successCount = 0;
    let failureCount = 0;

    if (users.length > 0) {
      const accessToken = await getAccessToken(serviceAccount);

      for (const user of users) {
        const ok = await sendNotificationToUser(supabase, user, accessToken, serviceAccount.project_id);
        if (ok) successCount++; else failureCount++;
      }
    }

    console.log(`Notifications sent: ${successCount} success, ${failureCount} failures`);

    return new Response(
      JSON.stringify({ success: true, type, total_users: users.length, sent: successCount, failed: failureCount }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );

  } catch (error) {
    console.error('send-daily-reminders error:', error);
    return new Response(
      JSON.stringify({ success: false, error: error instanceof Error ? error.message : 'Unknown error' }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
