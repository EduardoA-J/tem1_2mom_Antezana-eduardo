# Conclusiones generales

Armé el Superstore en Hive con dos capas (CSV de aterrizaje y tabla ORC) y las 9.994 líneas cargaron sin huecos de integridad: no hay nulos, ni `row_id` duplicado, ni fechas al revés. Lo único que tuve que acomodar de verdad fue el ZIP de Nueva Inglaterra.

En lo comercial, West es la región más sólida. Central factura más que South y aun así gana menos, así que el ranking no se puede hacer solo con ventas. El RFM deja 97 clientes de alto valor, 142 en riesgo y 176 inactivos; no son el mismo tipo de cuenta. En productos pasa algo parecido: la copiadora Canon lidera ventas y ganancia, pero el Cisco TelePresence vende y pierde. Los descuentos por encima del 20 % coinciden con pérdidas casi sistemáticas. La serie mensual tiene el pico en noviembre 2017 y febrero siempre sale flojo. El Pareto no es 80/20 exacto, pero el 22 % de los productos hace el 80 % de las ventas y el 18 % hace el 80 % de la utilidad positiva.

Para resolverlo usé CTE, `LAG`, `NTILE`, `RANK`, `DENSE_RANK` y sumas acumuladas, que es lo que pedía cada bloque. Cada pregunta quedó con consulta, captura, números e interpretación, y el historial de commits sigue el orden en que lo fui armando: modelo, carga, consultas, texto y evidencias.
