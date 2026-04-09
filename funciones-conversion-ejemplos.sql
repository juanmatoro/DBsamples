/*
  Funciones de conversion
*/

/* 1) CAST
   Uso habitual: convertir tipos para comparaciones o formatos. */
SELECT track_id,
       CAST(milliseconds / 1000 AS integer) AS seconds_int
FROM track
ORDER BY track_id
LIMIT 10;

/* 2) TO_CHAR
   Uso habitual: formatear fechas/numeros para reportes. */
SELECT invoice_id,
       TO_CHAR(invoice_date, 'YYYY-MM-DD') AS invoice_day
FROM invoice
ORDER BY invoice_date DESC
LIMIT 10;

/* 3) TO_NUMBER
   Uso habitual: convertir texto numerico a numero. */
SELECT TO_NUMBER('12345', '99999') AS num_val;
