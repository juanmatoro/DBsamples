---
title: SQL y ECMAScript (JavaScript) - PostgreSQL
---

- [PostgreSQL y JavaScript / TypeScript](#postgresql-y-javascript--typescript)
  - [Opciones en Node.js para utilizar PostgreSQL](#opciones-en-nodejs-para-utilizar-postgresql)
    - [Driver nativo para Node](#driver-nativo-para-node)
    - [ORM (Object-relational mapping)](#orm-object-relational-mapping)
  - [Driver nativo PostgreSQL con Node.js y TypeScript](#driver-nativo-postgresql-con-nodejs-y-typescript)
    - [Consultas: metodo `query` del pool. Tipado de resultados](#consultas-metodo-query-del-pool-tipado-de-resultados)
    - [Consultas y placeholders. Problema de la inyeccion SQL](#consultas-y-placeholders-problema-de-la-inyeccion-sql)
    - [Creacion de registros y obtencion del id](#creacion-de-registros-y-obtencion-del-id)
- [SQLite y JavaScript / TypeScript](#sqlite-y-javascript--typescript)
  - [Opciones en Node.js para utilizar SQLite](#opciones-en-nodejs-para-utilizar-sqlite)
  - [sqlite3](#sqlite3)
- [Prisma](#prisma)
  - [Introduccion](#introduccion)
  - [Instalacion](#instalacion)
    - [Prisma CLI](#prisma-cli)
    - [Prisma Client](#prisma-client)
      - [Configuracion, cadena de conexion y modelo de datos](#configuracion-cadena-de-conexion-y-modelo-de-datos)
    - [Generate v. Migrate](#generate-v-migrate)
  - [Sintaxis en Prisma: Modelos](#sintaxis-en-prisma-modelos)
    - [Campos](#campos)
      - [Tipos](#tipos)
      - [Modificadores](#modificadores)
      - [Directivas](#directivas)
      - [Primary Key](#primary-key)
    - [Relaciones entre tablas](#relaciones-entre-tablas)
    - [Relaciones 1:1](#relaciones-11)
    - [Relaciones N:M Implicitas](#relaciones-nm-implicitas)
    - [Relaciones N:M Explicitas](#relaciones-nm-explicitas)
    - [Crear un modelo: Ejemplo de un blog](#crear-un-modelo-ejemplo-de-un-blog)
  - [Migraciones](#migraciones)
  - [Uso de Prisma Client](#uso-de-prisma-client)
  - [Prisma Seed](#prisma-seed)

## PostgreSQL y JavaScript / TypeScript

### Opciones en Node.js para utilizar PostgreSQL

#### Driver nativo para Node

- driver oficial [pg](https://www.npmjs.com/package/pg)

This is the most common Node.js driver for PostgreSQL.
Incluye API con callbacks y promesas, y soporte para TypeScript mediante tipos.

#### ORM (Object-relational mapping)

Un ORM (Object Relational Mapping) es una tecnica de programacion que permite convertir datos entre sistemas orientados a objetos y sistemas relacionales. En el caso de Node.js, un ORM permite trabajar con bases de datos SQL de forma mas sencilla, utilizando objetos y metodos en lugar de sentencias SQL.

Ejemplos comunes:

- [Knex.js](https://knexjs.org/) JavaScript SQL Query builder
- [Sequelize](https://sequelize.org/) JavaScript ORM Library on top of some native driver
- [Bookshelf](https://bookshelfjs.org/) JavaScript ORM Library on top of Knex.js SQL Query Builder
- [Objection.js](https://vincit.github.io/objection.js/) JavaScript ORM Library on top of Knex.js SQL Query Builder and some native driver
- [TypeORM](https://typeorm.io/) TypeScript ORM Library on top of reflect-metadata and some native driver
- [MikroORM](https://mikro-orm.io/) TypeScript ORM Library for SQL and NoSQL inspired by PHP Doctrine
- [Prisma](https://www.prisma.io/) recent TypeScript ORM

### Driver nativo PostgreSQL con Node.js y TypeScript

Instalacion

```shell
npm install pg
```

Conexion a la base de datos (Pool recomendado, usando Chinook)

```typescript
import { Pool } from 'pg';

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT || 5432),
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME || 'chinook',
});
```

Ejemplos con Chinook (artist, album, track, invoice):

```typescript
// Top 5 artistas por numero de tracks
const topArtists = await pool.query(`
  SELECT a.name AS artist, COUNT(t.track_id) AS total_tracks
  FROM artist a
  JOIN album al ON al.artist_id = a.artist_id
  JOIN track t ON t.album_id = al.album_id
  GROUP BY a.name
  ORDER BY total_tracks DESC
  LIMIT 5
`);
```

```typescript
// Ultimas facturas
const invoices = await pool.query(`
  SELECT invoice_id, invoice_date, total
  FROM invoice
  ORDER BY invoice_date DESC
  LIMIT 5
`);
```

#### Consultas: metodo `query` del pool. Tipado de resultados

La conexion incluye un metodo `query` para realizar consultas.

```typescript
const result = await pool.query('SELECT * FROM artist');
```

En las consultas es critico el uso correcto de parametros para evitar inyecciones SQL.

```typescript
const artistId = 12; // Chinook: un artista existente
const result = await pool.query(
  'SELECT * FROM album WHERE artist_id = $1',
  [artistId],
);
```

En ningun caso se deben concatenar valores directamente en la consulta o incluirlos en un template string.

```typescript
// Incorrecto: permitiria inyecciones SQL
const result = await pool.query(
  `SELECT * FROM album WHERE artist_id = ${artistId}`,
);
```

El resultado de la consulta incluye:

- `result.rows`: array con los resultados
- `result.rowCount`: numero de filas afectadas (INSERT/UPDATE/DELETE)

Si queremos tipar cada fila:

```typescript
type Artist = {
  artist_id: number;
  name: string;
};

const result = await pool.query<Artist>(
  'SELECT artist_id, name FROM artist',
);
```

En el caso de SELECT podemos definir tipos especificos para cada fila segun las columnas que usamos en la aplicacion.

```typescript
type Album = {
  album_id: number;
  title: string;
};

const result = await pool.query<Album>(
  'SELECT album_id, title FROM album WHERE artist_id = $1',
  [artistId],
);
```

En el caso de operaciones de modificacion, usamos `rowCount` para saber cuantas filas se afectaron.

```typescript
const del = await pool.query(
  'DELETE FROM artist WHERE artist_id = $1',
  [artistId],
);

console.log(del.rowCount);
```

#### Consultas y placeholders. Problema de la inyeccion SQL

En PostgreSQL se usan placeholders con `$1`, `$2`, etc. Esto evita inyecciones SQL y permite al driver preparar el plan de ejecucion.

```typescript
const result = await pool.query(
  'SELECT * FROM track WHERE unit_price >= $1',
  [0.99],
);
```

#### Creacion de registros y obtencion del id

Cuando el id es auto incremental, se puede obtener con `RETURNING`.

```typescript
const insert = await pool.query(
  'INSERT INTO artist (name) VALUES ($1) RETURNING artist_id',
  ['New Artist'],
);

console.log(insert.rows[0].artist_id);
```

Cuando el id no es auto incremental, existen dos posibilidades:

- el id se genera en la aplicacion, por lo que no es necesario obtenerlo
- el id se genera en la base de datos (como valor por defecto, e.g. `gen_random_uuid()`), por lo que se necesita obtenerlo con `RETURNING`

```typescript
const insert = await pool.query(
  'INSERT INTO artist (name) VALUES ($1) RETURNING artist_id',
  ['New Artist'],
);
```

Otra alternativa es realizar una consulta posterior para recuperar el id con una condicion unica.

```typescript
const [inserted] = await pool.query(
  'INSERT INTO artist (name) VALUES ($1) RETURNING artist_id',
  ['New Artist'],
);

const result = await pool.query(
  'SELECT artist_id FROM artist WHERE name = $1',
  ['New Artist'],
);
```

## SQLite y JavaScript / TypeScript

### Opciones en Node.js para utilizar SQLite

Hasta hace poco, existian varias librerias para trabajar con SQLite en Node.js, aunque algunas no soportaban TypeScript o no tenian soporte activo. Entre las mejores opciones estan:

- `sqlite3`, wrapper de la libreria C++ (desde v5 soporta TS)
- `better-sqlite3`, alternativa sincronica con buen rendimiento
- modulo nativo `node:sqlite` (Node 22+ experimental)

### sqlite3

La libreria [sqlite3](https://www.npmjs.com/package/sqlite3) se puede instalar mediante npm

```shell
npm install sqlite3
```

Conexion a la base de datos en memoria

```typescript
import sqlite3 from 'sqlite3';

const db = new sqlite3.Database(':memory:');
```

Conexion a la base de datos en un archivo

```typescript
import sqlite3 from 'sqlite3';

const db = new sqlite3.Database('movies.db');
```

sqlite3 trabaja con callbacks, en lugar de promesas. Metodos principales:

- `all`: obtener todos los registros
- `get`: obtener un solo registro
- `run`: INSERT/UPDATE/DELETE
- `each`: iterar registros
- `exec`: ejecutar varias sentencias

```typescript
db.all('SELECT * FROM movies where year = ?', [findYear], (err, rows) => {
  if (err) {
    console.error(err);
  } else {
    console.log(rows);
  }
});
```

En JavaScript se puede crear un wrapper con promesas:

```typescript
import util from 'node:util';
import sqlite3 from 'sqlite3';

const db = new sqlite3.Database('movies.db');

const SQLite3 = {
  run(...args) {
    return new Promise((resolve, reject) => {
      db.run(...args, function (err) {
        if (err) reject(err);
        else resolve(this);
      });
    });
  },
  all: util.promisify(db.all.bind(db)),
  get: util.promisify(db.get.bind(db)),
  each: util.promisify(db.each.bind(db)),
  exec: util.promisify(db.exec.bind(db)),
};
```

## Prisma

### Introduccion

Prisma es un ORM (Object-Relational Mapping) para bases de datos. Es una herramienta que permite interactuar con la base de datos sin escribir SQL directamente. Prisma traduce consultas en codigo JavaScript a SQL.

Esta especialmente pensado para trabajar con TypeScript y Node.js, proporcionando tipado seguro.

Soporta bases relacionales (PostgreSQL, MySQL, SQLite, SQL Server) y no relacionales (MongoDB).

### Instalacion

Antes de comenzar, conviene anadir en VS Code el plugin de Prisma, que ayuda a escribir el esquema.

#### Prisma CLI

Instalamos Prisma CLI como dependencia de desarrollo. Se puede considerar como el SDK que usaremos para interactuar con la base.

`npm install -D prisma`

Los comandos del CLI son:

- init: Setup Prisma for your app
- generate: Generate artifacts (e.g. Prisma Client)
- db: Manage your database schema and lifecycle
- migrate: Migrate your database
- studio: Browse your data with Prisma Studio
- validate: Validate your Prisma schema
- format: Format your Prisma schema

Inicializar Prisma en el proyecto:

`npx prisma init --datasource-provider postgresql`

Si no se indica el tipo de base de datos, Prisma utiliza Postgres (`postgresql`).

Alternativamente se puede indicar `mysql`, `sqlite` o `sqlserver`.

La consola mostrara algo similar a:

```shell
✔ Your Prisma schema was created at prisma/schema.prisma
  You can now open it in your favorite editor.

Next steps:
1. Set the DATABASE_URL in the .env file to point to your existing database.
2. Run prisma db pull to turn your database schema into a Prisma schema.
3. Run prisma generate to generate the Prisma Client.
```

#### Prisma Client

Generalmente no necesitamos instalar el cliente. A partir de Prisma 2, Prisma Client se genera bajo demanda.

`npm i @prisma/client` (opcional si no se genera automaticamente)

##### Configuracion, cadena de conexion y modelo de datos

Proceso recomendado:

- definir la cadena de conexion en `.env` como `DATABASE_URL`
- configurar el datasource en `prisma/schema.prisma`
- definir los modelos de datos

`.env` (PostgreSQL):

```env
DATABASE_URL="postgresql://user:password@localhost:5432/dbname"
```

`prisma/schema.prisma`:

```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}
```

Ejemplo de modelo:

```prisma
model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  name      String?
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
```

### Generate v. Migrate

- `prisma db pull` convierte el esquema de la base en un schema Prisma
- `prisma generate` genera el cliente Prisma
- `prisma migrate` sincroniza la base con el esquema (y genera el cliente)

### Sintaxis en Prisma: Modelos

#### Campos

La definicion de cada campo incluye:

- nombre del campo
- tipo
- modificadores (opcional)
- directivas (opcional)

##### Tipos

- `String`, `Int`, `DateTime`, `Boolean`, `Float`, `Json`, `Enum`, `Bytes`, `Decimal`, `BigInt`

##### Modificadores

- `[]`: lista
- `?`: opcional

##### Directivas

- `@id`, `@unique`, `@default`, `@map`, `@db`, `@ignore`, `@relation`, `@updatedAt`

##### Primary Key

```prisma
model User {
  id  Int  @id @default(autoincrement())
  ...
}
```

La PK tambien puede ser un UUID:

```prisma
model User {
  id  String @id @default(uuid())
  ...
}
```

#### Relaciones entre tablas

Las relaciones se definen con `@relation`, usando `fields` y `references`.

#### Relaciones 1:1

```prisma
model User {
  id     Int     @id @default(autoincrement())
  email  String  @unique
  profile Profile?
}

model Profile {
  id     Int  @id @default(autoincrement())
  user   User @relation(fields: [userId], references: [id])
  userId Int  @unique
}
```

#### Relaciones N:M Implicitas

```prisma
model Post {
  id   Int   @id @default(autoincrement())
  tags Tag[]
}

model Tag {
  id    Int    @id @default(autoincrement())
  posts Post[]
}
```

#### Relaciones N:M Explicitas

```prisma
model Post {
  id    Int    @id @default(autoincrement())
  tags  PostTag[]
}

model Tag {
  id    Int    @id @default(autoincrement())
  posts PostTag[]
}

model PostTag {
  post   Post @relation(fields: [postId], references: [id])
  tag    Tag  @relation(fields: [tagId], references: [id])
  postId Int
  tagId  Int
  @@unique([postId, tagId])
}
```

#### Crear un modelo: Ejemplo de un blog

```prisma
model Post {
  id        Int      @id @default(autoincrement())
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  title     String   @db.VarChar(255)
  content   String?
  published Boolean  @default(false)
  author    User     @relation(fields: [authorId], references: [id])
  authorId  Int
}

model User {
  id        String   @id @default(uuid())
  createdAt DateTime @default(now())
  username  String   @unique
  password  String
  posts     Post[]
}
```

### Migraciones

`npx prisma migrate dev --name init`

### Uso de Prisma Client

```ts
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const allUsers = await prisma.user.findMany();
  console.log(allUsers);
}

main()
  .catch((e) => {
    throw e;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
```

### Prisma Seed

Prisma Seed permite insertar datos de prueba en la base.
Se crea un archivo `seed.ts` y se usa Prisma Client para insertar datos.
