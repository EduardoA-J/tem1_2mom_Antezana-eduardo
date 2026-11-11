# Pregunta 8. Análisis Pareto de ventas y rentabilidad

**Enunciado.** Dos análisis 80/20 independientes: cuántos productos representan el 80 % de las ventas acumuladas y cuántos el 80 % de las ganancias. Ordenar, calcular participación individual y comparar.

## Estrategia

Por `product_id` sumé ventas y ganancia. Ordené de mayor a menor y calculé el porcentaje individual y el acumulado con `SUM(...) OVER (ORDER BY ... ROWS UNBOUNDED PRECEDING)`. El corte 80 % es el primer producto cuyo acumulado alcanza 80.

En ganancias usé solo productos con utilidad positiva. Si mezclara las pérdidas, el 80 % de la utilidad neta se alcanzaría con menos ítems, pero mezclaría dos fenómenos distintos (concentración de utilidad vs productos que destruyen valor). El catálogo tiene 1.862 productos.

## Consulta HiveQL

[`sql/09_p08_pareto.sql`](../sql/09_p08_pareto.sql)

## Evidencia de ejecución

Capturas en [`evidencias/pregunta_08/`](../evidencias/pregunta_08/).

## Resultado

| Análisis | Productos para llegar al 80 % | Sobre el catálogo | Lectura |
|---|---:|---:|---|
| Ventas | 414 | 22,23 % (414 / 1.862) | Cerca de 80/20, un poco más disperso |
| Ganancia positiva | 340 | 18,26 % (340 / 1.862; 1.557 productos con ganancia > 0) | Más concentrada que las ventas |

Cabeza de ventas: Canon imageCLASS 2200 (2,68 % de las ventas), Fellowes PB500, Cisco TelePresence, HON 5400, GBC DocuBind TL300.

Cabeza de ganancia: la misma copiadora Canon (~6 % de la utilidad positiva), Fellowes PB500, HP LaserJet 3310, Canon PC1060, Plantronics Savi W720.

## Interpretación

Las ventas están menos concentradas que la ganancia: hace falta el 22 % del catálogo para el 80 % de la facturación y el 18 % para el 80 % de la utilidad positiva. La diferencia aparece en productos que venden mucho y aportan poco o restan (Cisco TelePresence, HON 5400, impresoras Cubify). El Pareto de ventas solo no sirve para decidir surtido: el de ganancia recorta justo esos ítems.

No es un 80/20 literal (no son el 20 % exacto de los productos), pero la cola larga existe: más de tres cuartas partes del catálogo cubren apenas el 20 % restante.

## Conclusión

Un conjunto reducido de productos sostiene la mayor parte de ventas y, aún más, de ganancia. La comparación de las dos curvas muestra que hay volumen sin rentabilidad; cualquier recorte de catálogo debería partir del Pareto de ganancia, no del de ventas.
