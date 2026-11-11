# Pregunta 7. Análisis de tendencias temporales

**Enunciado.** Evolución mensual de ventas y ganancias, variación respecto al mes anterior, comparación con el mismo mes del año anterior, promedio móvil de tres meses y los tres meses de mayor y menor volumen. Usar `LAG()`, ventanas y agregaciones temporales.

## Estrategia

Agrupé por año y mes: 48 puntos, de enero 2014 a diciembre 2017. `LAG(ventas, 1)` compara con el mes anterior. `LAG(ventas, 12)` compara con el mismo mes del año pasado, que es lo que pide el enunciado y evita confundir un noviembre fuerte con “crecimiento”. El promedio móvil de tres meses es `AVG(ventas) OVER (ORDER BY anio, mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)`. Los tres mayores y los tres menores salen con `RANK()` sobre las ventas del mes.

## Consulta HiveQL

[`sql/08_p07_tendencias.sql`](../sql/08_p07_tendencias.sql)

## Evidencia de ejecución

Capturas en [`evidencias/pregunta_07/`](../evidencias/pregunta_07/).

## Resultado

Serie de 48 meses. Extracto de noviembre-diciembre y de enero, que es donde se ve la estacionalidad:

| Mes | Ventas | Var. mes anterior % | Var. interanual % |
|---|---:|---:|---:|
| 2014-11 | 78.629 | +149,98 | — |
| 2014-12 | 69.546 | −11,55 | — |
| 2015-11 | 75.973 | +141,91 | −3,38 |
| 2015-12 | 74.920 | −1,39 | +7,73 |
| 2016-11 | 79.412 | +33,05 | +4,53 |
| 2016-12 | 97.000 | +22,15 | +29,47 |
| 2017-11 | 118.448 | +52,29 | +49,16 |
| 2017-12 | 83.829 | −29,23 | −13,58 |

Tres meses de mayor volumen: **2017-11** (118.448), **2016-12** (96.999) y **2017-09** (87.867).  
Tres de menor volumen: **2014-02** (4.520), **2015-02** (11.951) y **2014-01** (14.237).

El promedio móvil de tres meses amortigua el salto a noviembre y la caída de enero, que si uno mira solo el mes a mes parecen quiebres más bruscos de lo que son.

## Interpretación

Hay un patrón que se repite: el año arranca flojo (sobre todo febrero) y se dispara en septiembre-noviembre. 2017-11 es el máximo de toda la serie y sube 49 % respecto a 2016-11. En cambio 2017-12 cae 14 % contra 2016-12; el pico se corrió a noviembre. Si yo comparara noviembre solo con octubre, vería +52 % y pensaría que “explotó el negocio”; el `LAG` a 12 meses muestra que parte de eso es estacionalidad.

## Conclusión

Las ventas suben entre 2014 y 2017, pero el calendario pesa: inicios de año débiles y picos en el último tramo. Para armar una meta mensual tiene más sentido mirar el mismo mes del año anterior que el mes inmediato.
