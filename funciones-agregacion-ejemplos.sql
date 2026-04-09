/*
  Funciones de agregacion
*/

/* 1) COUNT
   Uso habitual: contar filas (usuarios, pedidos, tracks). */
SELECT COUNT(*) AS total_tracks
FROM track;

/* 2) SUM
   Uso habitual: totalizar importes o cantidades. */
SELECT SUM(total) AS total_billed
FROM invoice;

/* 3) AVG
   Uso habitual: calcular promedios (precio medio, ticket medio). */
SELECT AVG(unit_price) AS avg_price
FROM track;

/* 4) MIN / MAX
   Uso habitual: detectar extremos (minimo, maximo). */
SELECT MIN(total) AS min_invoice, MAX(total) AS max_invoice
FROM invoice;

/* 5) Agregacion por grupo
   Uso habitual: informes por categoria. */
SELECT g.name AS genre, COUNT(*) AS total_tracks
FROM track t
JOIN genre g ON g.genre_id = t.genre_id
GROUP BY g.name
ORDER BY total_tracks DESC
LIMIT 10;
