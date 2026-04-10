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
    // Uso habitual: diagnostico de sesion y permisos.
    console.log('1) CURRENT_USER / SESSION_USER - uso habitual: diagnostico');
    const q1 = `SELECT CURRENT_USER AS current_user, SESSION_USER AS session_user`;
    console.table((await pool.query(q1)).rows);

    // Uso habitual: identificar version del servidor.
    console.log('2) VERSION - uso habitual: version del servidor');
    const q2 = `SELECT VERSION() AS pg_version`;
    console.table((await pool.query(q2)).rows);

    // Uso habitual: consultar parametros activos del servidor.
    console.log('3) CURRENT_SETTING - uso habitual: parametros activos');
    const q3 = `SELECT CURRENT_SETTING('server_version') AS server_version`;
    console.table((await pool.query(q3)).rows);
  } finally {
    await pool.end();
  }
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
