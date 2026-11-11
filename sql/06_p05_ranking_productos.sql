-- Pregunta 5. Ranking de productos segun rentabilidad
-- RANK(), DENSE_RANK() y suma acumulada por categoria
USE db_eduardoantezana;
SET hive.resultset.use.unique.column.names=false;

WITH producto AS (
  SELECT
    category,
    product_id,
    MAX(product_name) AS product_name,
    SUM(sales) AS ventas,
    SUM(profit) AS ganancia,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margen_pct
  FROM superstore
  GROUP BY category, product_id
),
ranked AS (
  SELECT
    category,
    product_id,
    product_name,
    ventas,
    ganancia,
    margen_pct,
    RANK() OVER (PARTITION BY category ORDER BY ganancia DESC) AS rank_ganancia,
    DENSE_RANK() OVER (PARTITION BY category ORDER BY ganancia DESC) AS dense_ganancia,
    RANK() OVER (ORDER BY ventas DESC) AS rank_ventas_global,
    SUM(ganancia) OVER (
      PARTITION BY category
      ORDER BY ganancia DESC
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS ganancia_acumulada_categoria
  FROM producto
)
SELECT
  category,
  rank_ganancia,
  dense_ganancia,
  product_id,
  product_name,
  ROUND(ventas, 2) AS ventas,
  ROUND(ganancia, 2) AS ganancia,
  margen_pct,
  ROUND(ganancia_acumulada_categoria, 2) AS ganancia_acumulada_categoria
FROM ranked
WHERE rank_ganancia <= 5
ORDER BY category, rank_ganancia;

-- Cinco productos con mayor volumen de ventas
WITH producto AS (
  SELECT
    category,
    product_id,
    MAX(product_name) AS product_name,
    SUM(sales) AS ventas,
    SUM(profit) AS ganancia,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margen_pct
  FROM superstore
  GROUP BY category, product_id
)
SELECT
  RANK() OVER (ORDER BY ventas DESC) AS rank_ventas,
  DENSE_RANK() OVER (ORDER BY ventas DESC) AS dense_ventas,
  category,
  product_id,
  product_name,
  ROUND(ventas, 2) AS ventas,
  ROUND(ganancia, 2) AS ganancia,
  margen_pct
FROM producto
ORDER BY ventas DESC
LIMIT 5;

-- Cinco productos con menor rentabilidad (ganancia acumulada mas negativa)
WITH producto AS (
  SELECT
    category,
    product_id,
    MAX(product_name) AS product_name,
    SUM(sales) AS ventas,
    SUM(profit) AS ganancia,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margen_pct
  FROM superstore
  GROUP BY category, product_id
)
SELECT
  RANK() OVER (ORDER BY ganancia ASC) AS rank_peor_ganancia,
  category,
  product_id,
  product_name,
  ROUND(ventas, 2) AS ventas,
  ROUND(ganancia, 2) AS ganancia,
  margen_pct
FROM producto
ORDER BY ganancia ASC
LIMIT 5;
