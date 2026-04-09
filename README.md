# DBsamples (PostgreSQL + Chinook)

Este proyecto contiene ejemplos practicos de uso de bases de datos en **PostgreSQL** usando la base de datos **Chinook**. La idea es tener consultas listas para estudiar y practicar: agregaciones, subconsultas, CTEs y diferentes tipos de `JOIN`.

**Que incluye**
- `Chinook_PostgreSQL.sql`: script de creacion y datos de la base Chinook.
- `samples.sql`: consultas variadas por nivel (basico, joins, agregados, window).
- `joins-ejemplos.sql`: ejemplos y explicacion de los tipos de `JOIN`.
- `chinook-ejemplos.sql`: ejemplos con `JOINs`, `subqueries` y `window functions`.
- `ddl-ejemplos.sql`: ejemplos de definicion de datos (DDL).
- `dcl-ejemplos.sql`: ejemplos de control de acceso (DCL).
- `album_data_utf8.sql`: datos extra en UTF-8.

**Como usar**
1. Carga la base Chinook en tu servidor PostgreSQL.
2. Ejecuta los archivos `.sql` para ver los ejemplos.

Archivos de ejemplos recomendados:
- `joins-ejemplos.sql`
- `chinook-ejemplos.sql`

**Objetivo de cada archivo de ejemplos**
- `joins-ejemplos.sql`: ejemplos de tipos de JOIN y casos habituales.
- `chinook-ejemplos.sql`: joins, subqueries y window functions en contexto Chinook.
- `ddl-ejemplos.sql`: crear, alterar y borrar objetos (schema, tablas, vistas, indices).
- `dcl-ejemplos.sql`: grants, revokes, privilegios por defecto, secuencias y funciones.
- `dml-select-ejemplos.sql`: lecturas basicas con filtros y patrones.
- `unions-ejemplos.sql`: combinacion de resultados entre tablas.
- `comparacion-ejemplos.sql`: operadores y expresiones de comparacion.
- `funciones-nativas-ejemplos.sql`: funciones comunes de texto, numero y fecha.
- `funciones-agregacion-ejemplos.sql`: sumas, medias y agregaciones por grupo.
- `funciones-cadena-ejemplos.sql`: manejo y limpieza de texto.
- `funciones-numericas-ejemplos.sql`: operaciones matematicas utiles.
- `funciones-fecha-hora-ejemplos.sql`: fechas, intervalos y extracciones.
- `otras-funciones-ejemplos.sql`: funciones utiles (coalesce, nullif, greatest).
- `funciones-control-flujo-ejemplos.sql`: clasificacion con CASE.
- `funciones-conversion-ejemplos.sql`: conversion de tipos y formatos.
- `funciones-sistema-ejemplos.sql`: informacion del servidor y sesion.
- `funciones-cifrado-ejemplos.sql`: hashes basicos y pgcrypto.
- `insert-ejemplos.sql`: insercion segura con tabla temporal.
- `update-ejemplos.sql`: actualizacion segura con tabla temporal.
- `delete-ejemplos.sql`: borrado seguro con tabla temporal.

Si quieres mas ejemplos o ejercicios, dímelo y los añadimos.
