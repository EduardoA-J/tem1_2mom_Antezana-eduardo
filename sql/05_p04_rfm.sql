-- Pregunta 4. Segmentacion RFM de clientes
-- Recency: dias desde la ultima compra respecto a MAX(order_date)
-- Frequency: ordenes unicas
-- Monetary: ventas acumuladas
-- Puntuacion 1-5 con NTILE; 5 es mejor (R reciente, F y M altos)
USE db_eduardoantezana;

WITH rfm_base AS (
  SELECT
    customer_id,
    MAX(customer_name) AS customer_name,
    DATEDIFF((SELECT MAX(order_date) FROM superstore), MAX(order_date)) AS recency,
    COUNT(DISTINCT order_id) AS frequency,
    SUM(sales) AS monetary
  FROM superstore
  GROUP BY customer_id
),
rfm_score AS (
  SELECT
    customer_id,
    customer_name,
    recency,
    frequency,
    monetary,
    NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
    NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
  FROM rfm_base
),
rfm_seg AS (
  SELECT
    customer_id,
    customer_name,
    recency,
    frequency,
    ROUND(monetary, 2) AS monetary,
    r_score,
    f_score,
    m_score,
    CONCAT(CAST(r_score AS STRING), CAST(f_score AS STRING), CAST(m_score AS STRING)) AS rfm,
    CASE
      WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Alto valor'
      WHEN f_score >= 4 AND m_score >= 3 AND r_score >= 3 THEN 'Recurrente'
      WHEN r_score <= 2 AND f_score >= 3 THEN 'En riesgo'
      WHEN r_score <= 2 AND f_score <= 2 THEN 'Perdido / inactivo'
      ELSE 'Promedio'
    END AS segmento
  FROM rfm_score
)
SELECT
  segmento,
  COUNT(*) AS clientes,
  ROUND(AVG(recency), 1) AS recency_promedio,
  ROUND(AVG(frequency), 2) AS frequency_promedio,
  ROUND(SUM(monetary), 2) AS ventas_segmento,
  ROUND(AVG(monetary), 2) AS monetary_promedio
FROM rfm_seg
GROUP BY segmento
ORDER BY ventas_segmento DESC;

-- Muestra de clientes de alto valor
WITH rfm_base AS (
  SELECT
    customer_id,
    MAX(customer_name) AS customer_name,
    DATEDIFF((SELECT MAX(order_date) FROM superstore), MAX(order_date)) AS recency,
    COUNT(DISTINCT order_id) AS frequency,
    SUM(sales) AS monetary
  FROM superstore
  GROUP BY customer_id
),
rfm_score AS (
  SELECT
    customer_id,
    customer_name,
    recency,
    frequency,
    monetary,
    NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
    NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
  FROM rfm_base
),
rfm_seg AS (
  SELECT
    customer_id,
    customer_name,
    recency,
    frequency,
    ROUND(monetary, 2) AS monetary,
    r_score,
    f_score,
    m_score,
    CASE
      WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Alto valor'
      WHEN f_score >= 4 AND m_score >= 3 AND r_score >= 3 THEN 'Recurrente'
      WHEN r_score <= 2 AND f_score >= 3 THEN 'En riesgo'
      WHEN r_score <= 2 AND f_score <= 2 THEN 'Perdido / inactivo'
      ELSE 'Promedio'
    END AS segmento
  FROM rfm_score
)
SELECT customer_id, customer_name, recency, frequency, monetary, r_score, f_score, m_score, segmento
FROM rfm_seg
WHERE segmento = 'Alto valor'
ORDER BY monetary DESC
LIMIT 10;

-- Muestra de clientes en riesgo de abandono
WITH rfm_base AS (
  SELECT
    customer_id,
    MAX(customer_name) AS customer_name,
    DATEDIFF((SELECT MAX(order_date) FROM superstore), MAX(order_date)) AS recency,
    COUNT(DISTINCT order_id) AS frequency,
    SUM(sales) AS monetary
  FROM superstore
  GROUP BY customer_id
),
rfm_score AS (
  SELECT
    customer_id,
    customer_name,
    recency,
    frequency,
    monetary,
    NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
    NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
  FROM rfm_base
),
rfm_seg AS (
  SELECT
    customer_id,
    customer_name,
    recency,
    frequency,
    ROUND(monetary, 2) AS monetary,
    r_score,
    f_score,
    m_score,
    CASE
      WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Alto valor'
      WHEN f_score >= 4 AND m_score >= 3 AND r_score >= 3 THEN 'Recurrente'
      WHEN r_score <= 2 AND f_score >= 3 THEN 'En riesgo'
      WHEN r_score <= 2 AND f_score <= 2 THEN 'Perdido / inactivo'
      ELSE 'Promedio'
    END AS segmento
  FROM rfm_score
)
SELECT customer_id, customer_name, recency, frequency, monetary, r_score, f_score, m_score, segmento
FROM rfm_seg
WHERE segmento = 'En riesgo'
ORDER BY monetary DESC
LIMIT 10;
