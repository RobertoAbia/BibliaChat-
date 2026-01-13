-- =============================================================================
-- MIGRACIÓN 00021: Add topic keys for study plans
-- =============================================================================
-- Descripción: Añade los topic_key de los 7 planes de estudio a chat_topics
--              para que los chats de planes puedan usar el foreign key
-- =============================================================================

INSERT INTO public.chat_topics (key, title, description, sort_order) VALUES
  ('plan_soberbia', 'Plan: Soberbia', 'Conversación sobre el plan De la soberbia a la humildad', 100),
  ('plan_avaricia', 'Plan: Avaricia', 'Conversación sobre el plan De la avaricia a la generosidad', 101),
  ('plan_lujuria', 'Plan: Lujuria', 'Conversación sobre el plan De la lujuria a la pureza', 102),
  ('plan_ira', 'Plan: Ira', 'Conversación sobre el plan De la ira a la paciencia', 103),
  ('plan_gula', 'Plan: Gula', 'Conversación sobre el plan De la gula a la templanza', 104),
  ('plan_envidia', 'Plan: Envidia', 'Conversación sobre el plan De la envidia a la gratitud', 105),
  ('plan_pereza', 'Plan: Pereza', 'Conversación sobre el plan De la pereza a la diligencia', 106);
