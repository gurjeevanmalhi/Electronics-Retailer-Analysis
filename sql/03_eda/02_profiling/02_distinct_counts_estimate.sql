-- Estimated distinct counts per column for each table.

with distinct_count as (
    SELECT
      s.tablename,
      s.attname as column_name,
      c.reltuples::bigint as approx_rows,
      case
        when s.n_distinct >= 0
          then s.n_distinct::bigint
        else greatest(1, round(((-s.n_distinct) * c.reltuples)::numeric)::bigint)
      end as approx_distinct
    from pg_stats s
    join pg_class c on c.relname = s.tablename
    join pg_namespace n on n.oid = c.relnamespace and n.nspname = s.schemaname
    where s.schemaname = 'public')

select
    tablename,
    column_name,
    approx_rows,
    approx_distinct,
    round(approx_distinct * 100.0 / approx_rows,2) as distinct_ratio
from distinct_count;
