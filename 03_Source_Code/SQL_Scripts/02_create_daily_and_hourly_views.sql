-- ShopMetrics: daily and hourly event activity views.

CREATE OR REPLACE VIEW public.vw_daily_trends AS
SELECT
    TO_TIMESTAMP("timestamp" / 1000.0)::date AS event_date,
    COUNT(*) AS total_events,
    COUNT(*) FILTER (WHERE event = 'view') AS total_views,
    COUNT(*) FILTER (WHERE event = 'addtocart') AS total_cart_additions,
    COUNT(*) FILTER (WHERE event = 'transaction') AS total_purchase_events,
    COUNT(DISTINCT visitorid) AS unique_visitors
FROM public.events
GROUP BY TO_TIMESTAMP("timestamp" / 1000.0)::date;

CREATE OR REPLACE VIEW public.vw_hourly_trends AS
SELECT
    EXTRACT(HOUR FROM TO_TIMESTAMP("timestamp" / 1000.0))::integer AS hour_of_day,
    COUNT(*) AS total_events,
    COUNT(*) FILTER (WHERE event = 'view') AS total_views,
    COUNT(*) FILTER (WHERE event = 'addtocart') AS total_cart_additions,
    COUNT(*) FILTER (WHERE event = 'transaction') AS total_purchase_events,
    COUNT(DISTINCT visitorid) AS unique_visitors
FROM public.events
GROUP BY EXTRACT(HOUR FROM TO_TIMESTAMP("timestamp" / 1000.0))::integer;
