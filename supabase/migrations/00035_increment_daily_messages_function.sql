-- =====================================================================
-- 00035: Contador diario de mensajes ATÓMICO (server-side)
-- =====================================================================
-- Hasta ahora el límite de mensajes free (5/día) solo existía en el
-- cliente Flutter: llamando a la Edge Function chat-send-message
-- directamente con un JWT (incluso anónimo) se obtenía GPT-4o ilimitado.
-- Además el cliente hacía un upsert read-modify-write que incluía la
-- columna `completed`, con una carrera que podía revertir días de racha
-- (la corrupción que 00026 reparó en datos).
--
-- Esta función:
--   * la llama chat-send-message con el JWT del usuario (auth.uid())
--   * incrementa messages_sent de forma atómica
--   * NUNCA toca `completed` en filas existentes; en filas nuevas lo pone
--     explícitamente a false (el DEFAULT de la tabla es true, pensado para
--     el flujo de stories, no para el contador de chat)
--   * devuelve el contador resultante para que la función aplique el tope
-- =====================================================================

CREATE OR REPLACE FUNCTION public.increment_daily_messages(p_activity_date date)
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_count integer;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  INSERT INTO public.daily_activity (user_id, activity_date, completed, source, messages_sent)
  VALUES (v_user_id, p_activity_date, false, 'chat', 1)
  ON CONFLICT (user_id, activity_date)
  DO UPDATE SET messages_sent = COALESCE(public.daily_activity.messages_sent, 0) + 1
  RETURNING messages_sent INTO v_count;

  RETURN v_count;
END;
$$;

REVOKE ALL ON FUNCTION public.increment_daily_messages(date) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.increment_daily_messages(date) TO authenticated;
