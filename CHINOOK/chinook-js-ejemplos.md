---
title: Ejemplos JS con PostgreSQL (Chinook)
---

Este documento toma la estructura de `readme.js.md` y la aplica a **PostgreSQL** usando la base **Chinook**. Incluye ejemplos con driver nativo y con Prisma.

**Indice**
- Driver nativo PostgreSQL con Node.js
- Consultas con placeholders y tipado simple
- INSERT/UPDATE/DELETE y filas afectadas
- Prisma con Chinook

## Driver nativo PostgreSQL con Node.js

Usaremos el driver `pg` (node-postgres).

Instalacion:

```shell
npm install pg
```

Conexion basica:

```ts
import { Pool } from 'pg';

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT || 5432),
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME || 'chinook',
});
```

## Consultas con placeholders y tipado simple

Consulta simple:

```ts
const result = await pool.query('SELECT name, artist_id FROM artist ORDER BY name LIMIT 5');
console.log(result.rows);
```

Consulta con placeholders (evita inyeccion SQL):

```ts
const artistId = 12;
const result = await pool.query(
  'SELECT title, album_id FROM album WHERE artist_id = $1 ORDER BY album_id DESC',
  [artistId],
);
```

Ejemplo de JOIN con Chinook:

```ts
const result = await pool.query(`
  SELECT a.name AS artist, COUNT(t.track_id) AS total_tracks
  FROM artist a
  JOIN album al ON al.artist_id = a.artist_id
  JOIN track t ON t.album_id = al.album_id
  GROUP BY a.name
  ORDER BY total_tracks DESC
  LIMIT 10
`);
```

## INSERT/UPDATE/DELETE y filas afectadas

Insert de un cliente de prueba:

```ts
const insert = await pool.query(
  'INSERT INTO customer (first_name, last_name, email) VALUES ($1, $2, $3) RETURNING customer_id',
  ['Ana', 'Lopez', 'ana.lopez@example.com'],
);

console.log(insert.rows[0].customer_id);
```

Update:

```ts
const update = await pool.query(
  'UPDATE customer SET email = $1 WHERE customer_id = $2',
  ['ana.new@example.com', insert.rows[0].customer_id],
);

console.log(update.rowCount);
```

Delete:

```ts
const del = await pool.query(
  'DELETE FROM customer WHERE customer_id = $1',
  [insert.rows[0].customer_id],
);

console.log(del.rowCount);
```

## Prisma con Chinook

Instalacion:

```shell
npm install -D prisma
npm install @prisma/client
```

Inicializa Prisma y conecta a PostgreSQL:

```shell
npx prisma init --datasource-provider postgresql
```

En `.env`:

```env
DATABASE_URL="postgresql://user:password@localhost:5432/chinook"
```

Ejemplo de esquema minimo (usa tablas existentes con `db pull`):

```shell
npx prisma db pull
npx prisma generate
```

Consulta con Prisma Client:

```ts
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const topArtists = await prisma.artist.findMany({
  take: 5,
  orderBy: { name: 'asc' },
  select: { artistId: true, name: true },
});

console.log(topArtists);
```

Consulta con relacion (albumes por artista):

```ts
const artistWithAlbums = await prisma.artist.findUnique({
  where: { artistId: 12 },
  include: { album: { select: { albumId: true, title: true } } },
});

console.log(artistWithAlbums);
```
