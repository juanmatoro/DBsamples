/*
  Ejemplos SQL con la base Chinook (PostgreSQL)
  Incluye JOINs, subqueries y window functions.
*/

/* =========================
   JOINs
   ========================= */

/* 1) INNER JOIN
   Solo filas con coincidencia en ambas tablas.
   Uso habitual: cruzar datos relacionados para mostrar detalles. */
SELECT t.name AS track, g.name AS genre
FROM track t
JOIN genre g ON g.genre_id = t.genre_id
ORDER BY t.name
LIMIT 10;

/* 2) LEFT JOIN
   Devuelve todo de la tabla izquierda aunque no haya match.
   Uso habitual: incluir entidades aunque no tengan relaciones. */
SELECT a.name AS artist, al.title AS album
FROM artist a
LEFT JOIN album al ON al.artist_id = a.artist_id
ORDER BY a.name, al.title
LIMIT 20;

/* 3) FULL OUTER JOIN
   Incluye filas sin match en cualquiera de las dos tablas.
   Uso habitual: reconciliar listas entre tablas. */
SELECT a.name AS artist, al.title AS album
FROM artist a
FULL OUTER JOIN album al ON al.artist_id = a.artist_id
ORDER BY a.name NULLS LAST, al.title NULLS LAST
LIMIT 20;

/* 4) JOIN con tabla puente (N:N)
   Playlists y sus tracks.
   Uso habitual: resolver relaciones muchos-a-muchos. */
SELECT p.name AS playlist, t.name AS track
FROM playlist p
JOIN playlist_track pt ON pt.playlist_id = p.playlist_id
JOIN track t ON t.track_id = pt.track_id
ORDER BY p.name, t.name
LIMIT 20;

/* =========================
   Subqueries
   ========================= */

/* 5) Subquery escalar
   Tracks mas caros que el precio medio.
   Uso habitual: comparar contra un valor agregado global. */
SELECT name, unit_price
FROM track
WHERE unit_price > (SELECT AVG(unit_price) FROM track)
ORDER BY unit_price DESC
LIMIT 10;

/* 6) Subquery correlacionada
   Factura mas cara por cliente.
   Uso habitual: calcular maximo/minimo por entidad. */
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer,
       i.invoice_id,
       i.total
FROM customer c
JOIN invoice i ON i.customer_id = c.customer_id
WHERE i.total = (
  SELECT MAX(i2.total)
  FROM invoice i2
  WHERE i2.customer_id = c.customer_id
)
ORDER BY i.total DESC
LIMIT 20;

/* 7) Subquery en FROM (derivada)
   Total facturado por pais, solo top 5.
   Uso habitual: crear una tabla intermedia para ordenar/filtrar. */
SELECT billing_country, total_billed
FROM (
  SELECT billing_country, SUM(total) AS total_billed
  FROM invoice
  GROUP BY billing_country
) s
ORDER BY total_billed DESC
LIMIT 5;

/* =========================
   Window Functions
   ========================= */

/* 8) RANK()
   Ranking de artistas por ingresos.
   Uso habitual: rankings sin perder empates. */
SELECT a.name AS artist,
       SUM(il.unit_price * il.quantity) AS revenue,
       RANK() OVER (ORDER BY SUM(il.unit_price * il.quantity) DESC) AS rnk
FROM artist a
JOIN album al ON al.artist_id = a.artist_id
JOIN track t ON t.album_id = al.album_id
JOIN invoice_line il ON il.track_id = t.track_id
GROUP BY a.name
ORDER BY revenue DESC
LIMIT 10;

/* 9) ROW_NUMBER() por particion
   Top 3 tracks mas caros por genero.
   Uso habitual: top N por grupo. */
WITH ranked_tracks AS (
  SELECT g.name AS genre,
         t.name AS track,
         t.unit_price,
         ROW_NUMBER() OVER (
           PARTITION BY g.genre_id
           ORDER BY t.unit_price DESC, t.name
         ) AS rn
  FROM track t
  JOIN genre g ON g.genre_id = t.genre_id
)
SELECT genre, track, unit_price
FROM ranked_tracks
WHERE rn <= 3
ORDER BY genre, unit_price DESC, track;

/* 10) SUM() OVER
   Acumulado por cliente (running total) segun fecha de factura.
   Uso habitual: series acumuladas y metricas temporales. */
SELECT i.customer_id,
       i.invoice_id,
       i.invoice_date,
       i.total,
       SUM(i.total) OVER (
         PARTITION BY i.customer_id
         ORDER BY i.invoice_date
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total
FROM invoice i
ORDER BY i.customer_id, i.invoice_date
LIMIT 30;
