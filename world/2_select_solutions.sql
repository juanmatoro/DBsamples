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

SELECT
    ci.name AS ciudad,
    co.name AS pais,
    TO_CHAR(ci.population, '999G999G999G999') AS poblacion_ciudad
FROM   cities    ci
JOIN   countries co ON co.id = ci.country_id
WHERE  co.region = 'Europe'
  AND  ci.population > 1500000
ORDER  BY ci.population DESC;


-- =========================== EJERCICIO 5 =============================

-- Cuántos países hay
SELECT TO_CHAR(COUNT(*), '999G999') AS total_paises FROM countries;

-- Superficie total del mundo
SELECT TO_CHAR(SUM(area_sq_km), '999G999G999G999') AS superficie_total
FROM   countries;

-- Superficie media de los países
SELECT TO_CHAR(AVG(area_sq_km), '999G999G990D99') AS superficie_media
FROM   countries;

-- País más grande
SELECT
    name AS pais,
    TO_CHAR(area_sq_km, '999G999G999') AS extension
FROM   countries
ORDER  BY area_sq_km DESC NULLS LAST
LIMIT  1;

-- País más pequeño
SELECT
    name AS pais,
    TO_CHAR(area_sq_km, '999G999G999') AS extension
FROM   countries
WHERE  area_sq_km IS NOT NULL AND area_sq_km > 0
ORDER  BY area_sq_km ASC
LIMIT  1;

-- Superficie y población de cada continente (region)
SELECT
    region AS continente,
    TO_CHAR(SUM(area_sq_km), '999G999G999G999') AS superficie_total,
    TO_CHAR(SUM(population), '999G999G999G999') AS poblacion_total
FROM   countries
GROUP  BY region
ORDER  BY SUM(area_sq_km) DESC;
