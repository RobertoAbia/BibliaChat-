-- =============================================================================
-- MIGRACIÓN 00005: Crear tablas de contenido diario
-- =============================================================================
-- Descripción: Versículos del día y devociones
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Versículos del día (referencia)
-- -----------------------------------------------------------------------------
CREATE TABLE daily_verses (
  verse_date DATE PRIMARY KEY,
  reference TEXT NOT NULL, -- Ej: "Proverbios 3:5-6"
  context_notes TEXT, -- Notas de contexto histórico
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- -----------------------------------------------------------------------------
-- Textos del versículo por versión de Biblia
-- -----------------------------------------------------------------------------
CREATE TABLE daily_verse_texts (
  verse_date DATE NOT NULL REFERENCES daily_verses(verse_date) ON DELETE CASCADE,
  bible_version_code TEXT NOT NULL REFERENCES bible_versions(code),
  verse_text TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  PRIMARY KEY (verse_date, bible_version_code)
);

-- -----------------------------------------------------------------------------
-- Devociones del día
-- -----------------------------------------------------------------------------
CREATE TABLE devotions (
  devotion_date DATE PRIMARY KEY,
  title TEXT NOT NULL,
  central_verse_reference TEXT, -- Versículo central
  reading_minutes INT DEFAULT 3, -- Tiempo estimado de lectura
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- -----------------------------------------------------------------------------
-- Variantes de devoción por denominación/contexto
-- -----------------------------------------------------------------------------
CREATE TABLE devotion_variants (
  devotion_date DATE NOT NULL REFERENCES devotions(devotion_date) ON DELETE CASCADE,
  variant_key TEXT NOT NULL, -- 'general', 'catolica', 'evangelica', etc.
  content TEXT NOT NULL, -- Contenido completo de la devoción
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  PRIMARY KEY (devotion_date, variant_key)
);

-- -----------------------------------------------------------------------------
-- Tracking de devociones vistas/guardadas por usuario
-- -----------------------------------------------------------------------------
CREATE TABLE user_devotions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  devotion_date DATE NOT NULL REFERENCES devotions(devotion_date),
  viewed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  saved BOOLEAN NOT NULL DEFAULT false,

  -- Un registro por usuario y día
  UNIQUE(user_id, devotion_date)
);

-- -----------------------------------------------------------------------------
-- Actividad diaria (para racha/streak)
-- -----------------------------------------------------------------------------
CREATE TABLE daily_activity (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  activity_date DATE NOT NULL,
  completed BOOLEAN NOT NULL DEFAULT true,
  source TEXT, -- 'devotion', 'chat', 'plan', etc.
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  PRIMARY KEY (user_id, activity_date)
);
