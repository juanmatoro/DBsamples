/*
  Funciones de sistema
*/

/* 1) CURRENT_USER y SESSION_USER
   Uso habitual: diagnostico de sesiones y permisos. */
SELECT CURRENT_USER AS current_user, SESSION_USER AS session_user;

/* 2) VERSION
   Uso habitual: identificar version del servidor. */
SELECT VERSION() AS pg_version;

/* 3) CURRENT_SETTING
   Uso habitual: consultar parametros activos del servidor. */
SELECT CURRENT_SETTING('server_version') AS server_version;
