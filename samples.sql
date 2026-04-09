/*  Lista 12 artistas ordenados por nombre. */
SELECT name, artist_id
FROM artists
ORDER BY name
LIMIT 12;

/*  Devuelve los 5 álbumes más recientes (por album_id). */
SELECT title, album_id
FROM album
ORDER BY album_id DESC
LIMIT 5;

/* 3. Cuenta cuántos tracks hay por género. */

  SELECT g.name AS genre, COUNT(*) AS total_tracks
  FROM track t
  JOIN genre g ON g.genre_id = t.genre_id
  GROUP BY g.name
  ORDER BY total_tracks DESC;

/*  Explicación: une track con genre, agrupa por género y cuenta los tracks en cada grupo. */

/*  4. Top 5 países con más clientes. */

  SELECT country, COUNT(*) AS total_customers
  FROM customer
  GROUP BY country
  ORDER BY total_customers DESC
  LIMIT 5;

  /*  Explicación: agrupa clientes por país y ordena por el total descendente. */

  ———

 /*  Nivel 2 (joins y agregados)*/

/*  5. Top 10 artistas con más tracks. */

  SELECT a.name AS artist, COUNT(*) AS total_tracks
  FROM artist a
  JOIN album al ON al.artist_id = a.artist_id
  JOIN track t ON t.album_id = al.album_id
  GROUP BY a.name
  ORDER BY total_tracks DESC
  LIMIT 10;

  /*  Explicación: recorre artist -> album -> track, cuenta tracks por artista y ordena. */

 /*  6. Total facturado por cliente (nombre completo), ordenado desc. */

  SELECT c.first_name || ' ' || c.last_name AS customer,
         SUM(i.total) AS total_billed
  FROM customer c
  JOIN invoice i ON i.customer_id = c.customer_id
  GROUP BY c.first_name, c.last_name
  ORDER BY total_billed DESC;

  /*  Explicación: une clientes con facturas, suma los totales por cliente y ordena. */

 /*  7. Ticket medio por país (avg(total) en invoice). */

  SELECT billing_country AS country,
         AVG(total) AS avg_ticket
  FROM invoice
  GROUP BY billing_country
  ORDER BY avg_ticket DESC;

  /*  Explicación: agrupa por país de facturación y calcula la media de total. */

 /*  8. Canciones en playlists con su nombre de playlist. */

  SELECT p.name AS playlist, t.name AS track
  FROM playlist p
  JOIN playlist_track pt ON pt.playlist_id = p.playlist_id
  JOIN track t ON t.track_id = pt.track_id
  ORDER BY p.name, t.name;

  /*  Explicación: relaciona playlists con tracks usando la tabla puente. */

  ———

  /*  Nivel 3 (CTE, subqueries, window) */

  /*  9. Para cada cliente, su factura más cara. */

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
  ORDER BY i.total DESC;

  /*  Explicación: subconsulta correlacionada para comparar cada factura con el máximo por cliente. */

  /*  10. Ranking de artistas por ventas (suma unit_price * quantity). */

  SELECT a.name AS artist,
         SUM(il.unit_price * il.quantity) AS revenue,
         RANK() OVER (ORDER BY SUM(il.unit_price * il.quantity) DESC) AS rnk
  FROM artist a
  JOIN album al ON al.artist_id = a.artist_id
  JOIN track t ON t.album_id = al.album_id
  JOIN invoice_line il ON il.track_id = t.track_id
  GROUP BY a.name
  ORDER BY revenue DESC;

  /*  Explicación: suma ingresos por artista y calcula ranking con RANK(). */

  /*  11. % de ventas por género (total por género / total general). */

  WITH total_sales AS (
    SELECT SUM(il.unit_price * il.quantity) AS total
    FROM invoice_line il
  )
  SELECT g.name AS genre,
         SUM(il.unit_price * il.quantity) AS revenue,
         ROUND(100 * SUM(il.unit_price * il.quantity) / ts.total, 2) AS pct
  FROM genre g
  JOIN track t ON t.genre_id = g.genre_id
  JOIN invoice_line il ON il.track_id = t.track_id
  CROSS JOIN total_sales ts
  GROUP BY g.name, ts.total
  ORDER BY revenue DESC;

  /*  Explicación: calcula el total global en un CTE y luego divide el total por género. */

  /*  12. Clientes con gasto superior al promedio global. */
   WITH customer_spend AS (
    SELECT c.customer_id,
           c.first_name || ' ' || c.last_name AS customer, /*  Concatenamos nombre y apellido para mostrar el nombre completo. */
           SUM(i.total) AS total_spent
    FROM customer c
    JOIN invoice i ON i.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
  ),
  avg_spend AS (
    SELECT AVG(total_spent) AS avg_total
    FROM customer_spend
  )
  SELECT cs.customer_id, cs.customer, cs.total_spent
  FROM customer_spend cs
  CROSS JOIN avg_spend a
  WHERE cs.total_spent > a.avg_total
  ORDER BY cs.total_spent DESC;

  /*  Explicación: primero calcula gasto por cliente, luego la media, y filtra los que están por encima. 
  */

  ———

  
--   INNER JOIN
--   Solo filas que tienen coincidencia en ambas tablas.

  SELECT t.name AS track, g.name AS genre
  FROM track t
  JOIN genre g ON g.genre_id = t.genre_id
  LIMIT 10;

--   LEFT JOIN
--   Devuelve todo de la tabla izquierda aunque no haya match a la derecha.

  SELECT a.name AS artist, al.title AS album
  FROM artist a
  LEFT JOIN album al ON al.artist_id = a.artist_id
  ORDER BY a.name
  LIMIT 20;

--   RIGHT JOIN
--   Devuelve todo de la tabla derecha aunque no haya match a la izquierda.

  SELECT al.title AS album, a.name AS artist
  FROM artist a
  RIGHT JOIN album al ON al.artist_id = a.artist_id
  ORDER BY al.title
  LIMIT 20;

--   FULL OUTER JOIN
--   Incluye filas sin match en cualquiera de las dos tablas.

  SELECT a.name AS artist, al.title AS album
  FROM artist a
  FULL OUTER JOIN album al ON al.artist_id = a.artist_id
  ORDER BY a.name NULLS LAST
  LIMIT 20;

--   CROSS JOIN
--   Producto cartesiano (todas las combinaciones).

  SELECT g.name AS genre, m.name AS media_type
  FROM genre g
  CROSS JOIN media_type m
  LIMIT 20;

--   SELF JOIN
--   Una tabla se une consigo misma (útil para jerarquías).

  SELECT e.first_name || ' ' || e.last_name AS employee,
         m.first_name || ' ' || m.last_name AS manager
  FROM employee e
  LEFT JOIN employee m ON m.employee_id = e.reports_to
  ORDER BY employee
  LIMIT 20;

  /*  JOIN con tabla puente (N:N)
  Relación muchos-a-muchos. */

  SELECT p.name AS playlist, t.name AS track
  FROM playlist p
  JOIN playlist_track pt ON pt.playlist_id = p.playlist_id
  JOIN track t ON t.track_id = pt.track_id
  ORDER BY p.name, t.name
  LIMIT 20;