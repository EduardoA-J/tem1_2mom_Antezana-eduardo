# Pregunta 4. Segmentación avanzada de clientes mediante RFM

**Enunciado.** Recency (días desde la última compra respecto a la fecha máxima), Frequency (órdenes únicas), Monetary (ventas acumuladas), puntuaciones RFM e identificación de alto valor, recurrentes y en riesgo. Justificar los criterios.

## Estrategia

Como fecha de referencia usé `MAX(order_date)` = 2017-12-30, que es el último día del dataset, no “hoy”. Si anclara en la fecha de ejecución, todos los recency se inflarían igual y no cambiaría el orden, pero el enunciado pide esa fecha máxima.

Por cliente:
- Recency: `DATEDIFF` entre esa fecha y la última orden.
- Frequency: `COUNT(DISTINCT order_id)`, no líneas, porque una orden puede traer varios productos.
- Monetary: `SUM(sales)`.

Los puntajes 1 a 5 salen de `NTILE(5)`. En recency ordené descendente para que el quintil más reciente reciba 5. En frequency y monetary ordené ascendente, así el quintil más alto recibe 5.

No usé el código RFM concatenado tipo 555. Preferí reglas que se puedan explicar:

| Segmento | Regla | Por qué lo armé así |
|---|---|---|
| Alto valor | R≥4, F≥4, M≥4 | Compran hace poco, varias veces y con ticket alto |
| Recurrente | F≥4, M≥3, R≥3, y no es alto valor | Vuelven seguido, aunque no estén en el tope de las tres notas |
| En riesgo | R≤2 y F≥3 | Ya habían comprado bastante y llevan rato sin aparecer |
| Perdido / inactivo | R≤2 y F≤2 | Poca historia y última compra lejos |
| Promedio | el resto | Ni concentran valor ni son el foco de reactivación |

## Consulta HiveQL

[`sql/05_p04_rfm.sql`](../sql/05_p04_rfm.sql)

## Evidencia de ejecución

Capturas en [`evidencias/pregunta_04/`](../evidencias/pregunta_04/).

## Resultado

Hay 793 clientes. El recency va de 0 a 1.165 días y la frequency de 1 a 17 órdenes.

| Segmento | Clientes | Recency promedio (días) | Frequency promedio | Ventas del segmento | Monetary promedio |
|---|---:|---:|---:|---:|---:|
| Promedio | 282 | 43,4 | 5,42 | 666.539 | 2.364 |
| Alto valor | 97 | 23,6 | 9,46 | 517.795 | 5.338 |
| En riesgo | 142 | 215,2 | 7,56 | 486.362 | 3.425 |
| Recurrente | 96 | 56,0 | 8,63 | 326.658 | 3.403 |
| Perdido / inactivo | 176 | 374,6 | 3,75 | 299.847 | 1.704 |

En alto valor aparecen, entre otros, Adrian Barton, Ken Lonsdale, Sanjit Engle, Greg Tran y Maria Etezadi: R y F en 4-5 y monetary por encima de 10.000.

## Interpretación

Lo que más me llamó la atención es cómo se parte la cartera. Los 97 de alto valor son el 12 % de los clientes y mueven 517.795, con un monetary promedio de 5.338. Los 176 inactivos se quedan en 1.704. En riesgo hay 142 personas que en su momento compraban (frequency 7,56) y ahora llevan, en promedio, 215 días sin pedido: ahí sí tiene sentido intentar recuperarlos. Juntando riesgo e inactivos son 318 clientes, casi cuatro de cada diez.

RFM sirve justo para no tratar igual a alguien de una sola orden vieja y a alguien que compró diez veces cerca de 2017-12-30.

## Conclusión

Yo priorizaría tres cosas: no descuidar a los 97 de alto valor, intentar reactivar a los 142 en riesgo (ya conocen el canal) y no gastar el mismo esfuerzo en los 176 inactivos de baja frequency.
