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
    /*
      Agregaciones: se usan para resumir datos en el backend.
      Regla practica: agrega en SQL para enviar menos filas a Node.
      Todas las consultas de abajo devuelven pocas filas ya resumidas.
    */

    // 1) COUNT
    // Uso habitual: contar filas totales (usuarios, pedidos, tracks).
    // Tipico en dashboards para mostrar KPIs.
    console.log('1) COUNT - uso habitual: contar filas');
    const q1 = `SELECT COUNT(*) AS total_tracks FROM track`;
    console.table((await pool.query(q1)).rows);

    // 2) SUM
    // Uso habitual: totalizar importes o cantidades.
    // Ejemplo: ventas totales, ingresos globales.
    console.log('2) SUM - uso habitual: totalizar importes');
    const q2 = `SELECT SUM(total) AS total_billed FROM invoice`;
    console.table((await pool.query(q2)).rows);

    // 3) AVG
    // Uso habitual: calcular promedios (precio medio, ticket medio).
    // Importante: ignora NULLs por defecto.
    console.log('3) AVG - uso habitual: promedio');
    const q3 = `SELECT AVG(unit_price) AS avg_price FROM track`;
    console.table((await pool.query(q3)).rows);

    // 4) MIN / MAX
    // Uso habitual: detectar extremos (factura minima/maxima).
    // Suele combinarse con fechas o agrupaciones.
    console.log('4) MIN / MAX - uso habitual: extremos');
    const q4 = `SELECT MIN(total) AS min_invoice, MAX(total) AS max_invoice FROM invoice`;
    console.table((await pool.query(q4)).rows);

    // 5) GROUP BY
    // Uso habitual: informes por categoria.
    // Aqui contamos tracks por genero.
    // Importante: toda columna no agregada debe ir en GROUP BY.
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

    // 6) HAVING
    // Uso habitual: filtrar resultados agregados (post-agrupacion).
    // Ejemplo: solo generos con mas de 100 tracks.
    console.log('6) HAVING - uso habitual: filtrar grupos');
    const q6 = `
      SELECT g.name AS genre, COUNT(*) AS total_tracks
      FROM track t
      JOIN genre g ON g.genre_id = t.genre_id
      GROUP BY g.name
      HAVING COUNT(*) > 100
      ORDER BY total_tracks DESC
    `;
    console.table((await pool.query(q6)).rows);

    // 7) Agregacion por rango temporal
    // Uso habitual: metricas por mes (ventas, facturacion).
    console.log('7) Agregacion por mes - uso habitual: series temporales');
    const q7 = `
      SELECT DATE_TRUNC('month', invoice_date) AS month,
             SUM(total) AS total_billed
      FROM invoice
      GROUP BY month
      ORDER BY month
      LIMIT 12
    `;
    console.table((await pool.query(q7)).rows);

    // 8) Agregacion por cliente con JOIN
    // Uso habitual: ranking de clientes por facturacion.
    console.log('8) Agregacion por cliente - uso habitual: ranking de clientes');
    const q8 = `
      SELECT c.customer_id,
             c.first_name || ' ' || c.last_name AS customer,
             SUM(i.total) AS total_spent
      FROM customer c
      JOIN invoice i ON i.customer_id = c.customer_id
      GROUP BY c.customer_id, c.first_name, c.last_name
      ORDER BY total_spent DESC
      LIMIT 10
    `;
    console.table((await pool.query(q8)).rows);
  } finally {
    await pool.end();
  }
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
