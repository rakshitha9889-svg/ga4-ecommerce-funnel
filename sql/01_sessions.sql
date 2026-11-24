-- 01_sessions.sql
-- Rebuilds GA4 event-level data into one row per session.
-- GA4 exports one row per event; the session ID is nested inside event_params,
-- so it is extracted with UNNEST and combined with user_pseudo_id into a session key.
-- Replace YOUR_PROJECT with your Google Cloud project ID.

CREATE OR REPLACE TABLE `YOUR_PROJECT.ga4_analysis.sessions` AS
WITH ev AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
    event_name,
    device.category                   AS device,
    traffic_source.medium             AS first_user_medium,  -- first-touch, user level
    PARSE_DATE('%Y%m%d', event_date)  AS dt,
    ecommerce.purchase_revenue        AS revenue
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
)
SELECT
  CONCAT(user_pseudo_id, '-', CAST(session_id AS STRING)) AS session_key,
  MIN(dt)                       AS dt,
  ANY_VALUE(device)             AS device,
  ANY_VALUE(first_user_medium)  AS first_user_medium,
  COUNTIF(event_name = 'view_item')         > 0 AS viewed_item,
  COUNTIF(event_name = 'add_to_cart')       > 0 AS added_to_cart,
  COUNTIF(event_name = 'begin_checkout')    > 0 AS began_checkout,
  COUNTIF(event_name = 'add_shipping_info') > 0 AS added_shipping,
  COUNTIF(event_name = 'add_payment_info')  > 0 AS added_payment,
  COUNTIF(event_name = 'purchase')          > 0 AS purchased,
  IFNULL(SUM(revenue), 0)       AS revenue
FROM ev
WHERE session_id IS NOT NULL
GROUP BY session_key;
