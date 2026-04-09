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
    // Uso habitual: contar filas (usuarios, pedidos, tracks).
    console.log('1) COUNT - uso habitual: contar filas');
    const q1 = `SELECT COUNT(*) AS total_tracks FROM track`;
    console.table((await pool.query(q1)).rows);

    // Uso habitual: totalizar importes o cantidades.
    console.log('2) SUM - uso habitual: totalizar importes');
    const q2 = `SELECT SUM(total) AS total_billed FROM invoice`;
    console.table((await pool.query(q2)).rows);

    // Uso habitual: calcular promedios.
    console.log('3) AVG - uso habitual: promedio');
    const q3 = `SELECT AVG(unit_price) AS avg_price FROM track`;
    console.table((await pool.query(q3)).rows);

    // Uso habitual: detectar extremos.
    console.log('4) MIN / MAX - uso habitual: extremos');
    const q4 = `SELECT MIN(total) AS min_invoice, MAX(total) AS max_invoice FROM invoice`;
    console.table((await pool.query(q4)).rows);

    // Uso habitual: informes por categoria.
    console.log('5) Agregacion por grupo - uso habitual: informes');
    const q5 = `
      SELECT g.name AS genre, COUNT(*) AS total_tracks
      FROM track t
      JOIN genre g ON g.genre_id = t.genre_id
      GROUP BY g.name
      ORDER BY total_tracks DESC
      LIMIT 10
    `;
    console.table((await pool.query(q5)).rows);
  } finally {
    await pool.end();
  }
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
