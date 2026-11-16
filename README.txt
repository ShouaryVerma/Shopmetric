=====================================================================
SHOPMETRICS - E-COMMERCE BEHAVIOUR ANALYTICS
=====================================================================
Smarter Insights. Stronger Decisions.

Author  : [Shouary Verma]
Date    : November 2026
Tools   : Power BI Desktop, SQL, Excel, Python (pandas, matplotlib)
Dataset : Retailrocket e-commerce dataset (3 May - 18 Sep 2015)


1. PROJECT OVERVIEW
---------------------------------------------------------------------
ShopMetrics studies how visitors to an online shop browse, add items
to their cart and buy. It turns 2.76 million raw clickstream events
into a six-page Power BI dashboard covering traffic, the visitor
funnel, product performance, time and session patterns, and basket /
cross-sell behaviour.


2. FOLDER GUIDE
---------------------------------------------------------------------
01_Presentation      PowerPoint presentation summarising the project.
02_Data              Source CSV files:
                       - events.csv               (2,756,101 rows)
                       - item_properties_part1.csv
                       - item_properties_part2.csv (20.3M rows combined)
                       - category_tree.csv        (1,669 categories)
03_Source_Code       Code and scripts used to prepare and analyse
                     the data.
04_Dashboard         Power BI file (.pbix). Open with Power BI
                     Desktop.
05_Live_Link         Link to the published dashboard.
                     URL: [add link here]
06_PDF               Full project report (method, findings,
                     recommendations).
07_Dashboard_PDF     PDF export of the dashboard pages.
README.txt           This file.


3. DASHBOARD PAGES
---------------------------------------------------------------------
1. Home                      KPI cards and quick navigation
2. Overview                  Events, sessions, event mix, daily trends
3. Customer Journey & Funnel View -> cart -> purchase conversion
4. Product Performance       Top items by views and by sales
5. Time & Session Analysis   Hourly patterns and session length
6. Basket & Cross-Sell       Basket size, product pairs, support, lift


4. KEY FINDINGS
---------------------------------------------------------------------
- 1,407,580 unique visitors, 1,761,675 sessions, 17,672 transactions.
- 96.7% of events are product views. 2.68% of visitors added to cart
  and 0.83% purchased.
- 72% of visitors who added to cart have no recorded purchase.
- 78% of sessions contain a single event. Average session: 1.75 min.
- Transactions peak at 23:00 (IST), with 1,994 events.
- 85% of baskets hold one item (average 1.26 items per basket).
- Strongest co-purchase: items 213834 + 445351 (39 transactions).


5. HOW TO USE
---------------------------------------------------------------------
1. Open 04_Dashboard/Shopmetrics_dashboard.pbix in Power BI Desktop,
   or use the live link in 05_Live_Link.
2. Use the page buttons at the top to move between pages.
3. Use the date and dropdown slicers to filter the data.
4. If the data does not load, point Power BI to the CSV files in
   02_Data (Home > Transform data > Data source settings).


6. DEFINITIONS AND NOTES
---------------------------------------------------------------------
- Session: a visitor's events with no gap longer than 30 minutes.
- Visitor purchase rate: visitors with a transaction / all visitors.
- Basket: one distinct transaction ID; size = distinct items in it.
- Time zone: timestamps are UTC. Hour-of-day views in the dashboard
  use IST (UTC+5:30).
- The first and last days of the data are partial days.
- Item properties are anonymised; only "categoryid" and "available"
  are readable. There is no price or revenue data.


7. DATA SOURCE
---------------------------------------------------------------------
Retailrocket recommender system dataset (public e-commerce data).
Please follow the dataset's own licence and terms when sharing.
