-- IQR-based outlier check for quantity.

with stats as (
  select
    percentile_cont(0.25) within group (order by t.unit_price_usd)::numeric as q1,
    percentile_cont(0.50) within group (order by t.unit_price_usd)::numeric as median,
    percentile_cont(0.75) within group (order by t.unit_price_usd)::numeric as q3,
    avg(t.unit_price_usd)::numeric as mean,
    stddev_pop(t.unit_price_usd)::numeric as stddev,
    count(*)::bigint as n
  from public."products" t
  where t.unit_price_usd is not null
),
fences as (
  select
    q1, median, q3,
    (q3 - q1) as iqr,
    (q1 - 1.5*(q3 - q1)) as lower_fence,
    (q3 + 1.5*(q3 - q1)) as upper_fence,
    mean, stddev, n
  from stats
),
counts as (
  select
    sum((t.unit_price_usd < f.lower_fence)::int) as low_outliers,
    sum((t.unit_price_usd > f.upper_fence)::int) as high_outliers
  from public."products" t
  cross join fences f
  where t.unit_price_usd is not null
)
select
  'sales' as table_name,
  'quantity' as column_name,
  stats.n, stats.mean, stats.median, stats.q1, stats.q3, iqr,
  lower_fence, upper_fence,
  low_outliers, high_outliers,
  (low_outliers + high_outliers) as total_outliers
from fences
join stats  on true
join counts on true;