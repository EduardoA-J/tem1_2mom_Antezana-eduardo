-- Pregunta 8. Pareto 80/20 de ventas y de ganancias
USE db_eduardoantezana;

-- a) cuantos productos concentran el 80 % de las ventas
WITH producto AS (
  SELECT
    product_id,
    MAX(product_name) AS product_name,
    SUM(sales) AS ventas
  FROM superstore
  GROUP BY product_id
),
ordenado AS (
  SELECT
    product_id,
    product_name,
    ventas,
    ROUND(ventas / SUM(ventas) OVER () * 100, 4) AS pct_individual,
    ROUND(
      SUM(ventas) OVER (ORDER BY ventas DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
      / SUM(ventas) OVER () * 100, 2
    ) AS pct_acum,
    ROW_NUMBER() OVER (ORDER BY ventas DESC) AS n_producto,
    COUNT(*) OVER () AS total_productos
  FROM producto
)
SELECT
  MIN(CASE WHEN pct_acum >= 80 THEN n_producto END) AS productos_para_80_pct_ventas,
  MAX(total_productos) AS total_productos,
  ROUND(
    MIN(CASE WHEN pct_acum >= 80 THEN n_producto END) / MAX(total_productos) * 100, 2
  ) AS pct_catalogo
FROM ordenado;

-- a) productos de mayor contribucion a ventas (cabeza de la curva)
WITH producto AS (
  SELECT
    product_id,
    MAX(product_name) AS product_name,
    SUM(sales) AS ventas
  FROM superstore
  GROUP BY product_id
)
SELECT
  ROW_NUMBER() OVER (ORDER BY ventas DESC) AS n_producto,
  product_id,
  product_name,
  ROUND(ventas, 2) AS ventas,
  ROUND(ventas / SUM(ventas) OVER () * 100, 4) AS pct_individual,
  ROUND(
    SUM(ventas) OVER (ORDER BY ventas DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
    / SUM(ventas) OVER () * 100, 2
  ) AS pct_acum
FROM producto
ORDER BY ventas DESC
LIMIT 15;

-- b) cuantos productos concentran el 80 % de la ganancia positiva
WITH producto AS (
  SELECT
    product_id,
    MAX(product_name) AS product_name,
    SUM(profit) AS ganancia
  FROM superstore
  GROUP BY product_id
),
positivos AS (
  SELECT * FROM producto WHERE ganancia > 0
),
ordenado AS (
  SELECT
    product_id,
    product_name,
    ganancia,
    ROUND(ganancia / SUM(ganancia) OVER () * 100, 4) AS pct_individual,
    ROUND(
      SUM(ganancia) OVER (ORDER BY ganancia DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
      / SUM(ganancia) OVER () * 100, 2
    ) AS pct_acum,
    ROW_NUMBER() OVER (ORDER BY ganancia DESC) AS n_producto,
    COUNT(*) OVER () AS productos_con_ganancia,
    (SELECT COUNT(*) FROM producto) AS total_productos
  FROM positivos
)
SELECT
  MIN(CASE WHEN pct_acum >= 80 THEN n_producto END) AS productos_para_80_pct_ganancia,
  MAX(productos_con_ganancia) AS productos_con_ganancia_positiva,
  MAX(total_productos) AS total_productos,
  ROUND(
    MIN(CASE WHEN pct_acum >= 80 THEN n_producto END) / MAX(total_productos) * 100, 2
  ) AS pct_catalogo
FROM ordenado;

-- b) productos de mayor contribucion a la ganancia
WITH producto AS (
  SELECT
    product_id,
    MAX(product_name) AS product_name,
    SUM(profit) AS ganancia
  FROM superstore
  GROUP BY product_id
)
SELECT
  ROW_NUMBER() OVER (ORDER BY ganancia DESC) AS n_producto,
  product_id,
  product_name,
  ROUND(ganancia, 2) AS ganancia,
  ROUND(ganancia / SUM(ganancia) OVER () * 100, 4) AS pct_individual,
  ROUND(
    SUM(ganancia) OVER (ORDER BY ganancia DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
    / SUM(ganancia) OVER () * 100, 2
  ) AS pct_acum
FROM producto
WHERE ganancia > 0
ORDER BY ganancia DESC
LIMIT 15;
