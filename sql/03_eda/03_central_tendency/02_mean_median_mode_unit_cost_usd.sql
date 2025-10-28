-- Computes mean, median, and mode for unit_cost_usd column.
select
    'products' as table_name,
    'unit_cost_usd' as col_name,
    round(avg(unit_cost_usd)) as mean,
    round(percentile_cont(0.5) within group (order by unit_cost_usd)::numeric,2) as median,
    mode() within group (order by unit_cost_usd) as mode,
    count(*) as total_records
from products
where unit_cost_usd is not null;