/*
  Funciones de control de flujo (CASE)
*/

/* 1) CASE simple
   Uso habitual: clasificar filas en categorias. */
SELECT track_id,
       unit_price,
       CASE
         WHEN unit_price < 0.99 THEN 'low'
         WHEN unit_price < 1.49 THEN 'mid'
         ELSE 'high'
       END AS price_bucket
FROM track
ORDER BY unit_price DESC
LIMIT 10;

/* 2) CASE con NULL
   Uso habitual: etiquetar valores faltantes. */
SELECT employee_id,
       first_name,
       last_name,
       CASE
         WHEN reports_to IS NULL THEN 'top'
         ELSE 'reports'
       END AS level
FROM employee
ORDER BY employee_id;
