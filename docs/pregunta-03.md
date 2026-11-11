# Pregunta 3. Análisis de evolución comercial por región

**Enunciado.** Ventas y ganancia por región y año, margen, variación porcentual respecto al año anterior, y región con mejor y peor desempeño. Resolver con CTE y funciones de ventana.

## Estrategia

Armé una CTE agrupando por `region` y `YEAR(order_date)`. La variación la saqué con `LAG(...) OVER (PARTITION BY region ORDER BY anio)`, para comparar cada región consigo misma y no con las otras. El margen es `ganancia / ventas`.

Para el mejor y el peor desempeño usé la **ganancia total 2014-2017**, no las ventas. Si mirara solo facturación, Central parecería más sólida que South, y en utilidad es al revés.

## Consulta HiveQL

[`sql/04_p03_evolucion_region.sql`](../sql/04_p03_evolucion_region.sql)

## Evidencia de ejecución

Capturas en [`evidencias/pregunta_03/`](../evidencias/pregunta_03/).

## Resultado

Ventas, ganancia, margen y variación anual:

| Región | Año | Ventas | Ganancia | Margen % | Var. ventas % |
|---|---|---:|---:|---:|---:|
| Central | 2014 | 103.838 | 540 | 0,52 | — |
| Central | 2015 | 102.874 | 11.717 | 11,39 | −0,93 |
| Central | 2016 | 147.429 | 19.899 | 13,50 | +43,31 |
| Central | 2017 | 147.098 | 7.551 | 5,13 | −0,22 |
| East | 2014 | 128.680 | 17.060 | 13,26 | — |
| East | 2015 | 156.332 | 21.091 | 13,49 | +21,49 |
| East | 2016 | 180.686 | 20.142 | 11,15 | +15,58 |
| East | 2017 | 213.083 | 33.231 | 15,60 | +17,93 |
| South | 2014 | 103.846 | 11.879 | 11,44 | — |
| South | 2015 | 71.360 | 8.319 | 11,66 | −31,28 |
| South | 2016 | 93.610 | 17.703 | 18,91 | +31,18 |
| South | 2017 | 122.906 | 8.849 | 7,20 | +31,30 |
| West | 2014 | 147.883 | 20.066 | 13,57 | — |
| West | 2015 | 139.966 | 20.492 | 14,64 | −5,35 |
| West | 2016 | 187.480 | 24.052 | 12,83 | +33,95 |
| West | 2017 | 250.128 | 43.809 | 17,51 | +33,42 |

Totales 2014-2017:

| Región | Ventas | Ganancia | Margen % | Rank |
|---|---:|---:|---:|---:|
| West | 725.458 | 108.418 | 14,94 | 1 — mejor desempeño |
| East | 678.781 | 91.523 | 13,48 | 2 |
| South | 391.722 | 46.749 | 11,93 | 3 |
| Central | 501.240 | 39.706 | 7,92 | 4 — peor desempeño |

## Interpretación

West gana en los tres frentes: vende más, gana más y tiene mejor margen. Encima en 2016 y 2017 las ventas suben alrededor de 34 % y 33 %. East crece todos los años y cierra 2017 con 15,6 % de margen.

South es la más chica. En 2015 se cae un 31 % y en 2017, aunque recupera volumen, el margen se va a 7,2 %. Central es el caso raro: factura más que South (501 mil contra 392 mil) y aun así gana menos. En 2014 casi no deja utilidad (0,52 %) y en 2017 el margen vuelve a 5,13 %. Por eso puse a Central como peor desempeño y no a South.

## Conclusión

La mejor región es **West** y la peor **Central**. Vender más no alcanza: Central factura por encima de South y termina última en ganancia.
