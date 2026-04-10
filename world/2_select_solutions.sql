-- =====================================================================
-- Soluciones a 2_select.md sobre la BD world.sql (countries-states-cities)
-- Notas:
--   * No hay columna 'continent' -> se usa 'region'
--   * No hay 'government_form' ni tabla de idiomas -> se adaptan los
--     ejercicios 3 y 4 (ver comentarios en cada bloque)
--   * Se usa TO_CHAR(...) para mostrar números con separadores de miles
-- =====================================================================


-- =========================== EJERCICIO 1 =============================

-- Listar todos los países con su población y su extensión (alias en español)
SELECT
    name AS pais,
    TO_CHAR(population, '999G999G999G999') AS poblacion,
    TO_CHAR(area_sq_km, '999G999G999')     AS extension
FROM countries LIMIT 10;

-- Añadir un elemento calculado: la densidad
SELECT
    name AS pais,
    TO_CHAR(population, '999G999G999G999')                       AS poblacion,
    TO_CHAR(area_sq_km, '999G999G999')                           AS extension,
    TO_CHAR(population / NULLIF(area_sq_km, 0), '999G999G990D99') AS densidad
FROM countries LIMIT 10;

-- Los 10 primeros países
SELECT
    name AS pais,
    TO_CHAR(population, '999G999G999G999') AS poblacion,
    TO_CHAR(area_sq_km, '999G999G999')     AS extension
FROM countries
LIMIT 10;

-- Países entre el 10 y el 20 (los 10 siguientes)
SELECT
    name AS pais,
    TO_CHAR(population, '999G999G999G999') AS poblacion,
    TO_CHAR(area_sq_km, '999G999G999')     AS extension
FROM countries
LIMIT 10 OFFSET 10;

-- Ordenar la salida según población (sin verla)
SELECT
    name AS pais,
    TO_CHAR(area_sq_km, '999G999G999') AS extension
FROM countries
ORDER BY population DESC;

-- Ver la población y comprobar el orden
SELECT
    name AS pais,
    TO_CHAR(population, '999G999G999G999') AS poblacion,
    TO_CHAR(area_sq_km, '999G999G999')     AS extension
FROM countries
ORDER BY population DESC;


-- =========================== EJERCICIO 2 =============================

-- Países de Asia o África de 4 letras, ordenados por población
SELECT
    name   AS pais,
    region,
    TO_CHAR(population, '999G999G999G999') AS poblacion
FROM countries
WHERE region IN ('Asia', 'Africa')
  AND length(name) = 4
ORDER BY population DESC;

-- Del 10 al 20 de los países con población > 1.000.000, orden por población
SELECT
    name AS pais,
    TO_CHAR(population, '999G999G999G999') AS poblacion
FROM countries
WHERE population > 1000000
ORDER BY population DESC
LIMIT 10 OFFSET 10;

-- Países con densidad > 500
SELECT
    name AS pais,
    TO_CHAR(population, '999G999G999G999')                       AS poblacion,
    TO_CHAR(area_sq_km, '999G999G999')                           AS extension,
    TO_CHAR(population / NULLIF(area_sq_km, 0), '999G999G990D99') AS densidad
FROM countries
WHERE population / NULLIF(area_sq_km, 0) > 500
ORDER BY population / NULLIF(area_sq_km, 0) DESC;

-- Los 10 países de mayor extensión, ordenados por su población
SELECT
    pais,
    TO_CHAR(extension,  '999G999G999')     AS extension,
    TO_CHAR(poblacion,  '999G999G999G999') AS poblacion
FROM (
    SELECT name AS pais, area_sq_km AS extension, population AS poblacion
    FROM   countries
    ORDER  BY area_sq_km DESC
    LIMIT  10
) AS top10
ORDER BY poblacion DESC;


-- =========================== EJERCICIO 3 =============================
-- Original pide "forma de gobierno", que no existe en esta BD.
-- Se sustituye por 'region' (continente) como dato adicional.

-- Ciudades > 1.000.000 hab. de Asia y África con su país y región
SELECT
    ci.name   AS ciudad,
    co.name   AS pais,
    co.region AS continente,
    TO_CHAR(ci.population, '999G999G999G999') AS poblacion
FROM   cities    ci
JOIN   countries co ON co.id = ci.country_id
WHERE  co.region IN ('Asia', 'Africa')
  AND  ci.population > 1000000
ORDER  BY ci.population DESC;

-- Países y sus capitales en América
-- (en esta BD la capital es una columna en 'countries', no requiere join)
SELECT name AS pais, capital
FROM   countries
WHERE  region = 'Americas'
ORDER  BY name;


-- =========================== EJERCICIO 4 =============================
-- Original pide "lenguajes oficiales", pero no hay tabla de idiomas.
-- Se devuelven las ciudades europeas > 1.500.000 con su país.
--
-- ---------------------------------------------------------------------
-- ORDEN DE LAS CLAUSULAS DE UN SELECT
-- ---------------------------------------------------------------------
-- Hay dos ordenes distintos: el orden en que se ESCRIBE la consulta
-- (sintaxis obligatoria) y el orden en que el motor la EJECUTA (orden
-- lógico). No coinciden, y eso explica varias reglas practicas.
--
-- 1) Orden de ESCRITURA (obligatorio para el parser):
--      SELECT  -> FROM -> JOIN ... ON -> WHERE -> GROUP BY
--              -> HAVING -> ORDER BY -> LIMIT / OFFSET
--    Si cambias el orden, la consulta no compila.
--
-- 2) Orden de EJECUCIÓN (lo que el motor hace internamente):
--      1. FROM            carga las tablas base
--      2. JOIN ... ON     combina filas según la condición de union
--      3. WHERE           filtra filas individuales
--      4. GROUP BY        agrupa filas
--      5. HAVING          filtra grupos
--      6. SELECT          calcula columnas y aplica alias
--      7. DISTINCT        elimina duplicados
--      8. ORDER BY        ordena el resultado
--      9. LIMIT / OFFSET  recorta el numero de filas
--    Mnemotecnia: F-W-G-H-S-O-L
--
-- Aplicado a la consulta de abajo, el motor hace:
--   1. FROM cities ci                -> carga la tabla cities como ci
--   2. JOIN countries co ON ...      -> empareja cada ciudad con su país
--   3. WHERE co.region = 'Europe'
--          AND ci.population > 1500000
--                                    -> descarta ciudades no europeas o
--                                       con menos de 1.500.000 hab.
--   4. SELECT ci.name, co.name,
--             TO_CHAR(ci.population,...)
--                                    -> calcula las 3 columnas finales
--                                       y aplica los alias
--   5. ORDER BY ci.population DESC   -> ordena de mayor a menor
--
-- Consecuencias practicas de este orden:
--   * No puedes usar un alias del SELECT en el WHERE: WHERE se ejecuta
--     ANTES que SELECT. Por eso en el ejercicio 2 hay que repetir
--     "population / NULLIF(area_sq_km, 0) > 500" en lugar de "densidad > 500".
--   * Si puedes usar el alias en ORDER BY (se ejecuta DESPUES de SELECT),
--     pero aqui ordenamos por ci.population (numerico) y NO por el alias
--     poblacion_ciudad, porque ese alias ya es texto formateado y se
--     ordenaria alfabeticamente ("1.000.000" iria antes que "999.999").
--   * HAVING filtra GRUPOS y solo tiene sentido con GROUP BY o agregados;
--     WHERE filtra FILAS.
--   * LIMIT se aplica al final, asi que ORDER BY ... LIMIT 10 sirve para
--     "los 10 mayores"; un LIMIT sin ORDER BY devuelve filas arbitrarias.
-- ---------------------------------------------------------------------

SELECT
    ci.name AS ciudad,                                            -- 6. SELECT  (calcula columnas y alias)
    co.name AS pais,
    TO_CHAR(ci.population, '999G999G999G999') AS población_ciudad
FROM   cities    ci                                               -- 1. FROM    (tabla base)
JOIN   countries co ON co.id = ci.country_id                      -- 2. JOIN    (empareja ciudades con países)
WHERE  co.region = 'Europe'                                       -- 3. WHERE   (filtra filas)
  AND  ci.population > 1500000
ORDER  BY ci.population DESC;                                     -- 8. ORDER BY (ordena por valor numérico)


-- =========================== EJERCICIO 5 =============================

-- Cuántos países hay
SELECT TO_CHAR(COUNT(*), '999G999') AS total_países FROM countries;

-- Superficie total del mundo
SELECT TO_CHAR(SUM(area_sq_km), '999G999G999G999') AS superficie_total
FROM   countries;

-- Superficie media de los países
SELECT TO_CHAR(AVG(area_sq_km), '999G999G990D99') AS superficie_media
FROM   countries;

-- País más grande
SELECT
    name AS país,
    TO_CHAR(area_sq_km, '999G999G999') AS "extensión en km²"
FROM   countries
ORDER  BY area_sq_km DESC NULLS LAST
LIMIT  1;

-- País más pequeño
SELECT
    name AS país,
    TO_CHAR(area_sq_km, '999G999G999') AS "extensión en km²"
FROM   countries
WHERE  area_sq_km IS NOT NULL AND area_sq_km > 0
ORDER  BY area_sq_km ASC
LIMIT  1;

-- ---------------------------------------------------------------------
-- Superficie, población y densidad de cada continente (región)
-- ---------------------------------------------------------------------
-- En la tabla 'countries' hay datos incompletos que afectan al resultado:
--   * Algunos países tienen 'region' a NULL o cadena vacía -> al hacer
--     GROUP BY region aparece una fila "fantasma" con continente vacío.
--   * El continente 'Polar' (Antártida) tiene superficie pero población
--     a NULL -> SUM(population) devuelve NULL y la densidad también.
-- A continuación se ofrecen tres versiones de la consulta según cómo
-- queramos tratar esos datos.
-- ---------------------------------------------------------------------

-- OPCIÓN 1 — Versión "cruda": muestra todo tal cual está en la BD.
-- Incluye la fila con continente vacío y la fila Polar sin habitantes.
SELECT
    region AS continente,
    TO_CHAR(SUM(area_sq_km), '999G999G999G999') AS superficie_total,
    TO_CHAR(SUM(population), '999G999G999G999') AS población_total,
    TO_CHAR(SUM(population) / NULLIF(SUM(area_sq_km), 0),
            '999G999G990D99')                   AS densidad
FROM   countries
GROUP  BY region
ORDER  BY SUM(population) / NULLIF(SUM(area_sq_km), 0) DESC NULLS LAST;


-- OPCIÓN 2 — Versión "limpia": filtra los grupos problemáticos.
--   * WHERE  descarta los países sin región asignada.
--   * HAVING descarta los continentes sin población (Polar).
-- Es la más adecuada cuando el objetivo es comparar continentes reales.
SELECT
    region AS continente,
    TO_CHAR(SUM(area_sq_km), '999G999G999G999') AS superficie_total,
    TO_CHAR(SUM(population), '999G999G999G999') AS población_total,
    TO_CHAR(SUM(population) / NULLIF(SUM(area_sq_km), 0),
            '999G999G990D99')                   AS densidad
FROM   countries
WHERE  region IS NOT NULL AND region <> ''
GROUP  BY region
HAVING SUM(population) IS NOT NULL
ORDER  BY SUM(population) / NULLIF(SUM(area_sq_km), 0) DESC;


-- OPCIÓN 3 — Versión "tolerante": muestra todos los grupos pero
-- sustituye los NULL por valores legibles.
--   * COALESCE(NULLIF(region,''), '(sin región)') etiqueta el grupo huérfano.
--   * COALESCE(SUM(...), 0) convierte sumas NULL en 0.
--   * NULLS LAST deja al final los continentes cuya densidad sigue siendo NULL
--     (los que tienen 0 habitantes, donde la densidad no tiene sentido).
SELECT
    COALESCE(NULLIF(region, ''), '(sin región)')                AS continente,
    TO_CHAR(COALESCE(SUM(area_sq_km), 0), '999G999G999G999')    AS superficie_total,
    TO_CHAR(COALESCE(SUM(population), 0), '999G999G999G999')    AS población_total,
    TO_CHAR(COALESCE(SUM(population), 0)
            / NULLIF(SUM(area_sq_km), 0),
            '999G999G990D99')                                   AS densidad
FROM   countries
GROUP  BY COALESCE(NULLIF(region, ''), '(sin región)')
ORDER  BY COALESCE(SUM(population), 0)
        / NULLIF(SUM(area_sq_km), 0) DESC NULLS LAST;
