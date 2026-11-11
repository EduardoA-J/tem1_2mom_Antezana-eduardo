-- Pregunta 7. Tendencias temporales mensuales
-- LAG mes anterior, LAG 12 meses (mismo mes ano anterior), promedio movil 3 meses
USE db_eduardoantezana;
SET hive.resultset.use.unique.column.names=false;

WITH mensual AS (
  SELECT
    YEAR(order_date) AS anio,
    MONTH(order_date) AS mes_n,
    CONCAT(CAST(YEAR(order_date) AS STRING), '-', LPAD(CAST(MONTH(order_date) AS STRING), 2, '0')) AS anio_mes,
    SUM(sales) AS ventas,
    SUM(profit) AS ganancia
  FROM superstore
  GROUP BY YEAR(order_date), MONTH(order_date)
),
serie AS (
  SELECT
    anio,
    mes_n,
    anio_mes,
    ventas,
    ganancia,
    LAG(ventas, 1) OVER (ORDER BY anio, mes_n) AS ventas_mes_anterior,
    ROUND(
      (ventas - LAG(ventas, 1) OVER (ORDER BY anio, mes_n))
      / LAG(ventas, 1) OVER (ORDER BY anio, mes_n) * 100, 2
    ) AS variacion_mes_anterior_pct,
    LAG(ventas, 12) OVER (ORDER BY anio, mes_n) AS ventas_mismo_mes_anio_anterior,
    ROUND(
      (ventas - LAG(ventas, 12) OVER (ORDER BY anio, mes_n))
      / LAG(ventas, 12) OVER (ORDER BY anio, mes_n) * 100, 2
    ) AS variacion_interanual_pct,
    ROUND(
      AVG(ventas) OVER (
        ORDER BY anio, mes_n
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
      ), 2
    ) AS promedio_movil_3_meses
  FROM mensual
)
SELECT
  anio_mes,
  ROUND(ventas, 2) AS ventas,
  ROUND(ganancia, 2) AS ganancia,
  ROUND(ventas_mes_anterior, 2) AS ventas_mes_anterior,
  variacion_mes_anterior_pct,
  ROUND(ventas_mismo_mes_anio_anterior, 2) AS ventas_mismo_mes_anio_anterior,
  variacion_interanual_pct,
  promedio_movil_3_meses
FROM serie
ORDER BY anio, mes_n;

-- Tres meses con mayor y menor volumen de ventas
WITH mensual AS (
  SELECT
    CONCAT(CAST(YEAR(order_date) AS STRING), '-', LPAD(CAST(MONTH(order_date) AS STRING), 2, '0')) AS anio_mes,
    SUM(sales) AS ventas,
    SUM(profit) AS ganancia
  FROM superstore
  GROUP BY YEAR(order_date), MONTH(order_date)
),
extremos AS (
  SELECT
    anio_mes,
    ROUND(ventas, 2) AS ventas,
    ROUND(ganancia, 2) AS ganancia,
    RANK() OVER (ORDER BY ventas DESC) AS rank_mayor,
    RANK() OVER (ORDER BY ventas ASC) AS rank_menor
  FROM mensual
)
SELECT
  CASE
    WHEN rank_mayor <= 3 THEN 'Mayor volumen'
    WHEN rank_menor <= 3 THEN 'Menor volumen'
  END AS grupo,
  anio_mes,
  ventas,
  ganancia,
  rank_mayor,
  rank_menor
FROM extremos
WHERE rank_mayor <= 3 OR rank_menor <= 3
ORDER BY ventas DESC;
