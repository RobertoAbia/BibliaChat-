-- =============================================================================
-- MIGRACIÓN 00006: Crear tablas de planes de estudio
-- =============================================================================
-- Descripción: Planes, días de plan y progreso del usuario
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Planes de estudio (catálogo)
-- -----------------------------------------------------------------------------
CREATE TABLE plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  short_description TEXT, -- Para cards
  days_total INT NOT NULL CHECK (days_total > 0),
  icon TEXT, -- emoji o nombre de icono
  target_audience TEXT, -- "Para migrantes, padres separados"
  is_premium BOOLEAN NOT NULL DEFAULT false,
  is_active BOOLEAN NOT NULL DEFAULT true,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- -----------------------------------------------------------------------------
-- Días de cada plan (contenido)
-- -----------------------------------------------------------------------------
CREATE TABLE plan_days (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id UUID NOT NULL REFERENCES plans(id) ON DELETE CASCADE,
  day_number INT NOT NULL CHECK (day_number > 0),
  verse_references TEXT[] NOT NULL, -- Array de referencias bíblicas
  reflection TEXT NOT NULL, -- Reflexión del día (150-200 palabras)
  question TEXT NOT NULL, -- Pregunta abierta
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Un solo día por número en cada plan
  UNIQUE(plan_id, day_number)
);

-- -----------------------------------------------------------------------------
-- Instancias de plan por usuario (progreso)
-- -----------------------------------------------------------------------------
CREATE TABLE user_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  plan_id UUID NOT NULL REFERENCES plans(id),
  status plan_status NOT NULL DEFAULT 'in_progress',
  current_day INT NOT NULL DEFAULT 1,
  started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Un usuario puede tener un plan activo a la vez por plan_id
  UNIQUE(user_id, plan_id)
);

CREATE TRIGGER update_user_plans_updated_at
  BEFORE UPDATE ON user_plans
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- -----------------------------------------------------------------------------
-- Progreso diario del plan (respuestas del usuario)
-- -----------------------------------------------------------------------------
CREATE TABLE user_plan_days (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_plan_id UUID NOT NULL REFERENCES user_plans(id) ON DELETE CASCADE,
  day_number INT NOT NULL,
  user_answer TEXT, -- Respuesta a la pregunta del día
  completed_via TEXT, -- 'answer', 'chat', 'skip'
  completed_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Un registro por día por plan del usuario
  UNIQUE(user_plan_id, day_number)
);

-- -----------------------------------------------------------------------------
-- Insertar los 7 planes MVP
-- -----------------------------------------------------------------------------
INSERT INTO plans (name, description, short_description, days_total, icon, target_audience, sort_order) VALUES
(
  'Fe Cuando Familia Está Lejos',
  'Un plan de 7 días para quienes viven separados de sus seres queridos. Exploraremos cómo mantener la fe cuando la distancia duele, encontrando consuelo en las Escrituras y fortaleza en la oración.',
  'Para migrantes separados de familiares',
  7,
  '🏠',
  'Migrantes, padres separados de hijos',
  1
),
(
  'Trabajo y Provisión Divina',
  'Un plan de 5 días para tiempos de incertidumbre laboral. Descubre cómo confiar en Dios cuando el trabajo escasea y aprende a ver Su provisión en medio de las dificultades.',
  'Cuando el trabajo escasea',
  5,
  '💼',
  'Desempleados, explotados laboralmente',
  2
),
(
  'Soltería Enraizada en Cristo',
  'Un plan de 7 días para vivir la soltería con propósito y gozo. No es una sala de espera, sino una temporada de crecimiento y servicio.',
  'Vivir la soltería con propósito',
  7,
  '💝',
  'Jóvenes solteros, divorciados',
  3
),
(
  'Resiste la Ansiedad con Fe',
  'Un plan de 5 días para encontrar paz en medio de la tormenta. Aprende a entregar tus preocupaciones a Dios y experimentar Su paz que sobrepasa todo entendimiento.',
  'Encontrar paz en tiempos difíciles',
  5,
  '🕊️',
  'Quienes sufren ansiedad, estrés',
  4
),
(
  'Gratitud en Medio del Caos',
  'Un plan de 5 días para cultivar un corazón agradecido incluso cuando todo parece ir mal. La gratitud transforma nuestra perspectiva y nos acerca a Dios.',
  'Cultivar gratitud en tiempos difíciles',
  5,
  '🙏',
  'Quienes luchan con amargura o depresión',
  5
),
(
  'Discípulo en Dos Idiomas',
  'Un plan de 7 días para quienes viven entre dos culturas. Explora cómo tu identidad bicultural es un regalo de Dios y cómo vivirla con integridad.',
  'Fe entre dos mundos',
  7,
  '🌎',
  'Segunda/tercera generación, bilingües',
  6
),
(
  'Sanidad del Corazón Inmigrante',
  'Un plan de 7 días para procesar el trauma y dolor de la experiencia migratoria. Dios ve tu dolor y quiere sanarte.',
  'Sanar heridas del camino',
  7,
  '❤️‍🩹',
  'Quienes cargan trauma migratorio',
  7
);
