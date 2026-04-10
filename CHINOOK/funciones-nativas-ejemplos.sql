/*
  Funciones nativas del lenguaje (PostgreSQL)
  Mezcla de funciones comunes de texto, numeros y fechas.
*/

/* 1) LENGTH y LOWER
   Uso habitual: normalizar texto y medir longitudes. */
SELECT name, LENGTH(name) AS len, LOWER(name) AS lower_name
FROM artist
ORDER BY len DESC
LIMIT 10;

/* 2) ROUND
   Uso habitual: redondear precios o metricas. */
SELECT track_id, unit_price, ROUND(unit_price, 1) AS price_1d
FROM track
ORDER BY unit_price DESC
LIMIT 10;

/* 3) NOW y CURRENT_DATE
   Uso habitual: obtener fecha/hora actual para reportes. */
SELECT NOW() AS now_ts, CURRENT_DATE AS today;
