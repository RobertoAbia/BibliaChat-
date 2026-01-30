import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient, SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";

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

/**
 * Obtiene la hora local actual para un timezone dado
 */
function getLocalHour(timezone: string): number {
  try {
    const now = new Date();
    const localTime = new Date(now.toLocaleString('en-US', { timeZone: timezone }));
    return localTime.getHours();
  } catch {
    // Si el timezone es inválido, asumimos que no es la hora correcta
    return -1;
  }
}

/**
 * Obtiene la fecha de hoy en formato YYYY-MM-DD
 */
function getTodayDate(): string {
  return new Date().toISOString().split('T')[0];
}

/**
 * Obtiene la fecha de ayer en formato YYYY-MM-DD
 */
function getYesterdayDate(): string {
  const yesterday = new Date();
  yesterday.setDate(yesterday.getDate() - 1);
  return yesterday.toISOString().split('T')[0];
}

/**
 * TIPO 1: Usuarios que no han visto Stories hoy (enviar a las 20:00 su hora)
 */
async function getUsersWhoMissedStories(
  supabase: SupabaseClient,
  targetHour: number
): Promise<UserToNotify[]> {
  const today = getTodayDate();

  // Obtener usuarios con dispositivos que NO han completado hoy
  const { data: usersWithDevices, error } = await supabase
    .from('user_profiles')
    .select(`
      user_id,
      timezone,
      user_devices!inner(device_token)
    `);

  if (error || !usersWithDevices) {
    console.error('Error getting users:', error);
    return [];
  }

  // Obtener usuarios que SÍ completaron hoy
  const { data: completedToday } = await supabase
    .from('daily_activity')
    .select('user_id')
    .eq('activity_date', today)
    .eq('completed', true);

  const completedUserIds = new Set((completedToday || []).map(u => u.user_id));

  // Obtener rachas actuales
  const { data: streakData } = await supabase
    .from('daily_activity')
    .select('user_id, streak_days')
    .order('activity_date', { ascending: false });

  const userStreaks = new Map<string, number>();
  for (const s of streakData || []) {
    if (!userStreaks.has(s.user_id)) {
      userStreaks.set(s.user_id, s.streak_days || 0);
    }
  }

  return usersWithDevices
    .filter(u => {
      const timezone = u.timezone || 'America/New_York';
      const localHour = getLocalHour(timezone);
      return localHour === targetHour && !completedUserIds.has(u.user_id);
    })
    .map(u => {
      const streak = userStreaks.get(u.user_id) || 0;
      return {
        user_id: u.user_id,
        title: streak > 0 ? `🔥 No pierdas tu racha de ${streak} días` : '🔥 Tu reflexión del día te espera',
        body: streak > 0 ? 'Aún estás a tiempo de mantenerla' : 'Dedica unos minutos a tu paz interior',
        screen: 'stories',
      };
    });
}

/**
 * TIPO 2: Recordatorio diario a la hora elegida por el usuario
 */
async function getUsersForDailyReminder(supabase: SupabaseClient): Promise<UserToNotify[]> {
  // Obtener usuarios con recordatorio habilitado
  const { data: users, error } = await supabase
    .from('user_profiles')
    .select(`
      user_id,
      timezone,
      reminder_time,
      user_devices!inner(device_token)
    `)
    .eq('reminder_enabled', true)
    .not('reminder_time', 'is', null);

  if (error || !users) {
    console.error('Error getting users for daily reminder:', error);
    return [];
  }

  const now = new Date();

  return users
    .filter(u => {
      const timezone = u.timezone || 'America/New_York';
      const localHour = getLocalHour(timezone);

      // reminder_time es TIME (ej: "08:00:00"), extraemos la hora
      const reminderHour = parseInt(u.reminder_time?.split(':')[0] || '8', 10);

      return localHour === reminderHour;
    })
    .map(u => ({
      user_id: u.user_id,
      title: '🙏 Es tu momento de paz',
      body: 'Tu espacio de reflexión te espera',
      screen: 'home',
    }));
}

/**
 * TIPO 3: Usuarios con plan abandonado (3+ días sin progreso)
 */
async function getUsersWithAbandonedPlans(
  supabase: SupabaseClient,
  targetHour: number
): Promise<UserToNotify[]> {
  const threeDaysAgo = new Date();
  threeDaysAgo.setDate(threeDaysAgo.getDate() - 3);

  // Obtener planes activos sin progreso en 3+ días
  const { data: abandonedPlans, error } = await supabase
    .from('user_plans')
    .select(`
      user_id,
      updated_at,
      plans!inner(name),
      user_profiles!inner(timezone, user_devices!inner(device_token))
    `)
    .eq('status', 'in_progress')
    .lt('updated_at', threeDaysAgo.toISOString());

  if (error || !abandonedPlans) {
    console.error('Error getting abandoned plans:', error);
    return [];
  }

  return abandonedPlans
    .filter(p => {
      const profile = p.user_profiles as { timezone?: string };
      const timezone = profile?.timezone || 'America/New_York';
      return getLocalHour(timezone) === targetHour;
    })
    .map(p => {
      const plan = p.plans as { name: string };
      return {
        user_id: p.user_id,
        title: `📚 ${plan.name} te espera`,
        body: 'Continúa donde lo dejaste',
        screen: 'study',
      };
    });
}

/**
 * TIPO 4: Usuarios que perdieron su racha ayer
 */
async function getUsersWhoLostStreak(
  supabase: SupabaseClient,
  targetHour: number
): Promise<UserToNotify[]> {
  const yesterday = getYesterdayDate();
  const twoDaysAgo = new Date();
  twoDaysAgo.setDate(twoDaysAgo.getDate() - 2);
  const twoDaysAgoStr = twoDaysAgo.toISOString().split('T')[0];

  // Usuarios que completaron hace 2 días (tenían racha)
  const { data: hadStreak, error: error1 } = await supabase
    .from('daily_activity')
    .select('user_id')
    .eq('activity_date', twoDaysAgoStr)
    .eq('completed', true);

  if (error1 || !hadStreak) {
    console.error('Error getting streak data:', error1);
    return [];
  }

  const hadStreakIds = hadStreak.map(u => u.user_id);
  if (hadStreakIds.length === 0) return [];

  // De esos, quienes NO completaron ayer (perdieron racha)
  const { data: completedYesterday } = await supabase
    .from('daily_activity')
    .select('user_id')
    .eq('activity_date', yesterday)
    .eq('completed', true)
    .in('user_id', hadStreakIds);

  const completedYesterdayIds = new Set((completedYesterday || []).map(u => u.user_id));
  const lostStreakIds = hadStreakIds.filter(id => !completedYesterdayIds.has(id));

  if (lostStreakIds.length === 0) return [];

  // Obtener perfiles con dispositivos
  const { data: profiles, error: error2 } = await supabase
    .from('user_profiles')
    .select(`
      user_id,
      timezone,
      user_devices!inner(device_token)
    `)
    .in('user_id', lostStreakIds);

  if (error2 || !profiles) {
    console.error('Error getting profiles:', error2);
    return [];
  }

  return profiles
    .filter(p => {
      const timezone = p.timezone || 'America/New_York';
      return getLocalHour(timezone) === targetHour;
    })
    .map(p => ({
      user_id: p.user_id,
      title: '💪 Tu racha se rompió, ¡pero hoy puedes empezar de nuevo!',
      body: 'Vuelve a empezar tu racha hoy',
      screen: 'home',
    }));
}

/**
 * Envía notificación llamando a la función send-notification
 */
async function sendNotification(
  supabaseUrl: string,
  serviceKey: string,
  user: UserToNotify
): Promise<boolean> {
  try {
    const response = await fetch(`${supabaseUrl}/functions/v1/send-notification`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${serviceKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        user_id: user.user_id,
        title: user.title,
        body: user.body,
        data: { screen: user.screen },
      }),
    });

    const result = await response.json();
    return result.success;
  } catch (error) {
    console.error(`Error sending notification to ${user.user_id}:`, error);
    return false;
  }
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const { type } = await req.json() as { type: NotificationType };

    if (!type) {
      throw new Error('Missing required field: type');
    }

    console.log(`Processing notification type: ${type}`);

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    let users: UserToNotify[] = [];

    switch (type) {
      case 'stories_missed':
        // Enviar a las 20:00 hora local del usuario
        users = await getUsersWhoMissedStories(supabase, 20);
        break;

      case 'daily_reminder':
        // Enviar a la hora configurada por el usuario
        users = await getUsersForDailyReminder(supabase);
        break;

      case 'plan_abandoned':
        // Enviar a las 18:00 hora local del usuario
        users = await getUsersWithAbandonedPlans(supabase, 18);
        break;

      case 'streak_lost':
        // Enviar a las 09:00 hora local del usuario
        users = await getUsersWhoLostStreak(supabase, 9);
        break;

      default:
        throw new Error(`Unknown notification type: ${type}`);
    }

    console.log(`Found ${users.length} user(s) to notify for type: ${type}`);

    // Enviar notificaciones en paralelo (máximo 10 concurrentes)
    const batchSize = 10;
    let successCount = 0;
    let failureCount = 0;

    for (let i = 0; i < users.length; i += batchSize) {
      const batch = users.slice(i, i + batchSize);
      const results = await Promise.all(
        batch.map(user => sendNotification(supabaseUrl, supabaseServiceKey, user))
      );
      successCount += results.filter(r => r).length;
      failureCount += results.filter(r => !r).length;
    }

    console.log(`Notifications sent: ${successCount} success, ${failureCount} failures`);

    return new Response(
      JSON.stringify({
        success: true,
        type,
        total_users: users.length,
        sent: successCount,
        failed: failureCount,
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );

  } catch (error) {
    console.error('send-daily-reminders error:', error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error'
      }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
