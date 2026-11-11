-- Pregunta 6. Impacto de los descuentos sobre la rentabilidad
USE db_eduardoantezana;
SET hive.resultset.use.unique.column.names=false;

WITH clasificado AS (
  SELECT
    category,
    sub_category,
    sales,
    profit,
    discount,
    CASE
      WHEN discount = 0 THEN 'Sin descuento'
      WHEN discount > 0 AND discount <= 0.20 THEN 'Descuento bajo'
      WHEN discount > 0.20 AND discount <= 0.50 THEN 'Descuento medio'
      ELSE 'Descuento alto'
    END AS rango_descuento
  FROM superstore
)
SELECT
  rango_descuento,
  COUNT(*) AS registros,
  ROUND(SUM(sales), 2) AS ventas,
  ROUND(SUM(profit), 2) AS ganancia,
  ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margen_pct,
  SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS registros_con_perdida,
  ROUND(SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS pct_no_rentables,
  ROUND(AVG(discount) * 100, 2) AS descuento_promedio_pct
FROM clasificado
GROUP BY rango_descuento
ORDER BY
  CASE rango_descuento
    WHEN 'Sin descuento' THEN 1
    WHEN 'Descuento bajo' THEN 2
    WHEN 'Descuento medio' THEN 3
    ELSE 4
  END;

-- Categorias y subcategorias mas afectadas en descuento alto
WITH clasificado AS (
  SELECT
    category,
    sub_category,
    sales,
    profit,
    discount,
    CASE
      WHEN discount = 0 THEN 'Sin descuento'
      WHEN discount > 0 AND discount <= 0.20 THEN 'Descuento bajo'
      WHEN discount > 0.20 AND discount <= 0.50 THEN 'Descuento medio'
      ELSE 'Descuento alto'
    END AS rango_descuento
  FROM superstore
)
SELECT
  category,
  sub_category,
  COUNT(*) AS registros,
  SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS registros_con_perdida,
  ROUND(SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS pct_no_rentables,
  ROUND(SUM(sales), 2) AS ventas,
  ROUND(SUM(profit), 2) AS ganancia,
  ROUND(AVG(discount) * 100, 2) AS descuento_promedio_pct
FROM clasificado
WHERE rango_descuento = 'Descuento alto'
GROUP BY category, sub_category
ORDER BY registros DESC;
