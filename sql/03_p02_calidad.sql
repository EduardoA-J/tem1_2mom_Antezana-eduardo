-- Pregunta 2. Auditoria de calidad e integridad
USE db_eduardoantezana;
SET hive.resultset.use.unique.column.names=false;

-- Resumen pedido por el enunciado (CSV aterrizado, sin la cabecera)
-- OpenCSVSerde no aplica skip.header.line.count; se excluye la fila "Row ID"
SELECT
  COUNT(*) AS total_registros,
  COUNT(*) - COUNT(DISTINCT row_id) AS row_id_duplicados,
  COUNT(DISTINCT order_id) AS ordenes_unicas,
  COUNT(DISTINCT customer_id) AS clientes_unicos,
  SUM(CASE WHEN unix_timestamp(order_date, 'M/d/yyyy') IS NULL THEN 1 ELSE 0 END) AS fechas_pedido_invalidas,
  SUM(CASE WHEN unix_timestamp(ship_date, 'M/d/yyyy') IS NULL THEN 1 ELSE 0 END) AS fechas_envio_invalidas,
  SUM(CASE WHEN unix_timestamp(ship_date, 'M/d/yyyy') < unix_timestamp(order_date, 'M/d/yyyy') THEN 1 ELSE 0 END) AS envio_antes_de_pedido,
  SUM(CASE WHEN CAST(sales AS DOUBLE) <= 0 THEN 1 ELSE 0 END) AS ventas_iguales_o_inferiores_a_cero,
  SUM(CASE WHEN CAST(discount AS DOUBLE) < 0 OR CAST(discount AS DOUBLE) > 1 THEN 1 ELSE 0 END) AS descuentos_fuera_de_0_1,
  SUM(CASE WHEN LENGTH(TRIM(postal_code)) <> 5 THEN 1 ELSE 0 END) AS postal_code_distinto_de_5_digitos
FROM stg_superstore
WHERE TRIM(row_id) <> 'Row ID';

-- Campos con nulos o vacios
SELECT campo, n_nulos_o_vacios
FROM (
  SELECT 'row_id' AS campo, SUM(CASE WHEN row_id IS NULL OR TRIM(row_id) = '' THEN 1 ELSE 0 END) AS n_nulos_o_vacios FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'order_id', SUM(CASE WHEN order_id IS NULL OR TRIM(order_id) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'order_date', SUM(CASE WHEN order_date IS NULL OR TRIM(order_date) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'ship_date', SUM(CASE WHEN ship_date IS NULL OR TRIM(ship_date) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'ship_mode', SUM(CASE WHEN ship_mode IS NULL OR TRIM(ship_mode) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'customer_id', SUM(CASE WHEN customer_id IS NULL OR TRIM(customer_id) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'customer_name', SUM(CASE WHEN customer_name IS NULL OR TRIM(customer_name) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'segment', SUM(CASE WHEN segment IS NULL OR TRIM(segment) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'country', SUM(CASE WHEN country IS NULL OR TRIM(country) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'city', SUM(CASE WHEN city IS NULL OR TRIM(city) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'state', SUM(CASE WHEN state IS NULL OR TRIM(state) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'postal_code', SUM(CASE WHEN postal_code IS NULL OR TRIM(postal_code) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'region', SUM(CASE WHEN region IS NULL OR TRIM(region) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'product_id', SUM(CASE WHEN product_id IS NULL OR TRIM(product_id) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'category', SUM(CASE WHEN category IS NULL OR TRIM(category) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'sub_category', SUM(CASE WHEN sub_category IS NULL OR TRIM(sub_category) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'product_name', SUM(CASE WHEN product_name IS NULL OR TRIM(product_name) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'sales', SUM(CASE WHEN sales IS NULL OR TRIM(sales) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'quantity', SUM(CASE WHEN quantity IS NULL OR TRIM(quantity) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'discount', SUM(CASE WHEN discount IS NULL OR TRIM(discount) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
  UNION ALL SELECT 'profit', SUM(CASE WHEN profit IS NULL OR TRIM(profit) = '' THEN 1 ELSE 0 END) FROM stg_superstore WHERE TRIM(row_id) <> 'Row ID'
) nulos
ORDER BY campo;

-- Muestra de la inconsistencia de codigo postal (cero a la izquierda perdido)
SELECT state, COUNT(*) AS lineas_zip_4_digitos
FROM stg_superstore
WHERE TRIM(row_id) <> 'Row ID'
  AND LENGTH(TRIM(postal_code)) = 4
GROUP BY state
ORDER BY lineas_zip_4_digitos DESC;
