-- =====================================================================
-- 00036: UNIQUE sobre deleted_user_archives.user_id_hash
-- =====================================================================
-- delete-account ahora hace upsert con onConflict user_id_hash: si un
-- intento anterior archivó los datos pero el deleteUser falló (timeout,
-- rate limit), el reintento ACTUALIZA el archivo en vez de insertar un
-- duplicado. Para eso hace falta la constraint única.
--
-- Primero se eliminan posibles duplicados históricos (conservando el
-- archivo más reciente por hash).
-- =====================================================================

DELETE FROM public.deleted_user_archives a
USING public.deleted_user_archives b
WHERE a.user_id_hash = b.user_id_hash
  AND (a.archived_at < b.archived_at
       OR (a.archived_at = b.archived_at AND a.ctid < b.ctid));

ALTER TABLE public.deleted_user_archives
  ADD CONSTRAINT deleted_user_archives_user_id_hash_key UNIQUE (user_id_hash);
