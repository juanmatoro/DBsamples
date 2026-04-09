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
    // Uso habitual: reemplazar NULL por un valor por defecto.
    console.log('1) COALESCE - uso habitual: reemplazar NULL');
    const q1 = `
      SELECT employee_id, first_name, last_name,
             COALESCE(CAST(reports_to AS text), 'sin manager') AS reports_to
      FROM employee
      ORDER BY employee_id
      LIMIT 10
    `;
    console.table((await pool.query(q1)).rows);

    // Uso habitual: convertir un valor concreto en NULL.
    console.log('2) NULLIF - uso habitual: convertir valores a NULL');
    const q2 = `SELECT NULLIF(10, 10) AS null_if_equal, NULLIF(10, 5) AS null_if_diff`;
    console.table((await pool.query(q2)).rows);

    // Uso habitual: elegir maximo/minimo entre valores.
    console.log('3) GREATEST / LEAST - uso habitual: max/min entre valores');
    const q3 = `SELECT GREATEST(10, 20, 5) AS max_val, LEAST(10, 20, 5) AS min_val`;
    console.table((await pool.query(q3)).rows);
  } finally {
    await pool.end();
  }
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
