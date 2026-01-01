-- =============================================================================
-- MIGRACIÓN 00015: Sistema de Chat Híbrido
-- =============================================================================
-- Descripción: Permite múltiples chats por usuario + topics de Stories
-- =============================================================================

-- -----------------------------------------------------------------------------
-- A) Añadir topics para Stories (evangelio/lectura del día)
-- -----------------------------------------------------------------------------
INSERT INTO chat_topics (key, title, description, sort_order, is_active, is_premium) VALUES
  ('evangelio_del_dia', 'Evangelio del día', 'Conversación sobre el evangelio del día', 11, true, false),
  ('lectura_del_dia', 'Lectura del día', 'Conversación sobre la lectura bíblica del día', 12, true, false)
ON CONFLICT (key) DO NOTHING;

-- -----------------------------------------------------------------------------
-- B) Quitar constraint UNIQUE para permitir múltiples chats
-- -----------------------------------------------------------------------------
-- Antes: Un usuario solo podía tener 1 chat por topic
-- Ahora: Un usuario puede tener múltiples chats (con o sin topic)
ALTER TABLE chats DROP CONSTRAINT IF EXISTS chats_user_id_topic_key_key;

-- -----------------------------------------------------------------------------
-- C) Añadir índice para búsqueda de chats por usuario
-- -----------------------------------------------------------------------------
-- Ya existe idx_chats_user_last_message, pero añadimos uno más específico
CREATE INDEX IF NOT EXISTS idx_chats_user_id ON chats(user_id);

-- Comentario para documentar el cambio
COMMENT ON TABLE chats IS 'Conversaciones de chat. Un usuario puede tener múltiples chats, con o sin topic_key asociado.';
