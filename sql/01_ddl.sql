-- Pregunta 1. Modelo de almacenamiento Sample Superstore
-- Base: db_eduardoantezana
-- Landing STRING + OpenCSVSerde; analitica con tipos Hive y ORC

CREATE DATABASE IF NOT EXISTS db_eduardoantezana
COMMENT 'Examen 2do momento - Eduardo Antezana - Sample Superstore';

USE db_eduardoantezana;

DROP TABLE IF EXISTS stg_superstore;
CREATE EXTERNAL TABLE stg_superstore (
  row_id STRING,
  order_id STRING,
  order_date STRING,
  ship_date STRING,
  ship_mode STRING,
  customer_id STRING,
  customer_name STRING,
  segment STRING,
  country STRING,
  city STRING,
  state STRING,
  postal_code STRING,
  region STRING,
  product_id STRING,
  category STRING,
  sub_category STRING,
  product_name STRING,
  sales STRING,
  quantity STRING,
  discount STRING,
  profit STRING
)
COMMENT 'Aterrizaje del CSV Superstore. Todos los campos STRING.'
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ',',
  'quoteChar' = '"',
  'escapeChar' = '"'
)
STORED AS TEXTFILE
LOCATION '/tem1_2mom/eduardoantezana'
TBLPROPERTIES (
  'skip.header.line.count' = '1',
  'serialization.encoding' = 'UTF-8'
);

DROP TABLE IF EXISTS superstore;
CREATE TABLE superstore (
  row_id INT,
  order_id STRING,
  order_date DATE,
  ship_date DATE,
  ship_mode STRING,
  customer_id STRING,
  customer_name STRING,
  segment STRING,
  country STRING,
  city STRING,
  state STRING,
  postal_code STRING,
  region STRING,
  product_id STRING,
  category STRING,
  sub_category STRING,
  product_name STRING,
  sales DECIMAL(12,4),
  quantity INT,
  discount DECIMAL(4,2),
  profit DECIMAL(12,4)
)
COMMENT 'Tabla analitica Superstore. Tipos nativos, almacenamiento ORC.'
STORED AS ORC
TBLPROPERTIES (
  'orc.compress' = 'SNAPPY'
);

DESCRIBE FORMATTED db_eduardoantezana.stg_superstore;
DESCRIBE FORMATTED db_eduardoantezana.superstore;
