# Pregunta 2. Auditoría de calidad e integridad de datos

**Enunciado.** Analizar calidad: total de registros, Row ID duplicados, órdenes y clientes únicos, nulos, fechas inválidas, ventas ≤ 0, descuentos fuera de rango y envíos anteriores al pedido. Entregar un resumen y criterios de tratamiento.

## Estrategia

Audité el landing (`stg_superstore`), no la tabla ya limpia, para no ocultar el ZIP de 4 dígitos. Excluí la cabecera porque OpenCSVSerde no respeta `skip.header.line.count`. El resumen pedido va en una sola consulta; los nulos por campo y el detalle del ZIP van en dos consultas de apoyo.

Intervalo esperado del descuento: `[0, 1]`, que es el dominio de una fracción.

## Consulta HiveQL

[`sql/03_p02_calidad.sql`](../sql/03_p02_calidad.sql)

## Evidencia de ejecución

Capturas en [`evidencias/pregunta_02/`](../evidencias/pregunta_02/).

## Resultado

| Métrica | Valor |
|---|---|
| Total de registros | 9.994 |
| Row ID duplicados | 0 |
| Órdenes únicas | 5.009 |
| Clientes únicos | 793 |
| Campos con NULL o vacío | ninguno (0 en las 21 columnas) |
| Fechas de pedido inválidas | 0 |
| Fechas de envío inválidas | 0 |
| Envío anterior al pedido | 0 |
| Ventas ≤ 0 | 0 |
| Descuento fuera de `[0, 1]` | 0 |
| ZIP distinto de 5 dígitos | 438 |

Los 438 ZIP de 4 dígitos están en Massachusetts (135), New Jersey (130), Connecticut (82), Rhode Island (56), New Hampshire (27) y Maine (8): el cero a la izquierda se perdió al tratar el código como número en el CSV de origen.

Criterios de tratamiento:

| Inconsistencia | Criterio |
|---|---|
| Cabecera leída como fila | Filtrar `row_id <> 'Row ID'` en la carga |
| ZIP de 4 dígitos | `LPAD(postal_code, 5, '0')` en la tabla analítica; no se descarta la fila |
| Espacios no separables (`U+00A0`) en nombres | Reemplazo a espacio en el CSV UTF-8 |
| Ganancia negativa (1.871 líneas) | No es un error de calidad; se conserva para las preguntas de rentabilidad |
| Descuentos altos (hasta 0.80) | Válidos en dominio; se analizan en la pregunta 6 |

No eliminé registros: no hay duplicados de `row_id`, ni fechas rotas, ni ventas nulas o negativas.

## Interpretación

El archivo está completo a nivel de nulos y de claves. El único defecto estructural es el ZIP recortado en los estados de Nueva Inglaterra, típico de un Excel que guardó el código postal como número. La ganancia negativa no se trata como suciedad: es señal de negocio y entra en RFM, ranking y descuentos.

## Conclusión

El dataset es usable para analítica con 9.994 líneas íntegras. El tratamiento se limita a normalizar ZIP y texto; no hay depuración por borrado.
