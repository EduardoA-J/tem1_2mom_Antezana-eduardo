# Conclusiones generales

El Superstore de 9.994 líneas cabe en un modelo Hive de dos capas (landing CSV y tabla ORC). La calidad es alta: no hay nulos, ni duplicados de `row_id`, ni fechas invertidas. El único arreglo estructural es el ZIP de Nueva Inglaterra.

West es la región más sólida; Central factura más que South y gana menos. El RFM separa unos 97 clientes de alto valor de 144 en riesgo y 174 inactivos. El ranking de productos muestra que el volumen no es ganancia: la copiadora Canon encabeza ambos rankings, pero el Cisco TelePresence vende y pierde. Los descuentos por encima del 20 % están ligados a pérdidas casi sistemáticas. La serie mensual confirma estacionalidad de fin de año, con el pico en noviembre 2017. El Pareto no es 80/20 exacto, pero el 22 % de los productos hace el 80 % de las ventas y un 18 % hace el 80 % de la utilidad positiva.

HiveQL cubrió el examen con CTE, `LAG`, `NTILE`, `RANK`, `DENSE_RANK` y sumas acumuladas. El repositorio documenta cada pregunta con consulta, evidencia, resultado e interpretación, y el historial de commits refleja el orden de construcción (modelo, carga, consultas, documentación y capturas).
