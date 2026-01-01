-- =============================================================================
-- MIGRACIÓN 00014: Añadir tracking de resumen en chats
-- =============================================================================
-- Descripción: Campo para saber cuándo regenerar context_summary y ai_memory
-- =============================================================================

-- Número de mensajes cuando se generó el último resumen
ALTER TABLE chats ADD COLUMN last_summary_message_count INT NOT NULL DEFAULT 0;

-- Comentario para documentar
COMMENT ON COLUMN chats.last_summary_message_count IS 'Número de mensajes cuando se generó el último context_summary. Se regenera cada 20 mensajes nuevos.';
