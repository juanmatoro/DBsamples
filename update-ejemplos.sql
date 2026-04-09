/*
  UPDATE (Update) - ejemplos seguros
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
  ('Luis', 'Garcia', 'luis.garcia@example.com');

/* 1) UPDATE simple
   Uso habitual: corregir o cambiar un dato puntual. */
UPDATE temp_customer
SET email = 'ana.new@example.com'
WHERE first_name = 'Ana' AND last_name = 'Lopez';

/* 2) UPDATE con expresion
   Uso habitual: aplicar transformaciones masivas. */
UPDATE temp_customer
SET email = REPLACE(email, 'example.com', 'mail.com');

/* 3) Ver resultado
   Uso habitual: comprobar el efecto del UPDATE. */
SELECT * FROM temp_customer ORDER BY customer_id;

ROLLBACK;
