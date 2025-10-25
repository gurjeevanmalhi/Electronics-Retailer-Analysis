-- Row count per table in the public schema.

select
    n.nspname,
    c.relname as table_name,
    c.reltuples::bigint as approx_row_count
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
    and c.relkind in ('r','p') -- tables and partitioned tables
order by 3 desc;