/* 
  Ejemplos y explicacion de JOINs (Chinook / esquema tipico del proyecto)
  Formato: comentario corto + consulta simple.
*/

/* 1) INNER JOIN
   Solo filas con coincidencia en ambas tablas.
   Uso habitual: cruzar datos relacionados (tracks con genero). */
SELECT t.name AS track, g.name AS genre
FROM track t
JOIN genre g ON g.genre_id = t.genre_id
ORDER BY t.name
LIMIT 10;

/* 2) LEFT JOIN
   Devuelve todo de la tabla izquierda aunque no haya match a la derecha.
   Uso habitual: listar maestros con posibles detalles. 
   Se puede usar para ver todos los artistas aunque no tengan álbumes asignados. */
SELECT a.name AS artist, al.title AS album
FROM artist a
LEFT JOIN album al ON al.artist_id = a.artist_id
ORDER BY a.name, al.title
LIMIT 20;

/* 3) RIGHT JOIN
   Devuelve todo de la tabla derecha aunque no haya match a la izquierda.
   Uso habitual: menos común, equivalente a invertir un LEFT JOIN. 
   Se puede usar para ver todos los álbumes aunque no tengan artista asignado. */
SELECT al.title AS album, a.name AS artist
FROM artist a
RIGHT JOIN album al ON al.artist_id = a.artist_id
ORDER BY al.title, a.name
LIMIT 20;

/* 4) FULL OUTER JOIN
   Incluye filas sin match en cualquiera de las dos tablas.
   Uso habitual: reconciliar listas de dos tablas. */
SELECT a.name AS artist, al.title AS album
FROM artist a
FULL OUTER JOIN album al ON al.artist_id = a.artist_id
ORDER BY a.name NULLS LAST, al.title NULLS LAST
LIMIT 20;

/* 5) CROSS JOIN
   Producto cartesiano (todas las combinaciones).
   Uso habitual: generar combinaciones o matrices. */
SELECT g.name AS genre, m.name AS media_type
FROM genre g
CROSS JOIN media_type m
ORDER BY g.name, m.name
LIMIT 20;

/* 6) SELF JOIN
   Una tabla se une consigo misma (jerarquias).
   Uso habitual: relaciones jefe-empleado. */
SELECT e.first_name || ' ' || e.last_name AS employee,
       m.first_name || ' ' || m.last_name AS manager
FROM employee e
LEFT JOIN employee m ON m.employee_id = e.reports_to
ORDER BY employee
LIMIT 20;

/* 7) JOIN con tabla puente (N:N)
   Relacion muchos-a-muchos usando una tabla intermedia.
   Uso habitual: playlists y tracks, alumnos y cursos. */
SELECT p.name AS playlist, t.name AS track
FROM playlist p
JOIN playlist_track pt ON pt.playlist_id = p.playlist_id
JOIN track t ON t.track_id = pt.track_id
ORDER BY p.name, t.name
LIMIT 20;

/* 8) JOIN con filtro en la tabla derecha
   Ojo: poner el filtro en WHERE convierte el LEFT en INNER.
   El filtro correcto va en la clausula ON.
   Uso habitual: conservar filas izquierdas aunque no cumplan el filtro. */
SELECT a.name AS artist, al.title AS album, al.release_year
FROM artist a
LEFT JOIN album al
  ON al.artist_id = a.artist_id
 AND al.release_year >= 2010
ORDER BY a.name, al.title
LIMIT 20;

/* 9) JOIN + agregacion
   Cuenta cuantos tracks hay por artista.
   Uso habitual: reportes de volumen por entidad. */
SELECT a.name AS artist, COUNT(t.track_id) AS total_tracks
FROM artist a
JOIN album al ON al.artist_id = a.artist_id
JOIN track t ON t.album_id = al.album_id
GROUP BY a.name
ORDER BY total_tracks DESC
LIMIT 10;

/* 10) JOIN para resolver N:N con filtro
   Playlists que contienen tracks de un genero concreto.
   Uso habitual: filtrar relaciones many-to-many por atributos. */
SELECT DISTINCT p.name AS playlist
FROM playlist p
JOIN playlist_track pt ON pt.playlist_id = p.playlist_id
JOIN track t ON t.track_id = pt.track_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Rock'
ORDER BY p.name
LIMIT 20;
