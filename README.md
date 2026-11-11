# tem1_2mom_Antezana-eduardo

Examen práctico individual del 2.º momento. Procesamiento y análisis del dataset **Sample Superstore** con **Apache Hive**.

| Campo | Valor |
|---|---|
| Estudiante | Eduardo Antezana |
| Institución | Universidad del Valle |
| Asignatura | Big Data |
| Repositorio | https://github.com/EduardoA-J/tem1_2mom_Antezana-eduardo |
| Dataset | [Superstore Dataset Final (Kaggle)](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final) |
| Motor | Apache Hive 4.0.1 sobre Hadoop 3.3.6 |

## Objetivo

Construir un modelo de almacenamiento en Hive, auditar la calidad del CSV, responder las ocho preguntas del examen con HiveQL (CTE, funciones de ventana, RFM, Pareto) y dejar el trabajo documentado en este repositorio, con historial de commits e evidencias de ejecución.

## Contenido

| Ruta | Contenido |
|---|---|
| [`data/Sample_Superstore.csv`](data/Sample_Superstore.csv) | Dataset en UTF-8, listo para ingestar |
| [`docs/diccionario-de-datos.md`](docs/diccionario-de-datos.md) | Diccionario de datos |
| [`sql/`](sql/) | DDL, DML y HiveQL de cada pregunta |
| [`docs/pregunta-01.md`](docs/pregunta-01.md) … [`docs/pregunta-08.md`](docs/pregunta-08.md) | Enunciado, estrategia, consulta, resultado, interpretación y conclusión |
| [`docs/optimizacion.md`](docs/optimizacion.md) | Análisis de optimización |
| [`docs/conclusiones.md`](docs/conclusiones.md) | Conclusiones generales |
| [`evidencias/pregunta_01`](evidencias/pregunta_01) … [`evidencias/pregunta_08`](evidencias/pregunta_08) | Capturas de ejecución (solo PNG) |

El enunciado del GitHub menciona “doce preguntas”. El documento de examen (vF) desarrolla **ocho** preguntas en tres bloques; este repositorio cubre esas ocho.

## Requisitos

- Docker Desktop
- Clúster Hadoop 3.3.6 con HDFS accesible (`namenode` en la red `hadoop_network`)
- Contenedor Hive 4.0.1 (`hive-server`) unido a la misma red
- El CSV de este repositorio

## Procedimiento de ejecución

### 1. Copiar el dataset a HDFS

```powershell
docker cp data/Sample_Superstore.csv namenode:/tmp/Sample_Superstore.csv
docker exec namenode hdfs dfs -mkdir -p /tem1_2mom/eduardoantezana
docker exec namenode hdfs dfs -put -f /tmp/Sample_Superstore.csv /tem1_2mom/eduardoantezana/Sample_Superstore.csv
docker exec namenode hdfs dfs -ls -h /tem1_2mom/eduardoantezana
```

### 2. Crear el modelo y cargar (Pregunta 1)

```powershell
docker cp sql/01_ddl.sql hive-server:/tmp/01_ddl.sql
docker cp sql/02_dml.sql hive-server:/tmp/02_dml.sql
docker exec hive-server sed -i 's/\r$//' /tmp/01_ddl.sql /tmp/02_dml.sql
docker exec -e HADOOP_HEAPSIZE=2048 hive-server hive -f /tmp/01_ddl.sql
docker exec -e HADOOP_HEAPSIZE=2048 hive-server hive -f /tmp/02_dml.sql
```

### 3. Consultas analíticas (Preguntas 2 a 8)

```powershell
docker cp sql hive-server:/tmp/sql
docker exec hive-server bash -c "sed -i 's/\r$//' /tmp/sql/*.sql"
docker exec -e HADOOP_HEAPSIZE=2048 hive-server hive -f /tmp/sql/03_p02_calidad.sql
docker exec -e HADOOP_HEAPSIZE=2048 hive-server hive -f /tmp/sql/04_p03_evolucion_region.sql
docker exec -e HADOOP_HEAPSIZE=2048 hive-server hive -f /tmp/sql/05_p04_rfm.sql
docker exec -e HADOOP_HEAPSIZE=2048 hive-server hive -f /tmp/sql/06_p05_ranking_productos.sql
docker exec -e HADOOP_HEAPSIZE=2048 hive-server hive -f /tmp/sql/07_p06_descuentos.sql
docker exec -e HADOOP_HEAPSIZE=2048 hive-server hive -f /tmp/sql/08_p07_tendencias.sql
docker exec -e HADOOP_HEAPSIZE=2048 hive-server hive -f /tmp/sql/09_p08_pareto.sql
```

### 4. Optimización

```powershell
docker exec -e HADOOP_HEAPSIZE=2048 hive-server hive -f /tmp/sql/10_optimizacion.sql
```

Base de datos: `db_eduardoantezana`.  
Tabla de aterrizaje: `stg_superstore`.  
Tabla analítica: `superstore` (ORC).

## Uso de herramientas

Se utilizó el entorno Cursor para organizar el repositorio, redactar la documentación y ejecutar Hive sobre el clúster local. El código HiveQL, los criterios RFM y la interpretación de cada consulta son responsabilidad del estudiante.
