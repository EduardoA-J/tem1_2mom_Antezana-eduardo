# tem1_2mom_Antezana-eduardo

Examen práctico individual del 2.º momento. Procesamiento y análisis del dataset **Sample Superstore** con **Apache Hive 4.0.1**.

| Campo | Valor |
|---|---|
| Estudiante | Eduardo Antezana |
| Institución | Universidad del Valle |
| Asignatura | Big Data |
| Repositorio | https://github.com/EduardoA-J/tem1_2mom_Antezana-eduardo |
| Dataset | [Superstore Dataset Final (Kaggle)](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final) |
| Motor | Apache Hive **4.0.1** (HiveServer2 + Beeline) |

## Objetivo

Construir un modelo de almacenamiento en Hive, auditar la calidad del CSV, responder las ocho preguntas del examen con HiveQL (CTE, funciones de ventana, RFM, Pareto) y dejar el trabajo documentado en este repositorio, con historial de commits e evidencias de ejecución.

## Contenido

| Ruta | Contenido |
|---|---|
| [`docker-compose.yml`](docker-compose.yml) | HiveServer2 4.0.1, listo para clonar y levantar |
| [`data/Sample_Superstore.csv`](data/Sample_Superstore.csv) | Dataset en UTF-8, montado en el contenedor |
| [`docs/diccionario-de-datos.md`](docs/diccionario-de-datos.md) | Diccionario de datos |
| [`sql/`](sql/) | DDL, DML y HiveQL de cada pregunta |
| [`scripts/ejecutar.ps1`](scripts/ejecutar.ps1) / [`scripts/ejecutar.sh`](scripts/ejecutar.sh) | Arranque + corrida de todos los `.sql` con Beeline |
| [`docs/pregunta-01.md`](docs/pregunta-01.md) … [`docs/pregunta-08.md`](docs/pregunta-08.md) | Enunciado, estrategia, consulta, resultado, interpretación y conclusión |
| [`docs/optimizacion.md`](docs/optimizacion.md) | Análisis de optimización |
| [`docs/conclusiones.md`](docs/conclusiones.md) | Conclusiones generales |
| [`evidencias/pregunta_01`](evidencias/pregunta_01) … [`evidencias/pregunta_08`](evidencias/pregunta_08) | Capturas de ejecución (solo PNG) |

El enunciado del GitHub menciona “doce preguntas”. El documento de examen (vF) desarrolla **ocho** preguntas en tres bloques; este repositorio cubre esas ocho.

## Requisitos

- Docker Desktop con Compose v2
- Unos 2 GB libres para la imagen `apache/hive:4.0.1`

No hace falta un clúster Hadoop aparte ni la red `hadoop_network`. El `docker-compose.yml` de este repo levanta HiveServer2 con metastore embebido (Derby) y el CSV montado en `/tem1_2mom/eduardoantezana`.

## Procedimiento de ejecución

Desde la raíz del repositorio clonado:

### 1. Levantar Hive 4

```powershell
docker compose up -d
```

Esperar a que HiveServer2 acepte conexiones (la UI queda en http://localhost:10002/). En Hive 4 el cliente es **Beeline**; el CLI `hive` quedó deprecado.

### 2. Crear el modelo y cargar (Pregunta 1)

El directorio `data/` ya está montado; no hay que copiar el CSV a HDFS.

```powershell
docker compose exec hiveserver2 beeline -u "jdbc:hive2://localhost:10000/" --showHeader=true -f /opt/sql/01_ddl.sql
docker compose exec hiveserver2 beeline -u "jdbc:hive2://localhost:10000/" --showHeader=true -f /opt/sql/02_dml.sql
```

### 3. Consultas analíticas (Preguntas 2 a 8)

```powershell
docker compose exec hiveserver2 beeline -u "jdbc:hive2://localhost:10000/" --showHeader=true -f /opt/sql/03_p02_calidad.sql
docker compose exec hiveserver2 beeline -u "jdbc:hive2://localhost:10000/" --showHeader=true -f /opt/sql/04_p03_evolucion_region.sql
docker compose exec hiveserver2 beeline -u "jdbc:hive2://localhost:10000/" --showHeader=true -f /opt/sql/05_p04_rfm.sql
docker compose exec hiveserver2 beeline -u "jdbc:hive2://localhost:10000/" --showHeader=true -f /opt/sql/06_p05_ranking_productos.sql
docker compose exec hiveserver2 beeline -u "jdbc:hive2://localhost:10000/" --showHeader=true -f /opt/sql/07_p06_descuentos.sql
docker compose exec hiveserver2 beeline -u "jdbc:hive2://localhost:10000/" --showHeader=true -f /opt/sql/08_p07_tendencias.sql
docker compose exec hiveserver2 beeline -u "jdbc:hive2://localhost:10000/" --showHeader=true -f /opt/sql/09_p08_pareto.sql
```

### 4. Optimización

```powershell
docker compose exec hiveserver2 beeline -u "jdbc:hive2://localhost:10000/" --showHeader=true -f /opt/sql/10_optimizacion.sql
```

Para correr todo de una vez:

```powershell
.\scripts\ejecutar.ps1
```

En Linux/macOS: `bash scripts/ejecutar.sh`.

Base de datos: `db_eduardoantezana`.  
Tabla de aterrizaje: `stg_superstore`.  
Tabla analítica: `superstore` (ORC).

## Sobre el historial de commits

Los commits están concentrados en un mismo día a propósito. Primero armé y validé **todas** las consultas en Hive; recién cuando el flujo entero corría empecé a documentar y a commitear por partes (README, diccionario, DDL, DML, cada bloque de HiveQL, textos y capturas). No subí cada intento fallido. Fue una decisión mía: preferí dejar el historial con el trabajo que sí quedó, no con el ensayo y error del medio.

## Bajar el entorno

```powershell
docker compose down
```

El volumen `hive-warehouse` guarda las tablas ORC entre reinicios. Para empezar de cero: `docker compose down -v`.
