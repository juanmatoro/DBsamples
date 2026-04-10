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
    // Uso habitual: clasificar filas en categorias.
    console.log('1) CASE - uso habitual: clasificar filas');
    const q1 = `
      SELECT track_id, unit_price,
             CASE
               WHEN unit_price < 0.99 THEN 'low'
               WHEN unit_price < 1.49 THEN 'mid'
               ELSE 'high'
             END AS price_bucket
      FROM track
      ORDER BY unit_price DESC
      LIMIT 10
    `;
    console.table((await pool.query(q1)).rows);

    // Uso habitual: etiquetar valores faltantes.
    console.log('2) CASE con NULL - uso habitual: etiquetar faltantes');
    const q2 = `
      SELECT employee_id, first_name, last_name,
             CASE
               WHEN reports_to IS NULL THEN 'top'
               ELSE 'reports'
             END AS level
      FROM employee
      ORDER BY employee_id
    `;
    console.table((await pool.query(q2)).rows);
  } finally {
    await pool.end();
  }
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
