/*
  Otras funciones utiles
*/

/* 1) COALESCE
   Uso habitual: reemplazar NULL por un valor por defecto. */
SELECT employee_id,
       first_name,
       last_name,
       COALESCE(CAST(reports_to AS text), 'sin manager') AS reports_to
FROM employee
ORDER BY employee_id
LIMIT 10;

/* 2) NULLIF
   Uso habitual: convertir un valor concreto en NULL. */
SELECT NULLIF(10, 10) AS null_if_equal, NULLIF(10, 5) AS null_if_diff;

/* 3) GREATEST / LEAST
   Uso habitual: elegir maximo/minimo entre varias columnas. */
SELECT GREATEST(10, 20, 5) AS max_val,
       LEAST(10, 20, 5) AS min_val;
