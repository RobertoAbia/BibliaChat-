-- =============================================================================
-- MIGRACIÓN 00020: Add DELETE policy for user_plan_days
-- =============================================================================
-- Descripción: Permite a los usuarios borrar sus propios registros de días
--              completados (necesario para reiniciar un plan)
-- =============================================================================

CREATE POLICY "user_plan_days_delete_own" ON public.user_plan_days
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM public.user_plans up
      WHERE up.id = user_plan_days.user_plan_id
        AND up.user_id = auth.uid()
    )
  );
