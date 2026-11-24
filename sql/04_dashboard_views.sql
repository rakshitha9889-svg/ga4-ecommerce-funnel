-- 04_dashboard_views.sql
-- Views feeding the Looker Studio (Data Studio) dashboard.

CREATE OR REPLACE VIEW `YOUR_PROJECT.ga4_analysis.daily_kpis` AS
SELECT
  dt, device, first_user_medium,
  COUNT(*)                AS sessions,
  COUNTIF(added_to_cart)  AS carts,
  COUNTIF(began_checkout) AS checkouts,
  COUNTIF(purchased)      AS purchases,
  SUM(revenue)            AS revenue
FROM `YOUR_PROJECT.ga4_analysis.sessions`
GROUP BY 1, 2, 3;

CREATE OR REPLACE VIEW `YOUR_PROJECT.ga4_analysis.funnel_long` AS
SELECT device, 1 AS step_order, '1 Session' AS step, COUNT(*) AS sessions FROM `YOUR_PROJECT.ga4_analysis.sessions` GROUP BY device
UNION ALL SELECT device, 2, '2 View item',      COUNTIF(viewed_item)    FROM `YOUR_PROJECT.ga4_analysis.sessions` GROUP BY device
UNION ALL SELECT device, 3, '3 Add to cart',    COUNTIF(added_to_cart)  FROM `YOUR_PROJECT.ga4_analysis.sessions` GROUP BY device
UNION ALL SELECT device, 4, '4 Begin checkout', COUNTIF(began_checkout) FROM `YOUR_PROJECT.ga4_analysis.sessions` GROUP BY device
UNION ALL SELECT device, 5, '5 Payment info',   COUNTIF(added_payment)  FROM `YOUR_PROJECT.ga4_analysis.sessions` GROUP BY device
UNION ALL SELECT device, 6, '6 Purchase',       COUNTIF(purchased)      FROM `YOUR_PROJECT.ga4_analysis.sessions` GROUP BY device;
