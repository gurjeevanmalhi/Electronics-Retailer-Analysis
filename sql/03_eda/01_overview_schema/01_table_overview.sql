-- Returns schema name, table names, field count, and row count
select
  n.nspname as schema_name,
  c.relname as table_name,
  pg_total_relation_size(format('%I.%I', n.nspname, c.relname)) / 1024 / 1024 as size_mb,
  c.reltuples::bigint as approx_rows
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relkind in ('r','p')  -- r=table, p=partitioned table
order by size_mb desc;


