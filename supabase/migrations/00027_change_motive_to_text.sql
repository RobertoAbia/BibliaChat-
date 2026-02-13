-- Cambiar columna motive de enum motive_type a text
-- para soportar multi-select con nuevas keys (talk_faith, daily_reflection, guided_plans)
-- Los valores existentes (estudio, sufrimiento) se preservan como strings
-- Renombrar a "features" para reflejar mejor su propósito

ALTER TABLE public.user_profiles
  ALTER COLUMN motive TYPE text USING motive::text;

ALTER TABLE public.user_profiles
  RENAME COLUMN motive TO features;
