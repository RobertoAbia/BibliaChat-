-- Renombrar first_message a motive
-- Ahora guarda la key de motivación de fe (difficult_moment, spiritual_growth, etc.)
-- en vez de un texto libre

ALTER TABLE public.user_profiles
  RENAME COLUMN first_message TO motive;
