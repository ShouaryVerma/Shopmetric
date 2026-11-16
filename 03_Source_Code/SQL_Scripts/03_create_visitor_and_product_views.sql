-- ShopMetrics: visitor funnel and product performance views.

CREATE OR REPLACE VIEW public.vw_visitor_funnel AS
SELECT
    COUNT(DISTINCT visitorid) AS total_visitors,
    COUNT(DISTINCT visitorid) FILTER (WHERE event = 'view') AS visitors_viewed,
    COUNT(DISTINCT visitorid) FILTER (WHERE event = 'addtocart') AS visitors_added_to_cart,
    COUNT(DISTINCT visitorid) FILTER (WHERE event = 'transaction') AS visitors_purchased,
    COUNT(DISTINCT visitorid) FILTER (WHERE event = 'view') * 100.0
        / NULLIF(COUNT(DISTINCT visitorid), 0) AS visitor_view_rate_pct,
    COUNT(DISTINCT visitorid) FILTER (WHERE event = 'addtocart') * 100.0
        / NULLIF(COUNT(DISTINCT visitorid), 0) AS visitor_cart_rate_pct,
    COUNT(DISTINCT visitorid) FILTER (WHERE event = 'transaction') * 100.0
        / NULLIF(COUNT(DISTINCT visitorid), 0) AS visitor_purchase_rate_pct
FROM public.events
WHERE visitorid IS NOT NULL;

CREATE OR REPLACE VIEW public.vw_product_performance AS
SELECT
    itemid,
    COUNT(*) FILTER (WHERE event = 'view') AS total_views,
    COUNT(*) FILTER (WHERE event = 'addtocart') AS total_cart_additions,
    COUNT(*) FILTER (WHERE event = 'transaction') AS total_purchase_events,
    COUNT(DISTINCT visitorid) FILTER (WHERE event = 'view') AS unique_viewers,
    COUNT(DISTINCT visitorid) FILTER (WHERE event = 'transaction') AS unique_buyers
FROM public.events
WHERE itemid IS NOT NULL
GROUP BY itemid;
