-- Pregunta 2. Auditoria de calidad e integridad
USE db_eduardoantezana;
SET hive.resultset.use.unique.column.names=false;

-- Resumen sobre la tabla analitica (9.994 lineas cargadas)
SELECT
  COUNT(*) AS total_registros,
  COUNT(*) - COUNT(DISTINCT row_id) AS row_id_duplicados,
  COUNT(DISTINCT order_id) AS ordenes_unicas,
  COUNT(DISTINCT customer_id) AS clientes_unicos,
  SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS fechas_pedido_invalidas,
  SUM(CASE WHEN ship_date IS NULL THEN 1 ELSE 0 END) AS fechas_envio_invalidas,
  SUM(CASE WHEN ship_date < order_date THEN 1 ELSE 0 END) AS envio_antes_de_pedido,
  SUM(CASE WHEN sales <= 0 THEN 1 ELSE 0 END) AS ventas_iguales_o_inferiores_a_cero,
  SUM(CASE WHEN discount < 0 OR discount > 1 THEN 1 ELSE 0 END) AS descuentos_fuera_de_0_1
FROM superstore;

-- Campos con NULL en la tabla analitica
SELECT campo, n_nulos
FROM (
  SELECT 'row_id' AS campo, SUM(CASE WHEN row_id IS NULL THEN 1 ELSE 0 END) AS n_nulos FROM superstore
  UNION ALL SELECT 'order_id', SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'order_date', SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'ship_date', SUM(CASE WHEN ship_date IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'ship_mode', SUM(CASE WHEN ship_mode IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'customer_id', SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'customer_name', SUM(CASE WHEN customer_name IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'segment', SUM(CASE WHEN segment IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'country', SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'city', SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'state', SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'postal_code', SUM(CASE WHEN postal_code IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'region', SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'product_id', SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'category', SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'sub_category', SUM(CASE WHEN sub_category IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'product_name', SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'sales', SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'quantity', SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'discount', SUM(CASE WHEN discount IS NULL THEN 1 ELSE 0 END) FROM superstore
  UNION ALL SELECT 'profit', SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) FROM superstore
) nulos
ORDER BY campo;

-- ZIP de 4 digitos en el CSV de aterrizaje (cero a la izquierda perdido)
SELECT state, COUNT(*) AS lineas_zip_4_digitos
FROM stg_superstore
WHERE LENGTH(TRIM(postal_code)) = 4
GROUP BY state
ORDER BY lineas_zip_4_digitos DESC;
