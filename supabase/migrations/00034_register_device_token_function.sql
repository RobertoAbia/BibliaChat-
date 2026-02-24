-- =============================================================================
-- Función SECURITY DEFINER para registrar token FCM
-- Resuelve: RLS bloquea upsert cuando el mismo device_token pertenece a otro usuario
-- (ej: mismo dispositivo usado por cuenta anónima anterior)
-- =============================================================================

CREATE OR REPLACE FUNCTION public.register_device_token(
  p_token TEXT,
  p_platform platform_type
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Borrar token viejo (puede pertenecer a otro usuario)
  DELETE FROM public.user_devices WHERE device_token = p_token;

  -- Insertar para el usuario actual
  INSERT INTO public.user_devices (user_id, device_token, platform, last_seen_at)
  VALUES (auth.uid(), p_token, p_platform, now());
END;
$$;
