-- =============================================================================
-- MIGRACIÓN 00033: Añadir email_hash a deleted_user_archives
-- =============================================================================
-- Descripción: Permite identificar registros archivados por email en caso de
--              reclamación legal. SHA256 del email = pseudonimizado (no PII).
--              Búsqueda: WHERE email_hash = encode(digest('email@example.com', 'sha256'), 'hex')
-- =============================================================================

ALTER TABLE public.deleted_user_archives
  ADD COLUMN IF NOT EXISTS email_hash TEXT;
