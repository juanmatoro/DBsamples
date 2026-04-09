# Ejemplos Node + PostgreSQL (Chinook)

Scripts en TypeScript que ejecutan consultas de funciones SQL usando `pg`.

**Requisitos**
- Node.js 18+
- Base `chinook` en PostgreSQL

**Instalacion**
```bash
npm install
```

**Variables de entorno**
- `DB_HOST` (default: `localhost`)
- `DB_PORT` (default: `5432`)
- `DB_USER` (default: `postgres`)
- `DB_PASSWORD`
- `DB_NAME` (default: `chinook`)

**Ejecutar un ejemplo**
```bash
npm run funciones-cadena
```

**Ejecutar todos**
```bash
npm run all
```

Ejemplos disponibles:
- `funciones-cadena`
- `funciones-nativas`
- `funciones-agregacion`
- `funciones-numericas`
- `funciones-fecha-hora`
- `otras-funciones`
- `funciones-control-flujo`
- `funciones-conversion`
- `funciones-sistema`
- `funciones-cifrado`

**Calculos en la base vs en Node (cuando conviene)**
- **Mejor en la base de datos**: agregaciones grandes, filtros complejos, joins y rankings. Reduce trafico de datos y aprovecha indices.
- **Mejor en Node**: logica de negocio, formato final y transformaciones pequeñas sobre pocos registros.
- **Regla practica**: si la operacion reduce datos, hazla en SQL; si solo presenta datos, hazla en Node.

**Nota**
El ejemplo de `funciones-cifrado` usa `pgcrypto` para `sha256`.
Si no esta disponible, ejecuta en la DB:
```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```
