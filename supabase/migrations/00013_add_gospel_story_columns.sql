-- Migration: Add columns for Instagram Stories-style gospel display
-- key_concept: Main phrase/concept from the passage
-- practical_exercise: Practical action for the day

ALTER TABLE public.daily_verse_texts
ADD COLUMN key_concept text,
ADD COLUMN practical_exercise text;

COMMENT ON COLUMN public.daily_verse_texts.key_concept IS
'Concepto/frase principal del pasaje, generado por OpenAI';

COMMENT ON COLUMN public.daily_verse_texts.practical_exercise IS
'Ejercicio práctico para aplicar el pasaje en el día, generado por OpenAI';
