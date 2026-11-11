-- Analisis de optimizacion: ORC, estadisticas y particion por anio
USE db_eduardoantezana;
SET hive.resultset.use.unique.column.names=false;
SET hive.execution.engine=mr;
SET hive.cbo.enable=true;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;
SET hive.exec.max.dynamic.partitions = 20;
SET hive.exec.max.dynamic.partitions.pernode = 20;

ANALYZE TABLE superstore COMPUTE STATISTICS;

DESCRIBE FORMATTED superstore;

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
STORED AS ORC
TBLPROPERTIES ('orc.compress' = 'SNAPPY');

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

SHOW PARTITIONS superstore_part;

SELECT anio, COUNT(*) AS registros, ROUND(SUM(sales), 2) AS ventas
FROM superstore_part
GROUP BY anio
ORDER BY anio;

SELECT anio, COUNT(*) AS registros, ROUND(SUM(sales), 2) AS ventas
FROM superstore_part
WHERE anio = 2017
GROUP BY anio;
