-- Calculate total and percentage of NULL values per column in each table.

select
    s.tablename as table_name,
    s.attname as column_name,
    format_type(a.atttypid, a.atttypmod) as data_type,
    round((s.null_frac * 100.0)::numeric,2) as null_percent,
    coalesce(round((c.reltuples * s.null_frac)::numeric)::bigint,0) as approx_null_count
from pg_stats s
join pg_class c on c.relname = s.tablename
join pg_namespace n on n.oid = c.relnamespace and n.nspname = s.schemaname
left join pg_attribute a on a.attrelid = c.oid and a.attname = s.attname
where s.schemaname = 'public'
order by 4 desc, 1, 2;
