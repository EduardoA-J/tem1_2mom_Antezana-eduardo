# Pregunta 8. Análisis Pareto de ventas y rentabilidad

**Enunciado.** Dos análisis 80/20 independientes: cuántos productos representan el 80 % de las ventas acumuladas y cuántos el 80 % de las ganancias. Ordenar, calcular participación individual y comparar.

## Estrategia

Por `product_id` sumé ventas y ganancia, ordené de mayor a menor y calculé el porcentaje individual y el acumulado con `SUM(...) OVER (ORDER BY ... ROWS UNBOUNDED PRECEDING)`. El corte del 80 % es el primer producto en el que el acumulado llega a 80.

En ganancias me quedé con los que tienen utilidad positiva (1.557 de 1.862). Si metía también los que pierden, el 80 % de la utilidad neta se alcanzaría más rápido, pero estaría mezclando dos cosas distintas: concentración de lo que sí gana y productos que restan. El enunciado pide dos análisis independientes, así que las ventas van por un lado y la ganancia positiva por otro.

## Consulta HiveQL

[`sql/09_p08_pareto.sql`](../sql/09_p08_pareto.sql)

## Evidencia de ejecución

Capturas en [`evidencias/pregunta_08/`](../evidencias/pregunta_08/).

## Resultado

| Análisis | Productos para llegar al 80 % | Sobre el catálogo | Lectura |
|---|---:|---:|---|
| Ventas | 414 | 22,23 % (414 / 1.862) | Cerca del 80/20, un poco más disperso |
| Ganancia positiva | 340 | 18,26 % (340 / 1.862) | Más concentrada que las ventas |

Cabeza de ventas: Canon imageCLASS 2200 (2,68 % de las ventas), Fellowes PB500, Cisco TelePresence, HON 5400 y GBC DocuBind TL300.

Cabeza de ganancia: otra vez la Canon (~6 % de la utilidad positiva), Fellowes PB500, HP LaserJet 3310, Canon PC1060 y Plantronics Savi W720.

## Interpretación

No es un 80/20 de manual: no son exactamente el 20 % de los productos, pero se parece. Para el 80 % de las ventas hace falta el 22 % del catálogo; para el 80 % de la ganancia positiva, el 18 %. La ganancia está más concentrada.

La diferencia se entiende con los que venden mucho y aportan poco o restan. El Cisco TelePresence y las HON 5400 entran en el Pareto de ventas y no en el de ganancia; las Cubify ni siquiera están en la cabeza de ventas y en utilidad son de las peores (pregunta 5). Si yo recortara catálogo mirando solo quién factura, dejaría afuera justo los que más contribuyen a la utilidad y me quedaría con volumen flaco.

La cola es larga: más de tres cuartos de los productos cubren apenas el 20 % que queda.

## Conclusión

Un grupo chico de productos sostiene la mayor parte de las ventas y, todavía más, de la ganancia. Las dos curvas no coinciden, así que un recorte de surtido yo lo haría sobre el Pareto de ganancia, no sobre el de ventas.
