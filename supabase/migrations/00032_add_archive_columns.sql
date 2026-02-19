-- =============================================================================
-- MIGRACIÓN 00032: Añadir columnas de demografía y consentimiento a archives
-- =============================================================================
-- Descripción: Amplía deleted_user_archives con campos nuevos del perfil:
--              gender, country_code, motive, motive_detail, features
--              + timestamps de consentimiento GDPR (defensa legal)
-- =============================================================================

ALTER TABLE public.deleted_user_archives
  ADD COLUMN IF NOT EXISTS gender TEXT,
  ADD COLUMN IF NOT EXISTS country_code TEXT,
  ADD COLUMN IF NOT EXISTS motive TEXT,
  ADD COLUMN IF NOT EXISTS motive_detail TEXT,
  ADD COLUMN IF NOT EXISTS features TEXT,
  ADD COLUMN IF NOT EXISTS consent_terms_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS consent_data_at TIMESTAMPTZ;
