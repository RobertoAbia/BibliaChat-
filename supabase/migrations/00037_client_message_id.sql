-- =====================================================================
-- 00037: Idempotencia de mensajes del chat
-- =====================================================================
-- Si OpenAI falla DESPUÉS de guardar el mensaje del usuario, el reintento
-- desde la app volvía a insertarlo (duplicado en historial y en el prompt).
-- La app ahora envía un client_message_id (UUID generado por intento de
-- contenido, reutilizado en el reintento) y la Edge Function, al chocar con
-- este UNIQUE, reutiliza el mensaje ya guardado en vez de duplicarlo.
--
-- Índice parcial: los mensajes del asistente y los históricos (NULL) no
-- participan.
-- =====================================================================

ALTER TABLE public.chat_messages
  ADD COLUMN IF NOT EXISTS client_message_id UUID;

CREATE UNIQUE INDEX IF NOT EXISTS idx_chat_messages_client_id
  ON public.chat_messages(chat_id, client_message_id)
  WHERE client_message_id IS NOT NULL;
