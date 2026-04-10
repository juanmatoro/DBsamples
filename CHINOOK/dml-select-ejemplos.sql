/*
  DML: SELECT (Read) - ejemplos basicos con Chinook (PostgreSQL)
*/

/* 1) SELECT basico
   Uso habitual: listar datos para inspeccion rapida o vistas simples. */
SELECT artist_id, name
FROM artist
ORDER BY name
LIMIT 10;

/* 2) SELECT con alias y filtros
   Uso habitual: renombrar columnas para reportes y aplicar condiciones. */
SELECT t.track_id AS id, t.name AS track, t.unit_price AS price
FROM track t
WHERE t.unit_price >= 0.99
ORDER BY t.unit_price DESC, t.name
LIMIT 10;

/* 3) SELECT con IN
   Uso habitual: filtrar por un conjunto fijo de valores. */
SELECT album_id, title
FROM album
WHERE album_id IN (1, 2, 3, 4, 5)
ORDER BY album_id;

/* 4) SELECT con BETWEEN
   Uso habitual: filtrar por rangos (precios, fechas, ids). */
SELECT invoice_id, invoice_date, total
FROM invoice
WHERE total BETWEEN 5 AND 10
ORDER BY total DESC
LIMIT 10;

/* 5) SELECT con LIKE (patrones)
   Uso habitual: busquedas por texto parcial. */
SELECT name
FROM track
WHERE name ILIKE '%love%'
ORDER BY name
LIMIT 10;
