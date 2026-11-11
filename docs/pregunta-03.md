# Pregunta 3. Análisis de evolución comercial por región

**Enunciado.** Ventas y ganancia por región y año, margen, variación porcentual respecto al año anterior, y región con mejor y peor desempeño. Resolver con CTE y funciones de ventana.

## Estrategia

Agrupé por `region` y `YEAR(order_date)` en una CTE. Sobre esa serie anual apliqué `LAG(...) OVER (PARTITION BY region ORDER BY anio)` para la variación. El margen es `ganancia / ventas`. El mejor y peor desempeño los definí por **ganancia total del periodo 2014-2017**, no por ventas: vender más con margen bajo no es mejor desempeño comercial.

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

West lidera en ventas, ganancia y margen, y además acelera en 2016-2017 (+34 % y +33 % de ventas). East crece todos los años y cierra 2017 con el segundo mejor margen (15,6 %). South es la región más chica: en 2015 cae un 31 % y en 2017 el margen se hunde al 7,2 % pese a recuperar volumen. Central vende más que South (501 mil vs 392 mil) pero gana menos: el margen de 2014 es casi nulo (0,52 %) y en 2017 vuelve a deteriorarse (5,13 %). Por eso Central es el peor desempeño, no South.

## Conclusión

La región con mejor desempeño comercial es **West**; la peor es **Central**. El crecimiento de ventas no equivale a rentabilidad: Central lo demuestra al superar a South en facturación y quedar última en ganancia.
