-- 03_device_channel.sql
-- Conversion breakdown by device and by first-user acquisition channel.

-- By device
SELECT
  device,
  COUNT(*) AS sessions,
  ROUND(100 * COUNTIF(added_to_cart) / COUNT(*), 2) AS cart_rate_pct,
  ROUND(100 * COUNTIF(purchased) / COUNT(*), 2)     AS conversion_rate_pct,
  ROUND(100 * COUNTIF(purchased) / NULLIF(COUNTIF(began_checkout), 0), 1) AS checkout_completion_pct,
  ROUND(SUM(revenue) / NULLIF(COUNTIF(purchased), 0), 2) AS avg_order_value
FROM `YOUR_PROJECT.ga4_analysis.sessions`
GROUP BY device
ORDER BY sessions DESC;

-- By first-user channel (medium)
SELECT
  first_user_medium,
  COUNT(*) AS sessions,
  ROUND(100 * COUNTIF(purchased) / COUNT(*), 2) AS conversion_rate_pct,
  ROUND(SUM(revenue) / NULLIF(COUNTIF(purchased), 0), 2) AS avg_order_value
FROM `YOUR_PROJECT.ga4_analysis.sessions`
GROUP BY first_user_medium
ORDER BY sessions DESC;
