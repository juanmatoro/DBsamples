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
    // Uso habitual: generar hashes simples (no recomendado para seguridad fuerte).
    console.log('1) md5 - uso habitual: hash simple');
    const q1 = `SELECT md5('chinook') AS md5_hash`;
    console.table((await pool.query(q1)).rows);

    // Uso habitual: hash mas robusto para verificacion de integridad.
    console.log('2) sha256 (pgcrypto) - uso habitual: hash mas robusto');
    const q2 = `SELECT encode(digest('chinook', 'sha256'), 'hex') AS sha256_hash`;
    try {
      console.table((await pool.query(q2)).rows);
    } catch (err) {
      console.log('pgcrypto no disponible. Ejecuta: CREATE EXTENSION IF NOT EXISTS pgcrypto;');
    }
  } finally {
    await pool.end();
  }
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
