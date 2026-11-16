# ShopMetrics — PostgreSQL SQL Scripts

This folder contains the SQL used for the ShopMetrics Retailrocket e-commerce analytics project.

## Source table prerequisite

The scripts expect an existing PostgreSQL table named `public.events` imported from Retailrocket `events.csv`, with these columns:

- `timestamp` — Unix timestamp in milliseconds
- `visitorid` — visitor identifier
- `event` — `view`, `addtocart`, or `transaction`
- `itemid` — product identifier
- `transactionid` — transaction identifier (populated for transaction events)

The original `events` table is imported from CSV and is not recreated by these scripts.

## Recommended execution order

Run each script in pgAdmin's Query Tool, against the `shopmetric` database, in this order:

1. `01_create_basket_items.sql`
2. `02_create_daily_and_hourly_views.sql`
3. `03_create_visitor_and_product_views.sql`
4. `04_create_session_summary_view.sql`
5. `05_create_product_pairs_view.sql`
6. `06_create_basket_size_distribution_view.sql`
7. `07_create_visitor_activity_overlap_view.sql`
8. `08_validation_checks.sql`

Scripts 02–04 and 07 depend on `events`. Scripts 05 and 06 depend on `basket_items`, which is created by script 01.

## Views created

- `vw_daily_trends`
- `vw_hourly_trends`
- `vw_visitor_funnel`
- `vw_product_performance`
- `vw_session_summary`
- `vw_product_pairs`
- `vw_basket_size_distribution`
- `vw_visitor_activity_overlap`

In Power BI, table/query display names may have been renamed (for example, `vw_daily_trends` to `Daily Trends`). The PostgreSQL view names remain as listed above.

## Important interpretation notes

- `total_purchase_events` counts transaction event rows; it is not revenue and should not automatically be described as unique orders.
- The visitor activity groups in `vw_visitor_activity_overlap` overlap. They are not mutually exclusive funnel stages.
- `vw_session_summary` uses a 30-minute inactivity gap per visitor to define sessions.
- Basket size counts distinct item IDs per transaction in `basket_items`; it does not count unit quantities.
- `vw_basket_size_distribution` groups transactions into 1 item, 2–3 items, 4–5 items, and 6+ items.
- The Retailrocket event data does not contain product names, category, brand, prices, revenue, customer demographics, device, payment, or traffic-source fields.

Check the row counts and sample values against the validation script after running the views.
