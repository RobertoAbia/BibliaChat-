-- Fix: Corregir registros de daily_activity donde completed=false
-- pero el usuario sí completó las stories ese día.
--
-- Bug: message_limit_service.dart hacía upsert con completed=false,
-- sobrescribiendo el completed=true cuando el usuario enviaba un mensaje
-- DESPUÉS de completar las stories.
--
-- Este SQL corrige los datos corruptos conocidos.
-- El fix en Flutter (message_limit_service.dart) previene que vuelva a pasar.

-- Usuario 61372301-52c3-47f0-874b-802a0dc88a0d - día 29 enero 2026
UPDATE daily_activity
SET completed = true
WHERE user_id = '61372301-52c3-47f0-874b-802a0dc88a0d'
AND activity_date = '2026-01-29'
AND completed = false;
