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

En `funciones-agregacion` se incluyen ejemplos de:
- `GROUP BY` basico
- `HAVING`
- agregacion mensual con `DATE_TRUNC`
- ranking de clientes con `JOIN`

**Calculos en la base vs en Node (cuando conviene)**
- **Mejor en la base de datos**: agregaciones grandes, filtros complejos, joins y rankings. Reduce trafico de datos y aprovecha indices.
- **Mejor en Node**: logica de negocio, formato final y transformaciones pequeñas sobre pocos registros.
- **Regla practica**: si la operacion reduce datos, hazla en SQL; si solo presenta datos, hazla en Node.

**Por que las agregaciones se lanzan desde Node pero las hace la DB**
- En backend normalmente necesitas KPIs (totales, promedios, rankings) para APIs y dashboards.
- Esas operaciones se ejecutan en la base porque esta optimizada con indices y motores de agregacion.
- Si las hicieras en Node, tendrias que traer miles de filas primero (mas lento y mas caro).
- Desde Node solo envias la consulta y recibes un resultado ya resumido.

**Nota**
El ejemplo de `funciones-cifrado` usa `pgcrypto` para `sha256`.
Si no esta disponible, ejecuta en la DB:
```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```
