/*
  UNION / UNION ALL en PostgreSQL
*/

/* 1) UNION: elimina duplicados
   Uso habitual: combinar resultados de tablas similares sin repetir filas. */
SELECT billing_city AS city
FROM invoice
UNION
SELECT city
FROM customer
ORDER BY city
LIMIT 20;

/* 2) UNION ALL: mantiene duplicados
   Uso habitual: combinar resultados cuando importa el total sin deduplicar. */
SELECT billing_country AS country
FROM invoice
UNION ALL
SELECT country
FROM customer
ORDER BY country
LIMIT 20;

/* 3) UNION con columna origen
   Uso habitual: auditar de que tabla proviene cada fila. */
SELECT billing_country AS country, 'invoice' AS source
FROM invoice
UNION ALL
SELECT country, 'customer' AS source
FROM customer
ORDER BY country, source
LIMIT 30;
