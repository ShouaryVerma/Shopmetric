-- ShopMetrics: validation queries. Run after scripts 01–07.

-- Event counts and total events.
SELECT
    COUNT(*) AS total_events,
    COUNT(*) FILTER (WHERE event = 'view') AS total_views,
    COUNT(*) FILTER (WHERE event = 'addtocart') AS total_cart_additions,
    COUNT(*) FILTER (WHERE event = 'transaction') AS total_transaction_events
FROM public.events;

-- Basket-level validation.
SELECT
    COUNT(*) AS basket_item_records,
    COUNT(DISTINCT transactionid) AS unique_transactions,
    COUNT(DISTINCT itemid) AS unique_products
FROM public.basket_items;

-- Visitor funnel validation.
SELECT * FROM public.vw_visitor_funnel;

-- Session summary validation.
SELECT
    COUNT(*) AS total_sessions,
    AVG(session_duration_minutes) AS average_session_duration_minutes,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY session_duration_minutes)
        AS median_session_duration_minutes,
    AVG(events_in_session) AS average_events_per_session,
    COUNT(*) FILTER (WHERE events_in_session = 1) AS single_event_sessions,
    MAX(session_duration_minutes) AS longest_session_minutes
FROM public.vw_session_summary;

-- Product pairs: inspect most frequent combinations.
SELECT *
FROM public.vw_product_pairs
ORDER BY pair_transactions DESC
LIMIT 20;

-- Basket size distribution: basket counts should sum to the number of unique transactions.
SELECT *
FROM public.vw_basket_size_distribution
ORDER BY sort_order;

-- Visitor activity overlap.
SELECT *
FROM public.vw_visitor_activity_overlap;

-- Daily and hourly views: sample checks.
SELECT * FROM public.vw_daily_trends ORDER BY event_date LIMIT 10;
SELECT * FROM public.vw_hourly_trends ORDER BY hour_of_day;
