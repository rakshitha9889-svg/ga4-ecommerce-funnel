-- 02_funnel_dropoff.sql
-- Overall funnel, conversion rate, AOV and step-to-step drop-off.

-- Overall funnel and KPIs
SELECT
  COUNT(*)                   AS sessions,
  COUNTIF(viewed_item)       AS view_item,
  COUNTIF(added_to_cart)     AS add_to_cart,
  COUNTIF(began_checkout)    AS begin_checkout,
  COUNTIF(added_payment)     AS add_payment_info,
  COUNTIF(purchased)         AS purchase,
  ROUND(100 * COUNTIF(purchased) / COUNT(*), 2)            AS conversion_rate_pct,
  ROUND(SUM(revenue) / NULLIF(COUNTIF(purchased), 0), 2)   AS avg_order_value
FROM `YOUR_PROJECT.ga4_analysis.sessions`;

-- Step-to-step drop-off (%)
WITH f AS (
  SELECT COUNT(*) s, COUNTIF(viewed_item) v, COUNTIF(added_to_cart) c,
         COUNTIF(began_checkout) b, COUNTIF(added_payment) p, COUNTIF(purchased) o
  FROM `YOUR_PROJECT.ga4_analysis.sessions`
)
SELECT
  ROUND(100 * (1 - v / s), 1) AS drop_session_to_view,
  ROUND(100 * (1 - c / v), 1) AS drop_view_to_cart,
  ROUND(100 * (1 - b / c), 1) AS drop_cart_to_checkout,
  ROUND(100 * (1 - p / b), 1) AS drop_checkout_to_payment,
  ROUND(100 * (1 - o / p), 1) AS drop_payment_to_purchase
FROM f;
