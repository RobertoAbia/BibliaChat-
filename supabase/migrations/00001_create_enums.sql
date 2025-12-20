-- =============================================================================
-- MIGRACIÓN 00001: Crear tipos ENUM
-- =============================================================================
-- Descripción: Define todos los tipos enumerados usados en la base de datos
-- =============================================================================

-- Denominación cristiana
CREATE TYPE denomination AS ENUM (
  'catolica',
  'evangelica',
  'pentecostal',
  'bautista',
  'metodista',
  'luterana',
  'adventista',
  'ortodoxa',
  'sin_denominacion',
  'otra'
);

-- Grupo de origen cultural
CREATE TYPE origin_group AS ENUM (
  'mexico_centroamerica',
  'caribe',
  'sudamerica',
  'espana',
  'usa_hispano'
);

-- Grupo de edad
CREATE TYPE age_group AS ENUM (
  '18-24',
  '25-34',
  '35-44',
  '45-54',
  '55+'
);

-- Motivo principal de uso
CREATE TYPE motive_type AS ENUM (
  'estudio',
  'sufrimiento',
  'crecimiento',
  'comunidad',
  'habito',
  'otro'
);

-- Estado del plan de estudio
CREATE TYPE plan_status AS ENUM (
  'not_started',
  'in_progress',
  'completed',
  'abandoned'
);

-- Rol en el chat (usuario o asistente IA)
CREATE TYPE chat_role AS ENUM (
  'user',
  'assistant',
  'system'
);

-- Plataforma del dispositivo
CREATE TYPE platform_type AS ENUM (
  'ios',
  'android'
);
