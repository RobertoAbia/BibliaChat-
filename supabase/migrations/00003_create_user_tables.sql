-- =============================================================================
-- MIGRACIÓN 00003: Crear tablas de usuario
-- =============================================================================
-- Descripción: Perfiles, dispositivos y entitlements de usuarios
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Perfil del usuario (1:1 con auth.users)
-- -----------------------------------------------------------------------------
CREATE TABLE user_profiles (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT,
  denomination denomination,
  origin origin_group,
  age_group age_group,
  motive motive_type,
  reminder_enabled BOOLEAN NOT NULL DEFAULT false,
  reminder_time TIME,
  persistence_self_report BOOLEAN,
  first_message TEXT, -- "¿Qué hay en tu corazón?"
  bible_version_code TEXT REFERENCES bible_versions(code) DEFAULT 'RVR1960',
  ai_memory JSONB, -- Memoria global para personalización IA
  timezone TEXT DEFAULT 'America/New_York',
  onboarding_completed BOOLEAN NOT NULL DEFAULT false,
  theme TEXT DEFAULT 'auto', -- 'light', 'dark', 'auto'
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Trigger para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_user_profiles_updated_at
  BEFORE UPDATE ON user_profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- -----------------------------------------------------------------------------
-- Dispositivos del usuario (para push notifications)
-- -----------------------------------------------------------------------------
CREATE TABLE user_devices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  platform platform_type NOT NULL,
  device_token TEXT NOT NULL,
  last_seen_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Un token por dispositivo
  UNIQUE(device_token)
);

CREATE TRIGGER update_user_devices_updated_at
  BEFORE UPDATE ON user_devices
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- -----------------------------------------------------------------------------
-- Estado de suscripción/premium del usuario
-- -----------------------------------------------------------------------------
CREATE TABLE user_entitlements (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  is_premium BOOLEAN NOT NULL DEFAULT false,
  trial_active BOOLEAN NOT NULL DEFAULT false,
  trial_started_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  last_synced_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  source TEXT, -- 'revenuecat', 'manual', etc.
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER update_user_entitlements_updated_at
  BEFORE UPDATE ON user_entitlements
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- -----------------------------------------------------------------------------
-- Puntos acumulados del usuario
-- -----------------------------------------------------------------------------
CREATE TABLE user_points (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  total_points INT NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER update_user_points_updated_at
  BEFORE UPDATE ON user_points
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- -----------------------------------------------------------------------------
-- Badges ganados por el usuario
-- -----------------------------------------------------------------------------
CREATE TABLE user_badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  badge_key TEXT NOT NULL REFERENCES badges(key),
  earned_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Un badge solo se puede ganar una vez
  UNIQUE(user_id, badge_key)
);
