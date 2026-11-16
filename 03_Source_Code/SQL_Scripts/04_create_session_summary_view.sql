-- ShopMetrics: sessionize events using a 30-minute inactivity threshold per visitor.
-- A new session starts when the gap from the prior event is greater than 1,800,000 ms.

CREATE OR REPLACE VIEW public.vw_session_summary AS
WITH ordered_events AS (
    SELECT
        visitorid,
        "timestamp",
        event,
        LAG("timestamp") OVER (
            PARTITION BY visitorid
            ORDER BY "timestamp"
        ) AS previous_timestamp
    FROM public.events
    WHERE visitorid IS NOT NULL
      AND "timestamp" IS NOT NULL
),
session_starts AS (
    SELECT
        visitorid,
        "timestamp",
        event,
        CASE
            WHEN previous_timestamp IS NULL
              OR "timestamp" - previous_timestamp > 1800000
            THEN 1
            ELSE 0
        END AS starts_new_session
    FROM ordered_events
),
sessionized_events AS (
    SELECT
        visitorid,
        "timestamp",
        event,
        SUM(starts_new_session) OVER (
            PARTITION BY visitorid
            ORDER BY "timestamp"
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS session_number
    FROM session_starts
)
SELECT
    visitorid,
    session_number,
    COUNT(*) AS events_in_session,
    MIN("timestamp") AS session_start_timestamp,
    MAX("timestamp") AS session_end_timestamp,
    (MAX("timestamp") - MIN("timestamp")) / 60000.0 AS session_duration_minutes,
    BOOL_OR(event = 'view') AS has_view,
    BOOL_OR(event = 'addtocart') AS has_cart,
    BOOL_OR(event = 'transaction') AS has_purchase
FROM sessionized_events
GROUP BY visitorid, session_number;
