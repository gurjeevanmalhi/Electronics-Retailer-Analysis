-- Computes mean, median, and mode for quantity column.
select
    'sales' as table_name,
    'quantity' as col_name,
    round(avg(quantity)) as mean,
    round(percentile_cont(0.5) within group (order by quantity)::numeric,2) as median,
    mode() within group (order by quantity) as mode,
    count(*) as total_records
from sales
where quantity is not null;