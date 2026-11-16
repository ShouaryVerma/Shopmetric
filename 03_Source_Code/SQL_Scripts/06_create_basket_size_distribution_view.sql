-- ShopMetrics: distinct product IDs per transaction, grouped into basket-size bands.
-- Requires public.basket_items, created by script 01.

CREATE OR REPLACE VIEW public.vw_basket_size_distribution AS
WITH basket_sizes AS (
    SELECT
        transactionid,
        COUNT(DISTINCT itemid) AS basket_size
    FROM public.basket_items
    WHERE transactionid IS NOT NULL
      AND itemid IS NOT NULL
    GROUP BY transactionid
),
bucketed AS (
    SELECT
        CASE
            WHEN basket_size = 1 THEN '1 item'
            WHEN basket_size BETWEEN 2 AND 3 THEN '2–3 items'
            WHEN basket_size BETWEEN 4 AND 5 THEN '4–5 items'
            ELSE '6+ items'
        END AS basket_size_group,
        CASE
            WHEN basket_size = 1 THEN 1
            WHEN basket_size BETWEEN 2 AND 3 THEN 2
            WHEN basket_size BETWEEN 4 AND 5 THEN 3
            ELSE 4
        END AS sort_order
    FROM basket_sizes
)
SELECT
    basket_size_group,
    sort_order,
    COUNT(*) AS basket_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS basket_percentage
FROM bucketed
GROUP BY basket_size_group, sort_order
ORDER BY sort_order;
