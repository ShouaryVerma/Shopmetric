-- ShopMetrics: overlapping visitor activity groups.
-- These groups are not mutually exclusive and are not sequential funnel stages.

CREATE OR REPLACE VIEW public.vw_visitor_activity_overlap AS
WITH visitor_flags AS (
    SELECT
        visitorid,
        BOOL_OR(event = 'view') AS viewed,
        BOOL_OR(event = 'addtocart') AS carted,
        BOOL_OR(event = 'transaction') AS purchased
    FROM public.events
    WHERE visitorid IS NOT NULL
    GROUP BY visitorid
)
SELECT
    'Viewed and added to cart' AS visitor_group,
    COUNT(*) AS visitor_count
FROM visitor_flags
WHERE viewed AND carted

UNION ALL

SELECT
    'Added to cart and purchased',
    COUNT(*)
FROM visitor_flags
WHERE carted AND purchased

UNION ALL

SELECT
    'Added to cart without purchase',
    COUNT(*)
FROM visitor_flags
WHERE carted AND NOT purchased

UNION ALL

SELECT
    'Viewed and purchased',
    COUNT(*)
FROM visitor_flags
WHERE viewed AND purchased;
