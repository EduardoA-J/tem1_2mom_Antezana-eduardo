# Pregunta 5. Ranking de productos según rentabilidad

**Enunciado.** Cinco productos con mayor ganancia por categoría, cinco con mayor volumen de ventas, cinco con menor rentabilidad, margen individual y posición dentro de la categoría. Usar `RANK()`, `DENSE_RANK()` y agregaciones acumulativas.

## Estrategia

Agrupé por `category` y `product_id`. El margen individual es `SUM(profit)/SUM(sales)`. `RANK()` y `DENSE_RANK()` van particionados por categoría para la ganancia y, en la consulta de volumen, a nivel global. La ganancia acumulada de la categoría es `SUM(ganancia) OVER (PARTITION BY category ORDER BY ganancia DESC ROWS UNBOUNDED PRECEDING)`. “Menor rentabilidad” la medí por ganancia acumulada más negativa: un margen feo en un producto de 20 dólares no pesa igual que perder 8.800 en una impresora 3D.

## Consulta HiveQL

[`sql/06_p05_ranking_productos.sql`](../sql/06_p05_ranking_productos.sql)

## Evidencia de ejecución

Capturas en [`evidencias/pregunta_05/`](../evidencias/pregunta_05/).

## Resultado

**Top 5 por ganancia dentro de cada categoría** (resumen):

| Categoría | Producto | Ganancia | Ventas | Margen % |
|---|---|---:|---:|---:|
| Technology | Canon imageCLASS 2200 Advanced Copier | 25.199,93 | 61.599,82 | 40,91 |
| Technology | Hewlett Packard LaserJet 3310 Copier | 6.983,88 | 18.839,69 | 37,07 |
| Technology | Canon PC1060 Personal Laser Copier | 4.570,93 | 11.619,83 | 39,34 |
| Office Supplies | Fellowes PB500 Electric Punch | 7.753,04 | 27.453,38 | 28,24 |
| Office Supplies | Ibico EPK-21 Electric Binding System | 3.345,28 | 15.875,92 | 21,07 |
| Furniture | Hon Deluxe Fabric Upholstered Stacking Chairs | 1.927,44 | 10.637,53 | 18,12 |
| Furniture | Global Deluxe High-Back Manager's Chair | 1.558,59 | 8.665,19 | 17,99 |

**Top 5 por ventas:**

| Rank | Producto | Ventas | Ganancia | Margen % |
|---|---|---:|---:|---:|
| 1 | Canon imageCLASS 2200 Advanced Copier | 61.599,82 | 25.199,93 | 40,91 |
| 2 | Fellowes PB500 Electric Punch | 27.453,38 | 7.753,04 | 28,24 |
| 3 | Cisco TelePresence System EX90 | 22.638,48 | −1.811,08 | −8,00 |
| 4 | HON 5400 Series Task Chairs | 21.870,58 | 0,00 | 0,00 |
| 5 | GBC DocuBind TL300 | 19.823,48 | 2.233,51 | 11,27 |

**Peor ganancia acumulada:**

| Producto | Ventas | Ganancia | Margen % |
|---|---:|---:|---:|
| Cubify CubeX 3D Printer Double Head | 11.099,96 | −8.879,97 | −80,00 |
| Lexmark MX611dhe Monochrome Laser | 16.829,90 | −4.589,97 | −27,27 |
| Cubify CubeX 3D Printer Triple Head | 7.999,98 | −3.839,99 | −48,00 |
| Chromcraft Bull-Nose Wood Oval Conference Table | 9.917,64 | −2.876,12 | −29,00 |
| Bush Advantage Collection Conference Table | 9.544,73 | −1.934,40 | −20,27 |

## Interpretación

El ranking por ventas y el ranking por ganancia no coinciden. El Cisco TelePresence es el tercer producto en facturación y pierde dinero; las sillas HON 5400 venden 21.871 y dejan margen cero. En Furniture el techo de ganancia es bajo (el primero apenas llega a 1.927) comparado con una sola copiadora Canon. `RANK` y `DENSE_RANK` salen iguales en estos top 5 porque no hay empates de ganancia.

## Conclusión

La rentabilidad se concentra en copiadoras e insumos de encuadernación. El volumen no garantiza utilidad: hay que mirar el margen por producto, no solo el ranking de ventas.
