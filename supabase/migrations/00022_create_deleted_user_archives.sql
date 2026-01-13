-- =============================================================================
-- MIGRACIÓN 00022: Create deleted_user_archives table
-- =============================================================================
-- Descripción: Tabla para archivar datos pseudonimizados de usuarios borrados
--              Retención: 3 años para defensa legal
--              Pseudonimización: hash SHA256 del user_id (GDPR-compliant)
-- =============================================================================

CREATE TABLE public.deleted_user_archives (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Identificador pseudonimizado (SHA256 del user_id)
  -- Permite buscar SI el usuario se identifica primero
  user_id_hash TEXT NOT NULL,

  -- Metadatos del archivo
  archived_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at TIMESTAMPTZ NOT NULL DEFAULT (now() + INTERVAL '3 years'),
  original_user_created_at TIMESTAMPTZ,

  -- Demografía (no identifica por sí sola)
  denomination TEXT,
  origin_group TEXT,
  age_group TEXT,

  -- Historial de chats (contenido sin user_id directo)
  chat_messages JSONB,  -- Array de {role, content, created_at}

  -- Progreso de planes
  plans_data JSONB,     -- Array de {plan_name, status, days_completed}

  -- Métricas agregadas
  total_messages INT,
  total_plans_started INT,
  total_plans_completed INT,
  streak_max INT
);

-- Índice para búsqueda por hash (cuando usuario se identifica)
CREATE INDEX idx_deleted_archives_hash ON deleted_user_archives(user_id_hash);

-- Solo admins pueden acceder (service_role)
ALTER TABLE deleted_user_archives ENABLE ROW LEVEL SECURITY;
-- No hay políticas para authenticated - solo service_role puede acceder
