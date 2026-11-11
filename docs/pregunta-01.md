# Pregunta 1. Diseño e implementación del modelo de datos

**Enunciado.** Construya el modelo de almacenamiento en Apache Hive para el dataset Superstore: identificar campos, diccionario de datos, tabla analítica con tipos apropiados y procedimiento de carga.

## Estrategia

Separé la ingesta de la capa analítica.

1. **Landing** (`stg_superstore`): tabla externa sobre el directorio HDFS `/tem1_2mom/eduardoantezana`. Todos los campos son `STRING` y el SerDe es `OpenCSVSerde`, porque los nombres de producto traen comas y comillas.
2. **Analítica** (`superstore`): tabla interna ORC con Snappy. Aquí van los tipos nativos (`INT`, `DATE`, `DECIMAL`) y el ZIP se normaliza a cinco dígitos con `LPAD`.
3. La carga es un `INSERT OVERWRITE ... SELECT` con `unix_timestamp(..., 'M/d/yyyy')` para las fechas estadounidenses.

El diccionario está en [`docs/diccionario-de-datos.md`](diccionario-de-datos.md). El DDL y el DML están en [`sql/01_ddl.sql`](../sql/01_ddl.sql) y [`sql/02_dml.sql`](../sql/02_dml.sql).

`skip.header.line.count` no se aplica con OpenCSVSerde, así que el DML descarta la fila cuyo `row_id` es `Row ID`.

## Consulta HiveQL

DDL y DML: [`sql/01_ddl.sql`](../sql/01_ddl.sql), [`sql/02_dml.sql`](../sql/02_dml.sql).

## Evidencia de ejecución

Capturas en [`evidencias/pregunta_01/`](../evidencias/pregunta_01/).

## Resultado

- HDFS: `/tem1_2mom/eduardoantezana/Sample_Superstore.csv` (2.2 MB).
- Base `db_eduardoantezana`, tablas `stg_superstore` (TEXTFILE) y `superstore` (ORC).
- **9.994 registros** importados en la tabla analítica.
- Las diez primeras filas coinciden con el CSV (fechas en `yyyy-MM-dd`, descuentos en `DECIMAL(4,2)`).

## Interpretación

El modelo deja el CSV crudo consultable y, al mismo tiempo, una tabla tipada para el resto del examen. Si no convirtiera las fechas en la carga, cada consulta posterior tendría que repetir `unix_timestamp`. ORC reduce el volumen respecto al texto y permite predicados sobre tipos reales, no sobre cadenas.

## Conclusión

El dataset queda almacenado en Hive con tipos coherentes, 9.994 líneas cargadas y un diccionario que documenta dominio y restricciones. A partir de aquí las preguntas 2 a 8 leen solo `superstore`, salvo la auditoría de calidad, que también mira el landing para ver el ZIP sin rellenar.
