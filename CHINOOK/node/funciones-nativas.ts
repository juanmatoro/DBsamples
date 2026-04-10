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
    // Uso habitual: normalizar texto y medir longitudes.
    console.log('1) LENGTH y LOWER - uso habitual: normalizar texto');
    const q1 = `
      SELECT name, LENGTH(name) AS len, LOWER(name) AS lower_name
      FROM artist
      ORDER BY len DESC
      LIMIT 10
    `;
    console.table((await pool.query(q1)).rows);

    // Uso habitual: redondear precios o metricas.
    console.log('2) ROUND - uso habitual: redondear precios');
    const q2 = `
      SELECT track_id, unit_price, ROUND(unit_price, 1) AS price_1d
      FROM track
      ORDER BY unit_price DESC
      LIMIT 10
    `;
    console.table((await pool.query(q2)).rows);

    // Uso habitual: obtener fecha/hora actual.
    console.log('3) NOW y CURRENT_DATE - uso habitual: timestamp actual');
    const q3 = `SELECT NOW() AS now_ts, CURRENT_DATE AS today`;
    console.table((await pool.query(q3)).rows);
  } finally {
    await pool.end();
  }
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
