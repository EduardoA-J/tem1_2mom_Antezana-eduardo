# Pregunta 6. Análisis del impacto de los descuentos

**Enunciado.** Clasificar en sin descuento (0), bajo (0–20 %], medio (20–50 %] y alto (>50 %). Calcular ventas, ganancia, margen, registros con pérdida, porcentaje no rentable, descuento promedio y categorías más afectadas. ¿Los descuentos elevados se asocian a más operaciones no rentables?

## Estrategia

Clasifiqué cada línea con un `CASE` sobre `discount`. En Hive el campo es fracción (0,20 = 20 %), no porcentaje. “No rentable” lo definí como `profit < 0`. Después agregué por rango y, en una segunda consulta, por categoría y subcategoría pero solo en descuento alto, para ver dónde pega más.

## Consulta HiveQL

[`sql/07_p06_descuentos.sql`](../sql/07_p06_descuentos.sql)

## Evidencia de ejecución

Capturas en [`evidencias/pregunta_06/`](../evidencias/pregunta_06/).

## Resultado

| Rango | Registros | Ventas | Ganancia | Margen % | Pérdidas | % no rentables | Desc. promedio |
|---|---:|---:|---:|---:|---:|---:|---:|
| Sin descuento | 4.798 | 1.087.908 | 320.988 | 29,51 | 0 | 0,00 | 0,00 |
| Descuento bajo (≤20 %) | 3.803 | 846.522 | 100.785 | 11,91 | 523 | 13,75 | 19,68 |
| Descuento medio (20–50 %] | 537 | 298.541 | −58.817 | −19,70 | 492 | 91,62 | 36,70 |
| Descuento alto (>50 %) | 856 | 64.229 | −76.559 | −119,20 | 856 | 100,00 | 71,89 |

Subcategorías más afectadas en descuento alto:

| Categoría | Subcategoría | Registros | % no rentables | Ganancia |
|---|---|---:|---:|---:|
| Office Supplies | Binders | 613 | 100 | −38.511 |
| Furniture | Furnishings | 138 | 100 | −5.945 |
| Office Supplies | Appliances | 67 | 100 | −8.630 |
| Technology | Machines | 23 | 100 | −19.579 |
| Furniture | Bookcases | 15 | 100 | −3.895 |

## Interpretación

Sí, se asocian, y se ve bastante claro. Sin descuento no hay una sola línea en pérdida. En descuento bajo todavía hay margen positivo (11,91 %), aunque ya aparece un 13,75 % de no rentables. En el rango medio el 91,62 % pierde. En descuento alto las 856 líneas pierden: 100 %. El margen de ese grupo es −119 %, o sea se pierde más de lo que se factura.

Binders concentran la cantidad (613 líneas). Machines son pocas (23) pero se llevan casi 19.580 de pérdida; son equipos caros. El 20 % parece el corte: por debajo el agregado sigue siendo negocio, por encima no.

Eso no prueba que el descuento “cause” la pérdida. Puede que se esté liquidando stock que ya venía mal. Igual, en este dataset, pasar del 20 % coincide con dejar de ganar.

## Conclusión

Los descuentos altos van de la mano de muchas más operaciones no rentables. Con estos números, un descuento por encima del 20 % deja de ser promocional y pasa a destruir margen.
