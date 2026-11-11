# Análisis de optimización

El enunciado pide este apartado en el repositorio. No es una pregunta numerada; describe lo que apliqué sobre Hive y lo que medí con `EXPLAIN`.

## Decisiones de modelado que ya reducen costo

1. **Landing en texto, analítica en ORC + Snappy.** El CSV se lee una vez. Las preguntas 3 a 8 leen columnas tipadas y comprimidas. ORC evita deserializar 21 campos STRING en cada agregación.
2. **Tipos nativos.** `DATE` y `DECIMAL` permiten `YEAR(order_date)` y sumas sin `unix_timestamp` ni `CAST` repetidos.
3. **Predicados en la carga.** El filtro de cabecera y el `LPAD` del ZIP se pagan una vez.

## Estadísticas

`ANALYZE TABLE superstore COMPUTE STATISTICS` dejó la tabla con **9.994 filas**, **1 archivo ORC de 354.457 bytes** y `rawDataSize` 17.979.206 bytes: el ORC+Snappy queda en ~2 % del texto descomprimido. En este laboratorio un `EXPLAIN` posterior a las estadísticas de columna rompe el CLI (Hive 4 busca una clase de Tez que la imagen no trae), así que la evidencia de optimización es el `DESCRIBE FORMATTED` con `numRows`/`totalSize` y la tabla particionada.

## Partición por año

`superstore_part` está particionada por `anio`. Un filtro `WHERE anio = 2017` no lee 2014-2016. Tiene sentido porque todas las series temporales del examen cortan por año o mes. No particioné la tabla principal por región: hay solo cuatro valores y el beneficio sería menor que el de año.

`SHOW PARTITIONS` lista `anio=2014` … `anio=2017`. Conteos: 2014 = 1.993 líneas (484.248 de ventas), 2015 = 2.102 (470.533), 2016 = 2.587 (609.206), 2017 = 3.312 (733.215). Un `WHERE anio = 2017` sobre `superstore_part` devuelve solo esa partición (3.312 filas).

## Lo que no apliqué (y por qué)

- **Tez:** el clúster de laboratorio corre Hive 4 con `hive.execution.engine=mr` y modo local, suficiente para 9.994 filas.
- **Bucketing por `customer_id`:** útil para joins de clientes; este examen no hace joins entre tablas grandes.
- **Índices Hive clásicos:** deprecados; ORC + estadísticas cubren este volumen.

## Conclusión de optimización

En este tamaño el cuello no es el motor, es releer el CSV. La combinación ORC + estadísticas + partición por año deja las consultas analíticas en pocos segundos y deja el modelo listo si el Superstore creciera a millones de líneas.
