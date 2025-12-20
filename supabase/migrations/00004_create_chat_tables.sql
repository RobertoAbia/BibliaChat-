-- =============================================================================
-- MIGRACIÓN 00004: Crear tablas de conversación/chat
-- =============================================================================
-- Descripción: Chats, mensajes y mensajes guardados
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Conversaciones/Hilos de chat
-- -----------------------------------------------------------------------------
CREATE TABLE chats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  topic_key TEXT REFERENCES chat_topics(key),
  title TEXT, -- Título personalizado opcional
  openai_conversation_id TEXT, -- Reservado para futura integración (NULL en MVP)
  context_summary TEXT, -- Resumen del contexto para optimizar IA
  last_message_at TIMESTAMPTZ,
  last_message_preview TEXT, -- Preview del último mensaje para lista
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- En MVP: un solo chat por tema por usuario
  UNIQUE(user_id, topic_key)
);

CREATE TRIGGER update_chats_updated_at
  BEFORE UPDATE ON chats
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- -----------------------------------------------------------------------------
-- Mensajes dentro de cada chat
-- -----------------------------------------------------------------------------
CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chat_id UUID NOT NULL REFERENCES chats(id) ON DELETE CASCADE,
  role chat_role NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- -----------------------------------------------------------------------------
-- Mensajes guardados por el usuario (reflexiones)
-- -----------------------------------------------------------------------------
CREATE TABLE saved_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  chat_message_id UUID NOT NULL REFERENCES chat_messages(id) ON DELETE CASCADE,
  saved_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- No guardar el mismo mensaje dos veces
  UNIQUE(user_id, chat_message_id)
);
