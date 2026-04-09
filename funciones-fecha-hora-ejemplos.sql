/*
  Funciones de fecha y hora
*/

/* 1) CURRENT_DATE y NOW
   Uso habitual: timestamps actuales en auditoria. */
SELECT CURRENT_DATE AS today, NOW() AS now_ts;

/* 2) EXTRACT
   Uso habitual: agrupar por año/mes/dia. */
SELECT invoice_id,
       invoice_date,
       EXTRACT(YEAR FROM invoice_date) AS year,
       EXTRACT(MONTH FROM invoice_date) AS month
FROM invoice
ORDER BY invoice_date DESC
LIMIT 10;

/* 3) AGE
   Uso habitual: calcular antiguedad o tiempo transcurrido. */
SELECT invoice_id,
       invoice_date,
       AGE(NOW(), invoice_date) AS age_from_now
FROM invoice
ORDER BY invoice_date DESC
LIMIT 5;

/* 4) INTERVAL
   Uso habitual: sumar/restar periodos a una fecha. */
SELECT NOW() AS now_ts, NOW() + INTERVAL '7 days' AS next_week;
