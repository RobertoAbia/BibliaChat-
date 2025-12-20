-- =============================================================================
-- MIGRACIÓN 00007: Row Level Security (RLS) Policies
-- =============================================================================
-- Descripción: Políticas de seguridad para proteger datos de usuarios
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Helper function para verificar ownership
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_owner(p_user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS $$
  SELECT auth.uid() = p_user_id;
$$;

-- =============================================================================
-- USER_PROFILES - Solo el propietario puede acceder
-- =============================================================================
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_profiles_select_own" ON public.user_profiles
  FOR SELECT USING (public.is_owner(user_id));

CREATE POLICY "user_profiles_insert_own" ON public.user_profiles
  FOR INSERT WITH CHECK (public.is_owner(user_id));

CREATE POLICY "user_profiles_update_own" ON public.user_profiles
  FOR UPDATE USING (public.is_owner(user_id))
  WITH CHECK (public.is_owner(user_id));

CREATE POLICY "user_profiles_delete_own" ON public.user_profiles
  FOR DELETE USING (public.is_owner(user_id));

-- =============================================================================
-- USER_DEVICES - Solo el propietario puede acceder
-- =============================================================================
ALTER TABLE public.user_devices ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_devices_select_own" ON public.user_devices
  FOR SELECT USING (public.is_owner(user_id));

CREATE POLICY "user_devices_insert_own" ON public.user_devices
  FOR INSERT WITH CHECK (public.is_owner(user_id));

CREATE POLICY "user_devices_update_own" ON public.user_devices
  FOR UPDATE USING (public.is_owner(user_id))
  WITH CHECK (public.is_owner(user_id));

CREATE POLICY "user_devices_delete_own" ON public.user_devices
  FOR DELETE USING (public.is_owner(user_id));

-- =============================================================================
-- USER_ENTITLEMENTS - Solo el propietario puede leer
-- =============================================================================
ALTER TABLE public.user_entitlements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_entitlements_select_own" ON public.user_entitlements
  FOR SELECT USING (public.is_owner(user_id));

-- Insert/Update solo desde service_role (Edge Functions)
-- No policy para insert/update desde cliente

-- =============================================================================
-- CHATS - Solo el propietario puede acceder
-- =============================================================================
ALTER TABLE public.chats ENABLE ROW LEVEL SECURITY;

CREATE POLICY "chats_select_own" ON public.chats
  FOR SELECT USING (public.is_owner(user_id));

CREATE POLICY "chats_insert_own" ON public.chats
  FOR INSERT WITH CHECK (public.is_owner(user_id));

CREATE POLICY "chats_update_own" ON public.chats
  FOR UPDATE USING (public.is_owner(user_id))
  WITH CHECK (public.is_owner(user_id));

CREATE POLICY "chats_delete_own" ON public.chats
  FOR DELETE USING (public.is_owner(user_id));

-- =============================================================================
-- CHAT_MESSAGES - Acceso vía ownership del chat padre
-- =============================================================================
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "chat_messages_select_own" ON public.chat_messages
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.chats c
      WHERE c.id = chat_messages.chat_id
        AND c.user_id = auth.uid()
    )
  );

CREATE POLICY "chat_messages_insert_own" ON public.chat_messages
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.chats c
      WHERE c.id = chat_messages.chat_id
        AND c.user_id = auth.uid()
    )
  );

CREATE POLICY "chat_messages_delete_own" ON public.chat_messages
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM public.chats c
      WHERE c.id = chat_messages.chat_id
        AND c.user_id = auth.uid()
    )
  );

-- No permitir update de mensajes desde cliente
REVOKE UPDATE ON TABLE public.chat_messages FROM authenticated;

-- =============================================================================
-- SAVED_MESSAGES - Solo el propietario + mensaje debe ser suyo
-- =============================================================================
ALTER TABLE public.saved_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "saved_messages_select_own" ON public.saved_messages
  FOR SELECT USING (public.is_owner(user_id));

CREATE POLICY "saved_messages_insert_own" ON public.saved_messages
  FOR INSERT WITH CHECK (
    public.is_owner(user_id)
    AND EXISTS (
      SELECT 1 FROM public.chat_messages m
      JOIN public.chats c ON c.id = m.chat_id
      WHERE m.id = saved_messages.chat_message_id
        AND c.user_id = auth.uid()
    )
  );

CREATE POLICY "saved_messages_delete_own" ON public.saved_messages
  FOR DELETE USING (public.is_owner(user_id));

-- =============================================================================
-- USER_DEVOTIONS - Solo el propietario puede acceder
-- =============================================================================
ALTER TABLE public.user_devotions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_devotions_select_own" ON public.user_devotions
  FOR SELECT USING (public.is_owner(user_id));

CREATE POLICY "user_devotions_insert_own" ON public.user_devotions
  FOR INSERT WITH CHECK (public.is_owner(user_id));

CREATE POLICY "user_devotions_update_own" ON public.user_devotions
  FOR UPDATE USING (public.is_owner(user_id))
  WITH CHECK (public.is_owner(user_id));

CREATE POLICY "user_devotions_delete_own" ON public.user_devotions
  FOR DELETE USING (public.is_owner(user_id));

-- =============================================================================
-- DAILY_ACTIVITY - Solo el propietario puede acceder
-- =============================================================================
ALTER TABLE public.daily_activity ENABLE ROW LEVEL SECURITY;

CREATE POLICY "daily_activity_select_own" ON public.daily_activity
  FOR SELECT USING (public.is_owner(user_id));

CREATE POLICY "daily_activity_insert_own" ON public.daily_activity
  FOR INSERT WITH CHECK (public.is_owner(user_id));

CREATE POLICY "daily_activity_update_own" ON public.daily_activity
  FOR UPDATE USING (public.is_owner(user_id))
  WITH CHECK (public.is_owner(user_id));

CREATE POLICY "daily_activity_delete_own" ON public.daily_activity
  FOR DELETE USING (public.is_owner(user_id));

-- =============================================================================
-- USER_POINTS - Solo el propietario puede leer
-- =============================================================================
ALTER TABLE public.user_points ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_points_select_own" ON public.user_points
  FOR SELECT USING (public.is_owner(user_id));

CREATE POLICY "user_points_insert_own" ON public.user_points
  FOR INSERT WITH CHECK (public.is_owner(user_id));

CREATE POLICY "user_points_update_own" ON public.user_points
  FOR UPDATE USING (public.is_owner(user_id))
  WITH CHECK (public.is_owner(user_id));

-- =============================================================================
-- USER_BADGES - Solo el propietario puede leer
-- =============================================================================
ALTER TABLE public.user_badges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_badges_select_own" ON public.user_badges
  FOR SELECT USING (public.is_owner(user_id));

CREATE POLICY "user_badges_insert_own" ON public.user_badges
  FOR INSERT WITH CHECK (public.is_owner(user_id));

-- =============================================================================
-- USER_PLANS - Solo el propietario puede acceder
-- =============================================================================
ALTER TABLE public.user_plans ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_plans_select_own" ON public.user_plans
  FOR SELECT USING (public.is_owner(user_id));

CREATE POLICY "user_plans_insert_own" ON public.user_plans
  FOR INSERT WITH CHECK (public.is_owner(user_id));

CREATE POLICY "user_plans_update_own" ON public.user_plans
  FOR UPDATE USING (public.is_owner(user_id))
  WITH CHECK (public.is_owner(user_id));

CREATE POLICY "user_plans_delete_own" ON public.user_plans
  FOR DELETE USING (public.is_owner(user_id));

-- =============================================================================
-- USER_PLAN_DAYS - Acceso vía ownership del user_plan padre
-- =============================================================================
ALTER TABLE public.user_plan_days ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_plan_days_select_own" ON public.user_plan_days
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.user_plans up
      WHERE up.id = user_plan_days.user_plan_id
        AND up.user_id = auth.uid()
    )
  );

CREATE POLICY "user_plan_days_insert_own" ON public.user_plan_days
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.user_plans up
      WHERE up.id = user_plan_days.user_plan_id
        AND up.user_id = auth.uid()
    )
  );

CREATE POLICY "user_plan_days_update_own" ON public.user_plan_days
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.user_plans up
      WHERE up.id = user_plan_days.user_plan_id
        AND up.user_id = auth.uid()
    )
  );

-- =============================================================================
-- TABLAS PÚBLICAS (Catálogos) - Lectura pública, escritura restringida
-- =============================================================================

-- bible_versions
ALTER TABLE public.bible_versions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "bible_versions_read_all" ON public.bible_versions
  FOR SELECT USING (true);

-- chat_topics
ALTER TABLE public.chat_topics ENABLE ROW LEVEL SECURITY;
CREATE POLICY "chat_topics_read_all" ON public.chat_topics
  FOR SELECT USING (true);

-- badges
ALTER TABLE public.badges ENABLE ROW LEVEL SECURITY;
CREATE POLICY "badges_read_all" ON public.badges
  FOR SELECT USING (true);

-- daily_verses
ALTER TABLE public.daily_verses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "daily_verses_read_all" ON public.daily_verses
  FOR SELECT USING (true);

-- daily_verse_texts
ALTER TABLE public.daily_verse_texts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "daily_verse_texts_read_all" ON public.daily_verse_texts
  FOR SELECT USING (true);

-- devotions
ALTER TABLE public.devotions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "devotions_read_all" ON public.devotions
  FOR SELECT USING (true);

-- devotion_variants
ALTER TABLE public.devotion_variants ENABLE ROW LEVEL SECURITY;
CREATE POLICY "devotion_variants_read_all" ON public.devotion_variants
  FOR SELECT USING (true);

-- plans
ALTER TABLE public.plans ENABLE ROW LEVEL SECURITY;
CREATE POLICY "plans_read_all" ON public.plans
  FOR SELECT USING (true);

-- plan_days
ALTER TABLE public.plan_days ENABLE ROW LEVEL SECURITY;
CREATE POLICY "plan_days_read_all" ON public.plan_days
  FOR SELECT USING (true);

-- =============================================================================
-- Revocar escritura en catálogos desde cliente
-- =============================================================================
REVOKE INSERT, UPDATE, DELETE ON TABLE public.bible_versions FROM authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.chat_topics FROM authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.badges FROM authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.daily_verses FROM authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.daily_verse_texts FROM authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.devotions FROM authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.devotion_variants FROM authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.plans FROM authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.plan_days FROM authenticated;
