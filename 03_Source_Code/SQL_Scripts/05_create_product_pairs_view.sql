-- ShopMetrics: pair-level co-purchase metrics.
-- Requires public.basket_items, created by script 01.

CREATE OR REPLACE VIEW public.vw_product_pairs AS
WITH item_counts AS (
    SELECT
        itemid,
        COUNT(DISTINCT transactionid) AS item_transactions
    FROM public.basket_items
    WHERE transactionid IS NOT NULL
    GROUP BY itemid
),
total_baskets AS (
    SELECT COUNT(DISTINCT transactionid) AS total_transactions
    FROM public.basket_items
    WHERE transactionid IS NOT NULL
),
pair_counts AS (
    SELECT
        a.itemid AS item_a,
        b.itemid AS item_b,
        COUNT(DISTINCT a.transactionid) AS pair_transactions
    FROM public.basket_items a
    INNER JOIN public.basket_items b
        ON a.transactionid = b.transactionid
       AND a.visitorid = b.visitorid
       AND a.itemid < b.itemid
    WHERE a.transactionid IS NOT NULL
    GROUP BY a.itemid, b.itemid
)
SELECT
    p.item_a,
    p.item_b,
    p.pair_transactions,
    ia.item_transactions AS item_a_transactions,
    ib.item_transactions AS item_b_transactions,
    ROUND(
        (p.pair_transactions::numeric / NULLIF(t.total_transactions, 0)) * 100,
        4
    ) AS support_pct,
    ROUND(
        (p.pair_transactions::numeric / NULLIF(ia.item_transactions, 0)) * 100,
        2
    ) AS confidence_a_to_b_pct,
    ROUND(
        (p.pair_transactions::numeric / NULLIF(ib.item_transactions, 0)) * 100,
        2
    ) AS confidence_b_to_a_pct,
    ROUND(
        (p.pair_transactions::numeric * t.total_transactions)
        / NULLIF(ia.item_transactions::numeric * ib.item_transactions, 0),
        3
    ) AS lift
FROM pair_counts p
INNER JOIN item_counts ia ON p.item_a = ia.itemid
INNER JOIN item_counts ib ON p.item_b = ib.itemid
CROSS JOIN total_baskets t;
