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
    // Uso habitual: convertir tipos para comparaciones o formatos.
    console.log('1) CAST - uso habitual: convertir tipos');
    const q1 = `
      SELECT track_id,
             CAST(milliseconds / 1000 AS integer) AS seconds_int
      FROM track
      ORDER BY track_id
      LIMIT 10
    `;
    console.table((await pool.query(q1)).rows);

    // Uso habitual: formatear fechas/numeros para reportes.
    console.log('2) TO_CHAR - uso habitual: formatear fechas');
    const q2 = `
      SELECT invoice_id,
             TO_CHAR(invoice_date, 'YYYY-MM-DD') AS invoice_day
      FROM invoice
      ORDER BY invoice_date DESC
      LIMIT 10
    `;
    console.table((await pool.query(q2)).rows);

    // Uso habitual: convertir texto numerico a numero.
    console.log('3) TO_NUMBER - uso habitual: texto a numero');
    const q3 = `SELECT TO_NUMBER('12345', '99999') AS num_val`;
    console.table((await pool.query(q3)).rows);
  } finally {
    await pool.end();
  }
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
