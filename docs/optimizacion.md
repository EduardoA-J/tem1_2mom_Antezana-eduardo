# Análisis de optimización

El documento pide este apartado en el repositorio. No es una pregunta numerada; acá dejo lo que cambié en Hive y por qué.

## Lo que ya baja costo desde el modelo

1. **Landing en texto y analítica en ORC + Snappy.** El CSV se lee una vez. De la pregunta 3 en adelante trabajo sobre columnas tipadas y comprimidas, no sobre 21 `STRING`.
2. **Tipos nativos.** Con `DATE` y `DECIMAL` puedo hacer `YEAR(order_date)` y `SUM(sales)` sin `unix_timestamp` ni `CAST` en cada consulta.
3. **Limpiar en la carga.** El filtro de la cabecera y el `LPAD` del ZIP se pagan una vez.

## Estadísticas

Corrí `ANALYZE TABLE superstore COMPUTE STATISTICS`. El `DESCRIBE FORMATTED` quedó con **9.994 filas**, **1 archivo ORC de 354.457 bytes** y `rawDataSize` 17.979.206: o sea, el ORC pesa más o menos el 2 % del texto. Intenté un `EXPLAIN` después de estadísticas de columna y el CLI se cayó (Hive 4 busca una clase de Tez que esta imagen no trae), así que la evidencia de este punto es el `DESCRIBE` con `numRows` / `totalSize` y la tabla particionada, no el plan Tez.

## Partición por año

Armé `superstore_part` particionada por `anio`. Un `WHERE anio = 2017` no tiene por qué leer 2014-2016. Me pareció más útil que particionar por región: región son solo cuatro valores y casi todas las series del examen cortan por año o por mes.

`SHOW PARTITIONS` lista 2014 a 2017. Conteos: 2014 = 1.993 líneas (484.248 de ventas), 2015 = 2.102 (470.533), 2016 = 2.587 (609.206), 2017 = 3.312 (733.215). El filtro `anio = 2017` devuelve esas 3.312 filas.

## Lo que no usé

- **Tez:** el laboratorio corre `hive.execution.engine=mr` en modo local. Para 9.994 filas alcanza.
- **Bucketing por `customer_id`:** sirve si hay joins grandes de clientes; acá no los hay.
- **Índices clásicos de Hive:** están deprecados. Con este volumen alcanzan ORC y las estadísticas.

## Conclusión de optimización

Con este tamaño el problema no es el motor, es volver a leer el CSV. ORC + estadísticas + partición por año deja las consultas en pocos segundos y, si el Superstore creciera, el modelo ya no depende de escanear texto en cada pregunta.
