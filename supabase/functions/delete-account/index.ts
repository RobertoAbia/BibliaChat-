import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";
import { crypto } from "https://deno.land/std@0.224.0/crypto/mod.ts";
import { encodeHex } from "https://deno.land/std@0.224.0/encoding/hex.ts";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

// Genera SHA256 hash del user_id para pseudonimización
async function hashUserId(userId: string): Promise<string> {
  const data = new TextEncoder().encode(userId);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  return encodeHex(new Uint8Array(hashBuffer));
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) throw new Error('No authorization header');

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseAnonKey = Deno.env.get('SUPABASE_ANON_KEY')!;
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

    // Verificar usuario con su token
    const userClient = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } }
    });
    const { data: { user }, error: userError } = await userClient.auth.getUser();
    if (userError || !user) throw new Error('Invalid user token');

    const userId = user.id;
    const userIdHash = await hashUserId(userId);
    console.log(`Processing account deletion for user: ${userId}`);

    // Admin client para operaciones privilegiadas
    const adminClient = createClient(supabaseUrl, supabaseServiceKey, {
      auth: { autoRefreshToken: false, persistSession: false }
    });

    // ========================================
    // PASO 1: ARCHIVAR DATOS ANONIMIZADOS
    // ========================================

    // Obtener perfil (demografía)
    const { data: profile } = await adminClient
      .from('user_profiles')
      .select('denomination, origin, age_group, gender, country_code, motive, motive_detail, features, consent_terms_at, consent_data_at, created_at')
      .eq('user_id', userId)
      .single();

    // Obtener todos los mensajes de chat
    const { data: chats } = await adminClient
      .from('chats')
      .select('id')
      .eq('user_id', userId);

    let allMessages: { role: string; content: string; created_at: string }[] = [];
    if (chats && chats.length > 0) {
      const chatIds = chats.map(c => c.id);
      const { data: messages } = await adminClient
        .from('chat_messages')
        .select('role, content, created_at')
        .in('chat_id', chatIds)
        .order('created_at', { ascending: true });
      allMessages = messages || [];
    }

    // Obtener progreso de planes
    const { data: userPlans } = await adminClient
      .from('user_plans')
      .select(`
        status,
        current_day,
        plans!inner(name, days_total)
      `)
      .eq('user_id', userId);

    const plansData = (userPlans || []).map(up => ({
      plan_name: (up.plans as { name: string })?.name,
      status: up.status,
      days_completed: up.current_day - 1
    }));

    // Obtener métricas agregadas
    const { data: activity } = await adminClient
      .from('daily_activity')
      .select('completed, messages_sent')
      .eq('user_id', userId);

    const totalMessages = (activity || []).reduce((sum, a) => sum + (a.messages_sent || 0), 0);
    const streakMax = (activity || []).filter(a => a.completed).length;

    // Insertar archivo pseudonimizado
    const { error: archiveError } = await adminClient
      .from('deleted_user_archives')
      .insert({
        user_id_hash: userIdHash,
        original_user_created_at: profile?.created_at,
        denomination: profile?.denomination,
        origin_group: profile?.origin,
        age_group: profile?.age_group,
        gender: profile?.gender,
        country_code: profile?.country_code,
        motive: profile?.motive,
        motive_detail: profile?.motive_detail,
        features: profile?.features,
        consent_terms_at: profile?.consent_terms_at,
        consent_data_at: profile?.consent_data_at,
        chat_messages: allMessages,
        plans_data: plansData,
        total_messages: totalMessages + allMessages.length,
        total_plans_started: plansData.length,
        total_plans_completed: plansData.filter(p => p.status === 'completed').length,
        streak_max: streakMax
      });

    if (archiveError) {
      console.error('Archive failed:', archiveError);
      throw new Error(`Failed to archive data: ${archiveError.message}`);
    }
    console.log('Data archived successfully');

    // ========================================
    // PASO 2: BORRAR USUARIO (CASCADE)
    // ========================================
    const { error: deleteError } = await adminClient.auth.admin.deleteUser(userId);
    if (deleteError) throw new Error(`Failed to delete user: ${deleteError.message}`);

    console.log(`User ${userId} deleted successfully`);

    return new Response(
      JSON.stringify({ success: true, message: 'Account deleted successfully' }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );

  } catch (error) {
    console.error('Delete account error:', error);
    return new Response(
      JSON.stringify({ success: false, error: error instanceof Error ? error.message : 'Unknown error' }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
