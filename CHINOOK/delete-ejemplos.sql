/*
  DELETE (Delete) - ejemplos seguros
  Usamos una tabla temporal para no modificar datos reales.
*/

BEGIN;

CREATE TEMP TABLE temp_customer (
  customer_id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  email TEXT NOT NULL
);

INSERT INTO temp_customer (first_name, last_name, email)
VALUES
  ('Ana', 'Lopez', 'ana.lopez@example.com'),
  ('Luis', 'Garcia', 'luis.garcia@example.com'),
  ('Marta', 'Ruiz', 'marta.ruiz@example.com');

/* 1) DELETE por condicion
   Uso habitual: eliminar registros concretos. */
DELETE FROM temp_customer
WHERE first_name = 'Luis' AND last_name = 'Garcia';

/* 2) Ver resultado
   Uso habitual: validar que la fila fue borrada. */
SELECT * FROM temp_customer ORDER BY customer_id;

ROLLBACK;
