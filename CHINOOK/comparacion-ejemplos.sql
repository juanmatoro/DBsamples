/*
  Expresiones de comparacion
*/

/* 1) Comparaciones simples
   Uso habitual: filtrar por umbrales (duracion, precio, cantidad). */
SELECT name, milliseconds
FROM track
WHERE milliseconds > 300000
ORDER BY milliseconds DESC
LIMIT 10;

/* 2) IS NULL / IS NOT NULL
   Uso habitual: detectar valores sin asignar. */
SELECT employee_id, first_name, last_name, reports_to
FROM employee
WHERE reports_to IS NULL;

/* 3) IN / NOT IN
   Uso habitual: incluir o excluir grupos de ids. */
SELECT name
FROM genre
WHERE genre_id IN (1, 2, 3)
ORDER BY name;

/* 4) BETWEEN
   Uso habitual: rangos continuos (fechas, totales). */
SELECT invoice_id, total
FROM invoice
WHERE total BETWEEN 10 AND 20
ORDER BY total;

/* 5) LIKE / ILIKE
   Uso habitual: buscar por prefijo o patron de texto. */
SELECT name
FROM artist
WHERE name ILIKE 'the %'
ORDER BY name
LIMIT 10;
