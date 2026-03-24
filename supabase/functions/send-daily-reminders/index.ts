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

function getTodayDate(): string {
  return new Date().toISOString().split('T')[0];
}

function getYesterdayDate(): string {
  const yesterday = new Date();
  yesterday.setDate(yesterday.getDate() - 1);
  return yesterday.toISOString().split('T')[0];
}

async function getUserIdsWithToken(supabase: SupabaseClient): Promise<Set<string>> {
  const { data } = await supabase.from('user_devices').select('user_id');
  return new Set((data || []).map(d => d.user_id));
}

async function getUsersWhoMissedStories(
  supabase: SupabaseClient, targetHour: number
): Promise<UserToNotify[]> {
  const today = getTodayDate();
  const userIdsWithToken = await getUserIdsWithToken(supabase);
  if (userIdsWithToken.size === 0) return [];

  const { data: profiles } = await supabase
    .from('user_profiles').select('user_id, timezone')
    .in('user_id', Array.from(userIdsWithToken));

  const { data: completedToday } = await supabase
    .from('daily_activity').select('user_id')
    .eq('activity_date', today).eq('completed', true);

  const completedIds = new Set((completedToday || []).map(u => u.user_id));

  return (profiles || [])
    .filter(u => {
      const localHour = getLocalHour(u.timezone || 'America/New_York');
      return localHour === targetHour && !completedIds.has(u.user_id);
    })
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

  const { data: users, error } = await supabase
    .from('user_profiles').select('user_id, timezone, reminder_time')
    .eq('reminder_enabled', true).not('reminder_time', 'is', null)
    .in('user_id', Array.from(userIdsWithToken));

  if (error || !users) {
    console.error('Error getting users for daily reminder:', error);
    return [];
  }

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

  const { data: plans, error } = await supabase
    .from('user_plans').select('user_id, updated_at, plan_id')
    .eq('status', 'in_progress').lt('updated_at', threeDaysAgo.toISOString())
    .in('user_id', Array.from(userIdsWithToken));

  if (error || !plans || plans.length === 0) return [];

  const planIds = [...new Set(plans.map(p => p.plan_id))];
  const { data: planData } = await supabase.from('plans').select('id, name').in('id', planIds);
  const planNames = new Map((planData || []).map(p => [p.id, p.name]));

  const userIds = [...new Set(plans.map(p => p.user_id))];
  const { data: profiles } = await supabase.from('user_profiles').select('user_id, timezone').in('user_id', userIds);
  const tzMap = new Map((profiles || []).map(p => [p.user_id, p.timezone || 'America/New_York']));

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
  const yesterday = getYesterdayDate();
  const twoDaysAgo = new Date();
  twoDaysAgo.setDate(twoDaysAgo.getDate() - 2);
  const twoDaysAgoStr = twoDaysAgo.toISOString().split('T')[0];
  const userIdsWithToken = await getUserIdsWithToken(supabase);
  if (userIdsWithToken.size === 0) return [];

  const { data: hadStreak } = await supabase
    .from('daily_activity').select('user_id')
    .eq('activity_date', twoDaysAgoStr).eq('completed', true);

  const hadStreakWithToken = (hadStreak || []).filter(u => userIdsWithToken.has(u.user_id));
  const hadStreakIds = hadStreakWithToken.map(u => u.user_id);
  if (hadStreakIds.length === 0) return [];

  const { data: completedYesterday } = await supabase
    .from('daily_activity').select('user_id')
    .eq('activity_date', yesterday).eq('completed', true)
    .in('user_id', hadStreakIds);

  const completedIds = new Set((completedYesterday || []).map(u => u.user_id));
  const lostIds = hadStreakIds.filter(id => !completedIds.has(id));
  if (lostIds.length === 0) return [];

  const { data: profiles } = await supabase
    .from('user_profiles').select('user_id, timezone').in('user_id', lostIds);

  return (profiles || [])
    .filter(p => getLocalHour(p.timezone || 'America/New_York') === targetHour)
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

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const { type } = await req.json() as { type: NotificationType };
    if (!type) throw new Error('Missing required field: type');

    console.log(`Processing notification type: ${type}`);

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
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
