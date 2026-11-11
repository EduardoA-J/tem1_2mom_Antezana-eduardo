# Pregunta 6. Análisis del impacto de los descuentos

**Enunciado.** Clasificar en sin descuento (0), bajo (0–20 %], medio (20–50 %] y alto (>50 %). Calcular ventas, ganancia, margen, registros con pérdida, porcentaje no rentable, descuento promedio y categorías más afectadas. ¿Los descuentos elevados se asocian a más operaciones no rentables?

## Estrategia

Un `CASE` sobre `discount` (fracción, no porcentaje). Agregué por rango y, en una segunda consulta, por categoría y subcategoría solo en descuento alto. “No rentable” = `profit < 0`.

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

Sí: a mayor descuento, mayor proporción de líneas en pérdida, y no es un matiz débil. Sin descuento no hay una sola pérdida. En descuento alto las 856 líneas pierden; el margen es −119 %, o sea se pierde más de lo que se factura. Binders concentran el volumen de esos descuentos; Machines concentra pérdida grande con pocas líneas (impresoras y equipos caros). El descuento bajo (sobre todo 20 %) todavía deja margen positivo agregado (11,9 %).

Correlación no es causa: puede que se descuente stock ya deficitario. Aun así, la política de descuentos por encima del 20 % coincide con destrucción de margen.

## Conclusión

Los descuentos elevados están asociados a una proporción mucho mayor de operaciones no rentables. El corte práctico está en 20 %: por encima, el negocio agregado de Superstore deja de ser rentable.
