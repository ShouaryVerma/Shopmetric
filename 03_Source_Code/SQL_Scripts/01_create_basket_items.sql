-- ShopMetrics: create distinct transaction-item records from transaction events.
-- Run against the shopmetric database after importing public.events.

CREATE TABLE IF NOT EXISTS public.basket_items AS
SELECT DISTINCT
    transactionid,
    visitorid,
    itemid
FROM public.events
WHERE event = 'transaction'
  AND transactionid IS NOT NULL
  AND itemid IS NOT NULL;

-- If basket_items already exists and the source events table has changed,
-- review the table before rerunning. CREATE TABLE IF NOT EXISTS will not refresh it.

-- Optional indexes for basket and pair analysis.
CREATE INDEX IF NOT EXISTS idx_basket_items_transactionid
    ON public.basket_items (transactionid);

CREATE INDEX IF NOT EXISTS idx_basket_items_itemid
    ON public.basket_items (itemid);
