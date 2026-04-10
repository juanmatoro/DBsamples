---
title: Cómo escribir consultas SELECT
---

# Cómo escribir consultas SELECT

Esta guía explica, paso a paso, **cómo construir** una consulta `SELECT` en SQL: qué cláusulas existen, en qué orden se escriben y para qué sirve cada una. Los ejemplos usan la base de datos `world` (tablas `countries` y `cities`).

---

## 1. La plantilla básica

Toda consulta `SELECT` se escribe **siempre** siguiendo este esqueleto. Las cláusulas en **negrita** son obligatorias; el resto son opcionales, pero si aparecen tienen que ir en este orden:

```sql
SELECT      columnas              -- ¿qué quiero ver?
FROM        tabla                 -- ¿de dónde lo saco?
JOIN        otra_tabla ON ...     -- ¿necesito combinar tablas?
WHERE       condición             -- ¿qué filas me interesan?
GROUP BY    columnas              -- ¿quiero agrupar?
HAVING      condición             -- ¿qué grupos me interesan?
ORDER BY    columnas              -- ¿en qué orden las quiero?
LIMIT       n OFFSET m            -- ¿cuántas filas y desde dónde?
;
```

Si te saltas el orden (por ejemplo poner `WHERE` antes de `FROM`), la consulta no funciona. Una buena regla de oro: **escribe las cláusulas siempre en este orden, aunque no uses todas**.

---

## 2. `SELECT` — qué columnas quieres ver

Es la primera palabra y dice **qué datos** quieres que aparezcan en el resultado.

```sql
SELECT name, population FROM countries;
```

Cosas que puedes poner detrás de `SELECT`:

- **Columnas concretas** separadas por coma:
  ```sql
  SELECT name, capital, population FROM countries;
  ```
- **Todas las columnas** con `*` (cómodo para explorar, mal estilo en código real):
  ```sql
  SELECT * FROM countries;
  ```
- **Alias** con `AS` para renombrar columnas en el resultado:
  ```sql
  SELECT name AS pais, population AS poblacion FROM countries;
  ```
- **Expresiones calculadas**: operaciones, funciones, concatenaciones…
  ```sql
  SELECT name, population / area_sq_km AS densidad FROM countries;
  ```
- **`DISTINCT`** para eliminar filas duplicadas:
  ```sql
  SELECT DISTINCT region FROM countries;
  ```

> 💡 Si una columna tiene un nombre raro o con espacios, ponla entre comillas dobles: `"wikiDataId"`.

---

## 3. `FROM` — de qué tabla salen los datos

Indica la tabla (o tablas) de donde se leen las filas. Puedes ponerle un **alias corto** detrás del nombre para escribir menos:

```sql
SELECT co.name, co.population
FROM   countries AS co;
```

El `AS` es opcional, así que `FROM countries co` también vale.

---

## 4. `JOIN ... ON` — combinar varias tablas

Cuando los datos que necesitas están repartidos en varias tablas, usas `JOIN` para emparejarlas. La condición `ON` dice **cómo se relacionan** (normalmente clave primaria con clave foránea).

```sql
SELECT ci.name AS ciudad, co.name AS pais
FROM   cities    ci
JOIN   countries co ON co.id = ci.country_id;
```

Tipos de join más comunes:

| Tipo            | Qué hace                                                                 |
|-----------------|--------------------------------------------------------------------------|
| `INNER JOIN`    | Solo filas que tienen pareja en las dos tablas (es lo mismo que `JOIN`). |
| `LEFT JOIN`     | Todas las filas de la tabla de la izquierda, aunque no tengan pareja.   |
| `RIGHT JOIN`    | Todas las filas de la tabla de la derecha.                              |
| `FULL JOIN`     | Todas las filas de ambas tablas.                                        |

> 💡 Buena práctica: usa siempre alias (`ci`, `co`) y prefija las columnas (`ci.name`, `co.name`) para que quede claro de dónde viene cada cosa.

---

## 5. `WHERE` — filtrar filas

Sirve para quedarte solo con las filas que cumplen una condición.

```sql
SELECT name, population
FROM   countries
WHERE  region = 'Europe';
```

Operadores que puedes usar:

| Operador            | Significado                          | Ejemplo                                |
|---------------------|--------------------------------------|----------------------------------------|
| `=`, `<>`, `!=`     | Igual / distinto                     | `region = 'Asia'`                      |
| `<`, `>`, `<=`, `>=`| Comparaciones numéricas              | `population > 1000000`                 |
| `BETWEEN a AND b`   | Entre dos valores (incluidos)        | `population BETWEEN 1e6 AND 5e6`       |
| `IN (...)`          | Está dentro de una lista             | `region IN ('Asia','Africa')`          |
| `NOT IN (...)`      | No está en la lista                  | `region NOT IN ('Europe')`             |
| `LIKE 'patrón'`     | Coincide con un patrón de texto      | `name LIKE 'A%'` (empieza por A)       |
| `ILIKE`             | Como `LIKE` pero ignora mayúsculas (PostgreSQL) | `name ILIKE 'a%'`           |
| `IS NULL`           | El campo está vacío                  | `capital IS NULL`                      |
| `IS NOT NULL`       | El campo tiene valor                 | `capital IS NOT NULL`                  |

Para combinar varias condiciones se usan `AND`, `OR` y `NOT`:

```sql
SELECT name, population
FROM   countries
WHERE  region = 'Africa'
  AND  population > 10000000;
```

> ⚠️ **Importante**: en `WHERE` no puedes usar los alias que has puesto en `SELECT`. Si calculas algo (por ejemplo `densidad`), tienes que repetir la expresión completa:
> ```sql
> WHERE population / area_sq_km > 500   -- ✅
> WHERE densidad > 500                  -- ❌ no funciona
> ```

---

## 6. `GROUP BY` — agrupar filas

Sirve para juntar filas que comparten un valor y poder aplicarles **funciones de agregación** (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`).

```sql
SELECT region, COUNT(*) AS total_paises, SUM(population) AS poblacion_total
FROM   countries
GROUP  BY region;
```

Reglas básicas:

- Toda columna que aparezca en `SELECT` y **no** esté dentro de una función de agregación tiene que aparecer también en el `GROUP BY`.
- Las funciones de agregación más usadas:
  - `COUNT(*)` → cuántas filas hay.
  - `SUM(columna)` → suma.
  - `AVG(columna)` → media.
  - `MIN(columna)` / `MAX(columna)` → mínimo / máximo.

---

## 7. `HAVING` — filtrar grupos

Es como `WHERE`, pero se aplica **después** de agrupar. Lo usas cuando quieres filtrar por el resultado de una agregación.

```sql
SELECT region, COUNT(*) AS total
FROM   countries
GROUP  BY region
HAVING COUNT(*) > 30;
```

Regla rápida: **`WHERE` filtra filas individuales, `HAVING` filtra grupos.**

---

## 8. `ORDER BY` — ordenar el resultado

Ordena el resultado por una o varias columnas. Por defecto es ascendente (`ASC`); para descendente usa `DESC`.

```sql
SELECT name, population
FROM   countries
ORDER  BY population DESC;
```

Cosas útiles:

- Ordenar por varias columnas (primero por una, en caso de empate por otra):
  ```sql
  ORDER BY region ASC, population DESC
  ```
- Puedes usar el alias del `SELECT` aquí (a diferencia de `WHERE`):
  ```sql
  SELECT name, population AS poblacion
  FROM   countries
  ORDER  BY poblacion DESC;
  ```
- Controlar dónde van los `NULL`: `NULLS FIRST` o `NULLS LAST`.

---

## 9. `LIMIT` y `OFFSET` — recortar el resultado

Sirven para devolver solo unas pocas filas.

- `LIMIT n` → devuelve como mucho `n` filas.
- `OFFSET m` → se salta las primeras `m` filas.

```sql
-- Los 10 primeros países por población
SELECT name, population
FROM   countries
ORDER  BY population DESC
LIMIT  10;

-- Del 11 al 20 (página 2)
SELECT name, population
FROM   countries
ORDER  BY population DESC
LIMIT  10 OFFSET 10;
```

> 💡 `LIMIT` casi siempre se usa con un `ORDER BY` delante. Sin él, el motor te puede devolver cualquier 10 filas.

---

## 10. Receta para construir una consulta paso a paso

Cuando te enfrentes a una consulta nueva, escríbela en este orden mental:

1. **¿De qué tabla salgo?** → empieza por `FROM`.
2. **¿Necesito combinar otra tabla?** → añade `JOIN ... ON`.
3. **¿Qué filas me sirven?** → añade `WHERE`.
4. **¿Quiero agrupar?** → añade `GROUP BY` (y `HAVING` si filtras grupos).
5. **¿Qué columnas quiero ver?** → completa el `SELECT`.
6. **¿En qué orden?** → añade `ORDER BY`.
7. **¿Cuántas filas?** → añade `LIMIT` / `OFFSET`.

Aunque al ejecutarlo el motor lo procese en otro orden, **escribirlo así te ayuda a no olvidar nada**.

---

## 11. Ejemplo completo comentado

> "Dame las 5 ciudades europeas más pobladas con más de 1.500.000 habitantes, mostrando ciudad, país y población formateada."

```sql
SELECT                                                  -- 5. qué quiero ver
    ci.name AS ciudad,
    co.name AS pais,
    TO_CHAR(ci.population, '999G999G999') AS poblacion
FROM   cities    ci                                     -- 1. tabla principal
JOIN   countries co ON co.id = ci.country_id            -- 2. junto con países
WHERE  co.region = 'Europe'                             -- 3. solo Europa
  AND  ci.population > 1500000                          --    y > 1.5M hab.
ORDER  BY ci.population DESC                            -- 6. ordenadas por población
LIMIT  5;                                               -- 7. solo 5
```

Lectura en lenguaje humano:
*"De la tabla `cities` (alias `ci`), unida con `countries` (alias `co`) por el id del país, dame las 5 filas con mayor población cuyo país sea de Europa y cuya población supere 1,5 millones, mostrando el nombre de la ciudad, el del país y la población con separadores de miles."*

---

## 12. Errores típicos al empezar

| Error                                                              | Por qué pasa                                                   | Solución                                                       |
|--------------------------------------------------------------------|----------------------------------------------------------------|----------------------------------------------------------------|
| `column "densidad" does not exist`                                 | Usaste un alias del `SELECT` dentro del `WHERE`.               | Repite la expresión completa, o usa una subconsulta.           |
| `must appear in the GROUP BY clause`                               | Pusiste una columna en `SELECT` sin agregar y sin agrupar.     | Añade la columna al `GROUP BY` o envuélvela en `MIN`/`MAX`/etc.|
| `syntax error at or near "WHERE"`                                  | Escribiste las cláusulas en otro orden.                        | Respeta el orden `SELECT-FROM-JOIN-WHERE-GROUP-HAVING-ORDER-LIMIT`. |
| Resultado ordenado raro al usar `TO_CHAR`                          | Estás ordenando por el texto formateado, no por el número.     | En `ORDER BY` usa la columna numérica original.                |
| `LIMIT` sin `ORDER BY` devuelve filas distintas cada vez           | Sin orden, el motor decide.                                    | Añade siempre un `ORDER BY` antes del `LIMIT`.                 |

---

## TL;DR

```text
SELECT   columnas         → qué quiero ver
FROM     tabla            → de dónde
JOIN ... ON ...           → con qué la combino
WHERE    condición        → qué filas
GROUP BY columnas         → cómo agrupo
HAVING   condición        → qué grupos
ORDER BY columnas         → cómo ordeno
LIMIT    n OFFSET m       → cuántas y desde dónde
```

Si memorizas esta plantilla y para qué sirve cada línea, puedes escribir el 90% de las consultas que vas a necesitar.
