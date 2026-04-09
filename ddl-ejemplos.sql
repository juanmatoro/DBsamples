/*
  DDL: definicion de datos (PostgreSQL)
  Ejemplos seguros con esquema y tablas de ejemplo.
*/

/* 1) CREATE SCHEMA
   Uso habitual: separar objetos por area o modulo y evitar colisiones. */
CREATE SCHEMA IF NOT EXISTS demo;

/* 2) CREATE TABLE
   Uso habitual: definir nuevas entidades con PK y tipos de datos claros. */
CREATE TABLE IF NOT EXISTS demo.product (
  product_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price NUMERIC(10,2) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

/* 3) ALTER TABLE ADD COLUMN
   Uso habitual: evolucionar el esquema con nuevas columnas sin recrear la tabla. */
ALTER TABLE demo.product
ADD COLUMN IF NOT EXISTS sku TEXT;

/* 4) ALTER TABLE ADD CONSTRAINT
   Uso habitual: asegurar unicidad o integridad referencial. */
ALTER TABLE demo.product
ADD CONSTRAINT IF NOT EXISTS product_sku_uk UNIQUE (sku);

/* 5) CREATE INDEX
   Uso habitual: mejorar rendimiento de busquedas y ordenaciones. */
CREATE INDEX IF NOT EXISTS product_name_idx
ON demo.product (name);

/* 6) CREATE VIEW
   Uso habitual: exponer consultas reutilizables o simplificar permisos. */
CREATE OR REPLACE VIEW demo.product_view AS
SELECT product_id, name, price
FROM demo.product;

/* 7) DROP VIEW / TABLE / SCHEMA (con IF EXISTS)
   Uso habitual: limpiar objetos de ejemplo en entornos de practica. */

/* 8) CREATE INDEX compuesto
   Uso habitual: optimizar filtros por varias columnas. */
CREATE INDEX IF NOT EXISTS product_name_price_idx
ON demo.product (name, price);

/* 9) CREATE INDEX parcial
   Uso habitual: indexar solo filas frecuentes (p.ej. activas). */
CREATE INDEX IF NOT EXISTS product_price_positive_idx
ON demo.product (price)
WHERE price > 0;

/* 10) CREATE INDEX funcional
   Uso habitual: acelerar busquedas por transformaciones (LOWER). */
CREATE INDEX IF NOT EXISTS product_name_lower_idx
ON demo.product (LOWER(name));

/* 11) ALTER TABLE DROP COLUMN
   Uso habitual: eliminar columnas obsoletas. */
ALTER TABLE demo.product
DROP COLUMN IF EXISTS sku;
DROP VIEW IF EXISTS demo.product_view;
DROP TABLE IF EXISTS demo.product;
DROP SCHEMA IF EXISTS demo;
