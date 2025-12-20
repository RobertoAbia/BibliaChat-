-- =============================================================================
-- MIGRACIÓN 00008: Índices para optimización de queries
-- =============================================================================
-- Descripción: Índices para mejorar rendimiento de consultas frecuentes
-- =============================================================================

-- =============================================================================
-- USER_PROFILES
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_user_profiles_updated_at
  ON public.user_profiles(updated_at);

-- =============================================================================
-- USER_DEVICES (FCM)
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_user_devices_user_last_seen
  ON public.user_devices(user_id, last_seen_at DESC);

CREATE INDEX IF NOT EXISTS idx_user_devices_token
  ON public.user_devices(device_token);

-- =============================================================================
-- USER_ENTITLEMENTS (premium gating)
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_user_entitlements_premium_expires
  ON public.user_entitlements(is_premium, expires_at);

CREATE INDEX IF NOT EXISTS idx_user_entitlements_last_synced
  ON public.user_entitlements(last_synced_at DESC);

-- =============================================================================
-- CHATS (Mis Chats)
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_chats_user_last_message
  ON public.chats(user_id, last_message_at DESC NULLS LAST);

CREATE INDEX IF NOT EXISTS idx_chats_user_topic_key
  ON public.chats(user_id, topic_key);

CREATE INDEX IF NOT EXISTS idx_chats_user_updated_at
  ON public.chats(user_id, updated_at DESC);

-- =============================================================================
-- CHAT_MESSAGES (mensajes por chat + paginación)
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_chat_messages_chat_created
  ON public.chat_messages(chat_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_chat_messages_created_at
  ON public.chat_messages(created_at DESC);

-- =============================================================================
-- SAVED_MESSAGES
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_saved_messages_user_saved_at
  ON public.saved_messages(user_id, saved_at DESC);

CREATE INDEX IF NOT EXISTS idx_saved_messages_chat_message_id
  ON public.saved_messages(chat_message_id);

-- =============================================================================
-- USER_DEVOTIONS
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_user_devotions_user_date
  ON public.user_devotions(user_id, devotion_date DESC);

-- =============================================================================
-- DAILY_ACTIVITY (racha)
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_daily_activity_user_date
  ON public.daily_activity(user_id, activity_date DESC);

CREATE INDEX IF NOT EXISTS idx_daily_activity_user_completed_date
  ON public.daily_activity(user_id, completed, activity_date DESC);

-- =============================================================================
-- CONTENT LOOKUPS (HOY)
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_daily_verse_texts_date_version
  ON public.daily_verse_texts(verse_date, bible_version_code);

CREATE INDEX IF NOT EXISTS idx_devotion_variants_date_variant
  ON public.devotion_variants(devotion_date, variant_key);

-- =============================================================================
-- PLANS + PLAN_DAYS
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_plans_active_premium
  ON public.plans(is_active, is_premium);

CREATE INDEX IF NOT EXISTS idx_plan_days_plan_day
  ON public.plan_days(plan_id, day_number);

-- =============================================================================
-- USER_PLANS + USER_PLAN_DAYS
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_user_plans_user_status_updated
  ON public.user_plans(user_id, status, updated_at DESC);

CREATE INDEX IF NOT EXISTS idx_user_plans_user_plan
  ON public.user_plans(user_id, plan_id);

CREATE INDEX IF NOT EXISTS idx_user_plan_days_user_plan_day
  ON public.user_plan_days(user_plan_id, day_number);

CREATE INDEX IF NOT EXISTS idx_user_plan_days_completed_at
  ON public.user_plan_days(completed_at DESC);

-- =============================================================================
-- CATALOGS
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_chat_topics_active_sort
  ON public.chat_topics(is_active, sort_order);

CREATE INDEX IF NOT EXISTS idx_badges_active_sort
  ON public.badges(is_active, sort_order);

CREATE INDEX IF NOT EXISTS idx_bible_versions_active
  ON public.bible_versions(is_active);
