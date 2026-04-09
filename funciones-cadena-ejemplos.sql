/*
  Funciones de cadena
*/

/* 1) CONCAT
   Uso habitual: construir nombres completos o etiquetas. */
SELECT first_name || ' ' || last_name AS full_name
FROM customer
ORDER BY full_name
LIMIT 10;

/* 2) SUBSTRING
   Uso habitual: extraer prefijos o partes de un texto. */
SELECT name, SUBSTRING(name FROM 1 FOR 10) AS short_name
FROM track
ORDER BY name
LIMIT 10;

/* 3) REPLACE
   Uso habitual: normalizar cadenas (espacios, separadores). */
SELECT name, REPLACE(name, ' ', '_') AS snake
FROM artist
ORDER BY name
LIMIT 10;

/* 4) TRIM
   Uso habitual: limpiar espacios antes/despues. */
SELECT TRIM('  Chinook  ') AS trimmed;
