-- IQR-based outlier check for quantity.

with stats as (
  select
    percentile_cont(0.25) within group (order by t."quantity")::numeric as q1,
    percentile_cont(0.50) within group (order by t."quantity")::numeric as median,
    percentile_cont(0.75) within group (order by t."quantity")::numeric as q3,
    avg(t."quantity")::numeric as mean,
    stddev_pop(t."quantity")::numeric as stddev,
    count(*)::bigint as n
  from public."sales" t
  where t."quantity" is not null
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
    sum((t."quantity" < f.lower_fence)::int) as low_outliers,
    sum((t."quantity" > f.upper_fence)::int) as high_outliers
  from public."sales" t
  cross join fences f
  where t."quantity" is not null
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
