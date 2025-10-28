-- Computes mean, median, and mode for unit_price_usd column.
select
    'products' as table_name,
    'unit_price_usd' as col_name,
    round(avg(unit_price_usd)) as mean,
    round(percentile_cont(0.5) within group (order by unit_price_usd)::numeric,2) as median,
    mode() within group (order by unit_price_usd) as mode,
    count(*) as total_records
from products
where unit_price_usd is not null;