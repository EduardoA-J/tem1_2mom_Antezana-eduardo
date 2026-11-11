-- Pregunta 1. Carga: conversion de tipos, fechas M/d/yyyy y ZIP a 5 digitos
USE db_eduardoantezana;

SET hive.stats.autogather=false;
SET hive.exec.mode.local.auto=true;

INSERT OVERWRITE TABLE superstore
SELECT
  CAST(row_id AS INT) AS row_id,
  order_id,
  TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP(order_date, 'M/d/yyyy'))) AS order_date,
  TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP(ship_date, 'M/d/yyyy'))) AS ship_date,
  ship_mode,
  customer_id,
  customer_name,
  segment,
  country,
  city,
  state,
  LPAD(postal_code, 5, '0') AS postal_code,
  region,
  product_id,
  category,
  sub_category,
  product_name,
  CAST(sales AS DECIMAL(12,4)) AS sales,
  CAST(quantity AS INT) AS quantity,
  CAST(discount AS DECIMAL(4,2)) AS discount,
  CAST(profit AS DECIMAL(12,4)) AS profit
FROM stg_superstore
WHERE row_id IS NOT NULL
  AND TRIM(row_id) <> ''
  AND TRIM(row_id) <> 'Row ID';

SELECT COUNT(*) AS registros_importados FROM superstore;
SELECT * FROM superstore ORDER BY row_id LIMIT 10;
