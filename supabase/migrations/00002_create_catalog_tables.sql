-- =============================================================================
-- MIGRACIÓN 00002: Crear tablas de catálogo
-- =============================================================================
-- Descripción: Tablas de referencia/catálogo (lectura pública)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Versiones de la Biblia disponibles
-- -----------------------------------------------------------------------------
CREATE TABLE bible_versions (
  code TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Insertar versiones iniciales
INSERT INTO bible_versions (code, name) VALUES
  ('RVR1960', 'Reina-Valera 1960'),
  ('NVI', 'Nueva Versión Internacional'),
  ('LBLA', 'La Biblia de las Américas'),
  ('NTV', 'Nueva Traducción Viviente'),
  ('DHH', 'Dios Habla Hoy');

-- -----------------------------------------------------------------------------
-- Temas de conversación para el chat
-- -----------------------------------------------------------------------------
CREATE TABLE chat_topics (
  key TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  sort_order INT NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_premium BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Insertar los 10 temas del PRD
INSERT INTO chat_topics (key, title, description, sort_order) VALUES
  ('familia_separada', 'Oración por familia separada', 'Para quienes tienen familiares lejos', 1),
  ('desempleo', 'Fe en desempleo', 'Cuando el trabajo escasea', 2),
  ('solteria', 'Soltería cristiana', 'Vivir la soltería con propósito', 3),
  ('ansiedad_miedo', 'Ansiedad y miedo', 'Encontrar paz en tiempos difíciles', 4),
  ('identidad_bicultural', 'Identidad bicultural', 'Entre dos mundos y culturas', 5),
  ('reconciliacion', 'Reconciliación familiar', 'Sanar relaciones rotas', 6),
  ('sacramentos', 'Bautismo / Confirmación', 'Preguntas sobre sacramentos', 7),
  ('oracion', 'Oración personalizada', 'Orar juntos sobre tu situación', 8),
  ('preguntas_biblia', 'Preguntas sobre la Biblia', 'Dudas y estudios bíblicos', 9),
  ('otro', 'Otro tema', 'Cualquier otra cosa en tu corazón', 10);

-- -----------------------------------------------------------------------------
-- Insignias/Logros disponibles
-- -----------------------------------------------------------------------------
CREATE TABLE badges (
  key TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  icon TEXT, -- emoji o nombre de icono
  points_required INT DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Insertar badges iniciales del PRD
INSERT INTO badges (key, title, description, icon, sort_order) VALUES
  ('primer_plan', 'Primer Plan Completado', 'Completaste tu primer plan de estudio', '🏅', 1),
  ('cinco_planes', '5 Planes Completados', 'Has completado 5 planes de estudio', '🏆', 2),
  ('racha_7', 'Semana de Fe', '7 días consecutivos usando la app', '🔥', 3),
  ('racha_30', 'Mes de Fe', '30 días consecutivos usando la app', '🔥', 4),
  ('racha_100', 'Centenario', '100 días consecutivos usando la app', '💯', 5),
  ('expert_studier', 'Estudiante Experto', 'Has completado 10 planes de estudio', '👨‍🎓', 6);
