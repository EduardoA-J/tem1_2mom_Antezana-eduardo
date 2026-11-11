-- Pregunta 3. Evolucion comercial por region (CTE + funciones de ventana)
USE db_eduardoantezana;
SET hive.resultset.use.unique.column.names=false;

WITH anual AS (
  SELECT
    region,
    YEAR(order_date) AS anio,
    SUM(sales) AS ventas,
    SUM(profit) AS ganancia
  FROM superstore
  GROUP BY region, YEAR(order_date)
),
evolucion AS (
  SELECT
    region,
    anio,
    ventas,
    ganancia,
    ROUND(ganancia / ventas * 100, 2) AS margen_pct,
    LAG(ventas) OVER (PARTITION BY region ORDER BY anio) AS ventas_anio_anterior,
    ROUND(
      (ventas - LAG(ventas) OVER (PARTITION BY region ORDER BY anio))
      / LAG(ventas) OVER (PARTITION BY region ORDER BY anio) * 100, 2
    ) AS variacion_ventas_pct,
    ROUND(
      (ganancia - LAG(ganancia) OVER (PARTITION BY region ORDER BY anio))
      / ABS(LAG(ganancia) OVER (PARTITION BY region ORDER BY anio)) * 100, 2
    ) AS variacion_ganancia_pct
  FROM anual
)
SELECT *
FROM evolucion
ORDER BY region, anio;

-- Region con mejor y peor desempeno (ganancia total y margen del periodo)
WITH total_region AS (
  SELECT
    region,
    SUM(sales) AS ventas_totales,
    SUM(profit) AS ganancia_total,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margen_pct
  FROM superstore
  GROUP BY region
)
SELECT
  region,
  ventas_totales,
  ganancia_total,
  margen_pct,
  RANK() OVER (ORDER BY ganancia_total DESC) AS rank_ganancia,
  CASE
    WHEN RANK() OVER (ORDER BY ganancia_total DESC) = 1 THEN 'Mejor desempeno'
    WHEN RANK() OVER (ORDER BY ganancia_total ASC) = 1 THEN 'Peor desempeno'
    ELSE NULL
  END AS etiqueta
FROM total_region
ORDER BY ganancia_total DESC;
