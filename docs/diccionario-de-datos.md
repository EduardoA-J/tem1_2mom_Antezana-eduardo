# Diccionario de datos — Sample Superstore

Fuente: archivo CSV de Kaggle *Superstore Dataset Final*, 21 columnas y 9.994 filas de detalle de pedido (Estados Unidos, 2014-2017). Cada fila es una línea de producto dentro de una orden.

La tabla analítica `db_eduardoantezana.superstore` usa estos nombres y tipos Hive. La tabla de aterrizaje `stg_superstore` guarda los mismos campos como `STRING` para no perder información en la ingesta.

| Campo origen (CSV) | Campo Hive | Tipo Hive | Descripción | Restricciones / observaciones |
|---|---|---|---|---|
| Row ID | `row_id` | `INT` | Identificador de la línea en el archivo | Único en el dataset; no nulo |
| Order ID | `order_id` | `STRING` | Identificador de la orden | Una orden tiene una o más líneas |
| Order Date | `order_date` | `DATE` | Fecha del pedido | Origen `M/d/yyyy`; no nula |
| Ship Date | `ship_date` | `DATE` | Fecha de envío | Debe ser ≥ `order_date` |
| Ship Mode | `ship_mode` | `STRING` | Modalidad de envío | `Standard Class`, `Second Class`, `First Class`, `Same Day` |
| Customer ID | `customer_id` | `STRING` | Identificador del cliente | Formato `XX-#####` |
| Customer Name | `customer_name` | `STRING` | Nombre del cliente | |
| Segment | `segment` | `STRING` | Segmento comercial | `Consumer`, `Corporate`, `Home Office` |
| Country | `country` | `STRING` | País | Solo `United States` |
| City | `city` | `STRING` | Ciudad | |
| State | `state` | `STRING` | Estado | |
| Postal Code | `postal_code` | `STRING` | Código postal ZIP | Cinco dígitos; en origen 438 valores vienen sin el cero a la izquierda |
| Region | `region` | `STRING` | Región de venta | `Central`, `East`, `South`, `West` |
| Product ID | `product_id` | `STRING` | Identificador del producto | Formato `XXX-XX-########` |
| Category | `category` | `STRING` | Categoría | `Furniture`, `Office Supplies`, `Technology` |
| Sub-Category | `sub_category` | `STRING` | Subcategoría | 17 valores |
| Product Name | `product_name` | `STRING` | Nombre comercial | Puede contener comas y comillas; se ingesta con OpenCSVSerde |
| Sales | `sales` | `DECIMAL(12,4)` | Importe de la línea | Esperado > 0 |
| Quantity | `quantity` | `INT` | Unidades vendidas | Entero ≥ 1 |
| Discount | `discount` | `DECIMAL(4,2)` | Descuento como fracción | Dominio esperado `[0, 1]` (0 % a 100 %) |
| Profit | `profit` | `DECIMAL(12,4)` | Ganancia de la línea | Puede ser negativa |

Granularidad: **línea de pedido**, no orden ni cliente. Las métricas de órdenes y clientes se obtienen con `COUNT(DISTINCT ...)`.
