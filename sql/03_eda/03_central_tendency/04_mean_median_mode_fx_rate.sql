-- Computes mean, median, and mode for fx_rate column.
select
    'fx_rates' as table_name,
    'fx_rate' as col_name,
    round(avg(fx_rate),2) as mean,
    round(percentile_cont(0.5) within group (order by fx_rate)::numeric,2) as median,
    mode() within group (order by fx_rate) as mode,
    count(*) as total_records
from fx_rates
where fx_rate is not null;