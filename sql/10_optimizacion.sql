-- Analisis de optimizacion: ORC, estadisticas y particion por anio
USE db_eduardoantezana;
SET hive.resultset.use.unique.column.names=false;

EXPLAIN
SELECT region, YEAR(order_date) AS anio, SUM(sales) AS ventas
FROM superstore
WHERE YEAR(order_date) = 2017
GROUP BY region, YEAR(order_date);

ANALYZE TABLE superstore COMPUTE STATISTICS;
ANALYZE TABLE superstore COMPUTE STATISTICS FOR COLUMNS
  region, order_date, sales, profit, discount, product_id, customer_id, category;

EXPLAIN
SELECT region, YEAR(order_date) AS anio, SUM(sales) AS ventas
FROM superstore
WHERE YEAR(order_date) = 2017
GROUP BY region, YEAR(order_date);

SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;
SET hive.exec.max.dynamic.partitions = 20;
SET hive.exec.max.dynamic.partitions.pernode = 20;

DROP TABLE IF EXISTS superstore_part;
CREATE TABLE superstore_part (
  row_id INT,
  order_id STRING,
  order_date DATE,
  ship_date DATE,
  region STRING,
  sales DECIMAL(12,4),
  profit DECIMAL(12,4)
)
PARTITIONED BY (anio INT)
STORED AS ORC;

INSERT OVERWRITE TABLE superstore_part PARTITION (anio)
SELECT
  row_id,
  order_id,
  order_date,
  ship_date,
  region,
  sales,
  profit,
  YEAR(order_date) AS anio
FROM superstore;

ANALYZE TABLE superstore_part PARTITION (anio) COMPUTE STATISTICS;

EXPLAIN
SELECT region, anio, SUM(sales) AS ventas
FROM superstore_part
WHERE anio = 2017
GROUP BY region, anio;

SELECT anio, COUNT(*) AS registros
FROM superstore_part
GROUP BY anio
ORDER BY anio;
