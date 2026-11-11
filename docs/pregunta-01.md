# Pregunta 1. Diseño e implementación del modelo de datos

**Enunciado.** Construya el modelo de almacenamiento en Apache Hive para el dataset Superstore: identificar campos, diccionario de datos, tabla analítica con tipos apropiados y procedimiento de carga.

## Estrategia

No cargué el CSV directo a una tabla tipada. Primero lo dejé crudo y después lo pasé a tipos Hive, porque si el SerDe o las fechas fallaban quería poder revisar el texto original.

1. **Landing** (`stg_superstore`): tabla externa sobre `/tem1_2mom/eduardoantezana`. Todo en `STRING` y `OpenCSVSerde`, porque hay nombres de producto con comas y comillas; un split simple por coma los parte mal.
2. **Analítica** (`superstore`): tabla ORC con Snappy. Ahí sí puse `INT`, `DATE` y `DECIMAL`, y el ZIP lo rellené a cinco dígitos con `LPAD`.
3. La carga es un `INSERT OVERWRITE ... SELECT`. Las fechas del archivo vienen como `11/8/2016`, así que usé `unix_timestamp(..., 'M/d/yyyy')`.

El diccionario está en [`docs/diccionario-de-datos.md`](diccionario-de-datos.md). El DDL y el DML están en [`sql/01_ddl.sql`](../sql/01_ddl.sql) y [`sql/02_dml.sql`](../sql/02_dml.sql).

`skip.header.line.count` con OpenCSVSerde no me saltó la cabecera, así que en el `INSERT` filtré `row_id <> 'Row ID'`.

## Consulta HiveQL

DDL y DML: [`sql/01_ddl.sql`](../sql/01_ddl.sql), [`sql/02_dml.sql`](../sql/02_dml.sql).

## Evidencia de ejecución

Capturas en [`evidencias/pregunta_01/`](../evidencias/pregunta_01/).

## Resultado

- El CSV quedó en HDFS: `/tem1_2mom/eduardoantezana/Sample_Superstore.csv` (2,2 MB).
- Base `db_eduardoantezana`, tablas `stg_superstore` (TEXTFILE) y `superstore` (ORC).
- En la analítica cargaron **9.994 registros**.
- Las diez primeras filas coinciden con el archivo; las fechas ya salen `yyyy-MM-dd` y el descuento como `DECIMAL(4,2)`.

## Interpretación

La idea de las dos capas es práctica: el landing me sirve para auditar (pregunta 2) y la ORC es la que uso en el resto. Convertir las fechas una sola vez en la carga evita repetir `unix_timestamp` en cada consulta. ORC además deja el archivo mucho más chico que el CSV; en el `DESCRIBE FORMATTED` se ve 354 KB contra unos 18 MB de dato crudo.

## Conclusión

El Superstore quedó en Hive con tipos que se pueden agregar sin estar casteando a cada rato, y con las 9.994 líneas del CSV. A partir de acá trabajo sobre `superstore`; el landing lo vuelvo a usar solo cuando necesito ver el ZIP tal como venía en el archivo.
