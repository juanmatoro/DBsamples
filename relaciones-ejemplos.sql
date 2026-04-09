/*
  Relaciones en PostgreSQL: 1:1, 1:N, N:N
  Ejemplos detallados usando tablas de Chinook.
*/

/* =========================
   1:1 (uno a uno)
   =========================
   En Chinook no hay una 1:1 estricta en el esquema base.
   Ejemplo habitual: crear una relacion 1:1 "logica"
   eligiendo una unica fila relacionada por entidad.
   Aqui: ultimo invoice por cliente (1 cliente -> 1 invoice seleccionado).
*/

WITH latest_invoice AS (
  SELECT i.customer_id,
         i.invoice_id,
         i.invoice_date,
         ROW_NUMBER() OVER (
           PARTITION BY i.customer_id
           ORDER BY i.invoice_date DESC, i.invoice_id DESC
         ) AS rn
  FROM invoice i
)
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer,
       li.invoice_id,
       li.invoice_date
FROM customer c
LEFT JOIN latest_invoice li
  ON li.customer_id = c.customer_id AND li.rn = 1
ORDER BY c.customer_id
LIMIT 20;

/* =========================
   1:N (uno a muchos)
   =========================
   Uso habitual: un artista con muchos albums.
*/

SELECT a.name AS artist, al.title AS album
FROM artist a
JOIN album al ON al.artist_id = a.artist_id
ORDER BY a.name, al.title
LIMIT 30;

/* =========================
   N:N (muchos a muchos)
   =========================
   Uso habitual: playlists con muchos tracks y un track en muchas playlists.
*/

SELECT p.name AS playlist, t.name AS track
FROM playlist p
JOIN playlist_track pt ON pt.playlist_id = p.playlist_id
JOIN track t ON t.track_id = pt.track_id
ORDER BY p.name, t.name
LIMIT 30;
