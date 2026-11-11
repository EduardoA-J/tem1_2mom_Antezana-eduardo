# Pregunta 2. Auditoría de calidad e integridad de datos

**Enunciado.** Analizar calidad: total de registros, Row ID duplicados, órdenes y clientes únicos, nulos, fechas inválidas, ventas ≤ 0, descuentos fuera de rango y envíos anteriores al pedido. Entregar un resumen y criterios de tratamiento.

## Estrategia

El resumen de nulos, fechas, ventas y descuentos lo corrí sobre `superstore`, que ya tiene tipos. El ZIP de 4 dígitos lo miré en `stg_superstore`, porque en la analítica ya lo relleno con `LPAD` y si auditara solo ahí no lo vería. El descuento lo tomé válido en `[0, 1]`, que es el rango de una fracción.

El resumen va en una consulta; los nulos por campo y el detalle del ZIP, en otras dos.

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

Los 438 ZIP cortados caen en Massachusetts (135), New Jersey (130), Connecticut (82), Rhode Island (56), New Hampshire (27) y Maine (8). Es el típico caso del código postal de Nueva Inglaterra cuando Excel lo trata como número y se come el cero de la izquierda (6824 en vez de 06824).

Cómo lo traté:

| Inconsistencia | Qué hice |
|---|---|
| Cabecera leída como fila | En la carga filtro `row_id <> 'Row ID'` |
| ZIP de 4 dígitos | `LPAD(postal_code, 5, '0')`; no borro la línea |
| Espacios duros (`U+00A0`) en nombres | Los pasé a espacio al armar el CSV UTF-8 |
| Ganancia negativa (1.871 líneas) | No es suciedad del archivo; las dejo para rentabilidad |
| Descuentos altos (hasta 0,80) | Están dentro de `[0, 1]`; los analizo en la pregunta 6 |

No borré filas. No había `row_id` repetido, ni fechas al revés, ni ventas menores o iguales a cero.

## Interpretación

El archivo está bastante limpio: no faltan campos y las claves cierran. Lo único estructural que encontré es el ZIP recortado. Las ganancias en negativo no las marqué como error; si las sacara, el ranking y el análisis de descuentos quedarían maquillados. Lo mismo con los descuentos altos: el dominio los admite, otra cosa es que sean buena política, y eso va en la pregunta 6.

## Conclusión

Puedo trabajar las 9.994 líneas sin depurar por borrado. El tratamiento se reduce a normalizar ZIP y texto; el resto de “problemas” son de negocio, no de integridad.
