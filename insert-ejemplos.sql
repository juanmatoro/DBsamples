/*
  INSERT (Create) - ejemplos seguros
  Usamos una tabla temporal para no modificar datos reales.
*/

BEGIN;

CREATE TEMP TABLE temp_customer (
  customer_id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  email TEXT NOT NULL
);

/* 1) INSERT simple
   Uso habitual: crear un registro nuevo. */
INSERT INTO temp_customer (first_name, last_name, email)
VALUES ('Ana', 'Lopez', 'ana.lopez@example.com');

/* 2) INSERT multiple
   Uso habitual: carga de varios registros en una sola sentencia. */
INSERT INTO temp_customer (first_name, last_name, email)
VALUES
  ('Luis', 'Garcia', 'luis.garcia@example.com'),
  ('Marta', 'Ruiz', 'marta.ruiz@example.com');

/* 3) INSERT con RETURNING
   Uso habitual: obtener el id generado al insertar. */
INSERT INTO temp_customer (first_name, last_name, email)
VALUES ('Pablo', 'Soto', 'pablo.soto@example.com')
RETURNING customer_id, first_name, last_name;

/* 4) Ver datos insertados
   Uso habitual: validar que la insercion fue correcta. */
SELECT * FROM temp_customer ORDER BY customer_id;

ROLLBACK;
