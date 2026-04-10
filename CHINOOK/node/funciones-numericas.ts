import { Pool } from 'pg';

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT || 5432),
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME || 'chinook',
});

async function run() {
  try {
    // Uso habitual: redondeos y limites superiores/inferiores.
    console.log('1) ROUND, CEIL, FLOOR - uso habitual: redondeos');
    const q1 = `
      SELECT 3.14159 AS pi,
             ROUND(3.14159, 2) AS round_2,
             CEIL(3.14159) AS ceil_val,
             FLOOR(3.14159) AS floor_val
    `;
    console.table((await pool.query(q1)).rows);

    // Uso habitual: calculos matematicos basicos.
    console.log('2) POWER y ABS - uso habitual: calculos');
    const q2 = `SELECT POWER(2, 8) AS pow_2_8, ABS(-42) AS abs_val`;
    console.table((await pool.query(q2)).rows);

    // Uso habitual: calcular impuestos o recargos.
    console.log('3) Operaciones con precios - uso habitual: impuestos');
    const q3 = `
      SELECT track_id, unit_price, unit_price * 1.21 AS price_vat
      FROM track
      ORDER BY unit_price DESC
      LIMIT 10
    `;
    console.table((await pool.query(q3)).rows);
  } finally {
    await pool.end();
  }
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
