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
    // Uso habitual: construir nombres completos.
    console.log('1) CONCAT - uso habitual: construir nombres completos');
    const q1 = `
      SELECT first_name || ' ' || last_name AS full_name
      FROM customer
      ORDER BY full_name
      LIMIT 10
    `;
    console.table((await pool.query(q1)).rows);

    // Uso habitual: extraer prefijos o fragmentos.
    console.log('2) SUBSTRING - uso habitual: extraer prefijos');
    const q2 = `
      SELECT name, SUBSTRING(name FROM 1 FOR 10) AS short_name
      FROM track
      ORDER BY name
      LIMIT 10
    `;
    console.table((await pool.query(q2)).rows);

    // Uso habitual: normalizar cadenas o cambiar separadores.
    console.log('3) REPLACE - uso habitual: normalizar cadenas');
    const q3 = `
      SELECT name, REPLACE(name, ' ', '_') AS snake
      FROM artist
      ORDER BY name
      LIMIT 10
    `;
    console.table((await pool.query(q3)).rows);

    // Uso habitual: limpiar espacios antes/despues.
    console.log('4) TRIM - uso habitual: limpiar espacios');
    const q4 = `SELECT TRIM('  Chinook  ') AS trimmed`;
    console.table((await pool.query(q4)).rows);
  } finally {
    await pool.end();
  }
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
