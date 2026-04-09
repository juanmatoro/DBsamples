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
    // Uso habitual: timestamps actuales en auditoria.
    console.log('1) CURRENT_DATE y NOW - uso habitual: timestamp actual');
    const q1 = `SELECT CURRENT_DATE AS today, NOW() AS now_ts`;
    console.table((await pool.query(q1)).rows);

    // Uso habitual: agrupar por año/mes.
    console.log('2) EXTRACT - uso habitual: agrupar por año/mes');
    const q2 = `
      SELECT invoice_id, invoice_date,
             EXTRACT(YEAR FROM invoice_date) AS year,
             EXTRACT(MONTH FROM invoice_date) AS month
      FROM invoice
      ORDER BY invoice_date DESC
      LIMIT 10
    `;
    console.table((await pool.query(q2)).rows);

    // Uso habitual: calcular antiguedad o tiempo transcurrido.
    console.log('3) AGE - uso habitual: tiempo transcurrido');
    const q3 = `
      SELECT invoice_id, invoice_date, AGE(NOW(), invoice_date) AS age_from_now
      FROM invoice
      ORDER BY invoice_date DESC
      LIMIT 5
    `;
    console.table((await pool.query(q3)).rows);

    // Uso habitual: sumar/restar periodos a fechas.
    console.log('4) INTERVAL - uso habitual: sumar/restar periodos');
    const q4 = `SELECT NOW() AS now_ts, NOW() + INTERVAL '7 days' AS next_week`;
    console.table((await pool.query(q4)).rows);
  } finally {
    await pool.end();
  }
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
