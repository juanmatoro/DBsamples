/*
  DDL: definicion de datos (PostgreSQL)
  Ejemplos seguros con esquema y tablas de ejemplo.
  Nota: son ejemplos independientes; puedes ejecutar los que necesites.
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

/* 2b) CREATE TABLE (relacion 1:N)
   Uso habitual: una categoria con muchos productos. */
CREATE TABLE IF NOT EXISTS demo.category (
  category_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

ALTER TABLE demo.product
ADD COLUMN IF NOT EXISTS category_id INTEGER;

ALTER TABLE demo.product
ADD CONSTRAINT IF NOT EXISTS product_category_fk
FOREIGN KEY (category_id) REFERENCES demo.category(category_id);

/* 2c) CREATE TABLE (relacion N:N)
   Uso habitual: productos con multiples tags. */
CREATE TABLE IF NOT EXISTS demo.tag (
  tag_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS demo.product_tag (
  product_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  PRIMARY KEY (product_id, tag_id),
  FOREIGN KEY (product_id) REFERENCES demo.product(product_id),
  FOREIGN KEY (tag_id) REFERENCES demo.tag(tag_id)
);

/* 3) ALTER TABLE ADD COLUMN
   Uso habitual: evolucionar el esquema con nuevas columnas sin recrear la tabla.
   Ejemplo tipico: agregar un campo de estado. */
ALTER TABLE demo.product
ADD COLUMN IF NOT EXISTS sku TEXT;

ALTER TABLE demo.product
ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'active';

/* 4) ALTER TABLE ADD CONSTRAINT
   Uso habitual: asegurar unicidad o integridad referencial.
   Ejemplo tipico: evitar SKUs duplicados. */
ALTER TABLE demo.product
ADD CONSTRAINT IF NOT EXISTS product_sku_uk UNIQUE (sku);

/* 4b) ALTER TABLE ADD CONSTRAINT (FK)
   Uso habitual: crear relaciones entre tablas existentes. */
ALTER TABLE demo.product
ADD CONSTRAINT IF NOT EXISTS product_category_fk2
FOREIGN KEY (category_id) REFERENCES demo.category(category_id);

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
   Uso habitual: eliminar columnas obsoletas.
   Ejemplo tipico: retirar un campo que ya no se usa. */
ALTER TABLE demo.product
DROP COLUMN IF EXISTS sku;

/* 12) ALTER TABLE RENAME COLUMN
   Uso habitual: renombrar campos para mayor claridad. */
ALTER TABLE demo.product
RENAME COLUMN name TO product_name;

/* 13) ALTER TABLE ALTER COLUMN TYPE
   Uso habitual: ampliar precision o cambiar el tipo de dato. */
ALTER TABLE demo.product
ALTER COLUMN price TYPE NUMERIC(12,2);

/* 14) ALTER TABLE DROP CONSTRAINT
   Uso habitual: eliminar restricciones que ya no aplican. */
ALTER TABLE demo.product
DROP CONSTRAINT IF EXISTS product_sku_uk;

/* 15) ALTER TABLE DROP CONSTRAINT (FK)
   Uso habitual: quitar relaciones antiguas antes de migrar. */
ALTER TABLE demo.product
DROP CONSTRAINT IF EXISTS product_category_fk2;

DROP VIEW IF EXISTS demo.product_view;
DROP TABLE IF EXISTS demo.product_tag;
DROP TABLE IF EXISTS demo.tag;
DROP TABLE IF EXISTS demo.category;
DROP TABLE IF EXISTS demo.product;
DROP SCHEMA IF EXISTS demo;
