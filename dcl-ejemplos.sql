/*
  DCL: control de acceso (PostgreSQL)
  Nota: crear roles requiere permisos de administrador.
*/

/* 1) CREATE ROLE (si tienes permisos)
   Uso habitual: definir usuarios o roles de aplicacion con politicas. */
-- CREATE ROLE app_reader LOGIN PASSWORD 'change_me';

/* 2) GRANT privilegios a nivel de esquema
   Uso habitual: permitir uso de objetos en un esquema (USAGE). */
-- GRANT USAGE ON SCHEMA public TO app_reader;

/* 3) GRANT SELECT sobre tablas
   Uso habitual: dar acceso de solo lectura a todas las tablas del esquema. */
-- GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_reader;

/* 4) DEFAULT PRIVILEGES
   Uso habitual: aplicar permisos automaticamente a nuevas tablas. */
-- ALTER DEFAULT PRIVILEGES IN SCHEMA public
-- GRANT SELECT ON TABLES TO app_reader;

/* 5) REVOKE privilegios
   Uso habitual: retirar accesos cuando ya no se necesitan. */
-- REVOKE SELECT ON ALL TABLES IN SCHEMA public FROM app_reader;

/* 6) DROP ROLE (si procede)
   Uso habitual: eliminar roles obsoletos. */

/* 7) GRANT por columnas
   Uso habitual: exponer solo campos permitidos (PII). */
-- GRANT SELECT (first_name, last_name, email) ON customer TO app_reader;

/* 8) GRANT de escritura en tablas concretas
   Uso habitual: permitir INSERT/UPDATE/DELETE a una app. */
-- GRANT INSERT, UPDATE, DELETE ON customer TO app_writer;

/* 9) REVOKE por columnas
   Uso habitual: retirar acceso a un campo sensible. */
-- REVOKE SELECT (email) ON customer FROM app_reader;

/* 10) GRANT sobre secuencias
   Uso habitual: permitir usar nextval() en ids SERIAL. */
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_writer;

/* 11) GRANT sobre funciones
   Uso habitual: permitir ejecutar funciones concretas. */
-- GRANT EXECUTE ON FUNCTION public.my_function(integer) TO app_reader;

/* 12) DEFAULT PRIVILEGES para secuencias
   Uso habitual: aplicar permisos automaticamente a nuevas secuencias. */
-- ALTER DEFAULT PRIVILEGES IN SCHEMA public
-- GRANT USAGE, SELECT ON SEQUENCES TO app_writer;
-- DROP ROLE app_reader;
