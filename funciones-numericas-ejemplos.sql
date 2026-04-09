/*
  Funciones numericas
*/

/* 1) ROUND, CEIL, FLOOR
   Uso habitual: redondeos y limites superiores/inferiores. */
SELECT 3.14159 AS pi,
       ROUND(3.14159, 2) AS round_2,
       CEIL(3.14159) AS ceil_val,
       FLOOR(3.14159) AS floor_val;

/* 2) POWER y ABS
   Uso habitual: calculos matematicos basicos. */
SELECT POWER(2, 8) AS pow_2_8, ABS(-42) AS abs_val;

/* 3) Operaciones con precios
   Uso habitual: calcular impuestos o recargos. */
SELECT track_id,
       unit_price,
       unit_price * 1.21 AS price_vat
FROM track
ORDER BY unit_price DESC
LIMIT 10;
