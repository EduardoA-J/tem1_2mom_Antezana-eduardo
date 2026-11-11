# Pregunta 4. Segmentación avanzada de clientes mediante RFM

**Enunciado.** Recency (días desde la última compra respecto a la fecha máxima), Frequency (órdenes únicas), Monetary (ventas acumuladas), puntuaciones RFM e identificación de alto valor, recurrentes y en riesgo. Justificar los criterios.

## Estrategia

Fecha de referencia: `MAX(order_date)` = 2017-12-30. Por cliente calculé recency con `DATEDIFF`, frequency con `COUNT(DISTINCT order_id)` y monetary con `SUM(sales)`. Las puntuaciones 1 a 5 salen de `NTILE(5)`:

- **R**: `ORDER BY recency DESC` → el quintil más reciente recibe 5.
- **F** y **M**: `ORDER BY frequency/monetary ASC` → el quintil más alto recibe 5.

Criterios de segmento (justificación: combinar recencia con intensidad de compra, sin usar un score RFM concatenado rígido tipo 555):

| Segmento | Regla | Por qué |
|---|---|---|
| Alto valor | R≥4, F≥4, M≥4 | Compran hace poco, muchas órdenes e importe alto: prioridad de retención |
| Recurrente | F≥4, M≥3 y R≥3, y no es alto valor | Frecuencia alta y ticket relevante, recencia aceptable |
| En riesgo | R≤2 y F≥3 | Ya fueron activos y llevan mucho sin comprar |
| Perdido / inactivo | R≤2 y F≤2 | Poca historia y última compra lejana |
| Promedio | resto | No concentran ni el riesgo ni el valor |

## Consulta HiveQL

[`sql/05_p04_rfm.sql`](../sql/05_p04_rfm.sql)

## Evidencia de ejecución

Capturas en [`evidencias/pregunta_04/`](../evidencias/pregunta_04/).

## Resultado

793 clientes. Recency entre 0 y 1.165 días; frequency entre 1 y 17 órdenes.

| Segmento | Clientes | Recency promedio (días) | Frequency promedio | Ventas del segmento | Monetary promedio |
|---|---:|---:|---:|---:|---:|
| Promedio | 282 | 43,4 | 5,42 | 666.539 | 2.364 |
| Alto valor | 97 | 23,6 | 9,46 | 517.795 | 5.338 |
| En riesgo | 142 | 215,2 | 7,56 | 486.362 | 3.425 |
| Recurrente | 96 | 56,0 | 8,63 | 326.658 | 3.403 |
| Perdido / inactivo | 176 | 374,6 | 3,75 | 299.847 | 1.704 |

Ejemplos de alto valor (muestra): Adrian Barton, Ken Lonsdale, Sanjit Engle, Greg Tran, Maria Etezadi — R y F en 4-5 con monetary por encima de 10.000.

## Interpretación

Casi cuatro de cada diez clientes están en riesgo o perdidos (142 + 176). El valor no está repartido: 97 clientes de alto valor (12 % de la cartera) concentran 517.795 de ventas, un monetary promedio de 5.338 frente a 1.704 de los inactivos. RFM aquí sirve para no tratar igual a un cliente de una sola orden antigua y a uno que compró 10 veces en 2017. La recency ancla en el último día del dataset, no en “hoy”, así que es comparable entre clientes.

## Conclusión

La cartera se puede operar con tres palancas: cuidar los 97 de alto valor, reactivar los 142 en riesgo (ya conocen el canal) y no invertir igual en los 176 inactivos de baja frecuencia.
