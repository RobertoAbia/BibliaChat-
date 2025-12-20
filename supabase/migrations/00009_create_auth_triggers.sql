-- =============================================================================
-- MIGRACIÓN 00009: Triggers de autenticación
-- =============================================================================
-- Descripción: Auto-crear registros relacionados cuando un usuario se registra
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Función para crear perfil y registros relacionados al registrarse
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  -- Crear perfil de usuario
  INSERT INTO public.user_profiles (user_id)
  VALUES (NEW.id)
  ON CONFLICT (user_id) DO NOTHING;

  -- Crear registro de puntos
  INSERT INTO public.user_points (user_id, total_points)
  VALUES (NEW.id, 0)
  ON CONFLICT (user_id) DO NOTHING;

  -- Crear registro de entitlements (free por defecto)
  INSERT INTO public.user_entitlements (user_id, is_premium, trial_active)
  VALUES (NEW.id, false, false)
  ON CONFLICT (user_id) DO NOTHING;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- -----------------------------------------------------------------------------
-- Trigger que se ejecuta cuando se crea un nuevo usuario
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- -----------------------------------------------------------------------------
-- Función para limpiar datos al eliminar usuario
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_user_deleted()
RETURNS TRIGGER AS $$
BEGIN
  -- Los CASCADE en las FK se encargan de borrar todo
  -- Esta función es por si necesitamos lógica adicional en el futuro
  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger opcional para cuando se elimina un usuario
CREATE OR REPLACE TRIGGER on_auth_user_deleted
  BEFORE DELETE ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_user_deleted();
