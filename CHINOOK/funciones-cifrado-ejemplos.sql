/*
  Funciones de cifrado (PostgreSQL)
  Nota: md5() viene incorporada. Otras funciones requieren la extension pgcrypto.
*/

/* 1) md5
   Uso habitual: generar hashes simples (no recomendado para seguridad fuerte). */
SELECT md5('chinook') AS md5_hash;

/* 2) sha256 con pgcrypto (requiere extension)
   Uso habitual: hash mas robusto para verificacion de integridad.
   Ejecuta primero: CREATE EXTENSION IF NOT EXISTS pgcrypto; */
-- SELECT encode(digest('chinook', 'sha256'), 'hex') AS sha256_hash;
