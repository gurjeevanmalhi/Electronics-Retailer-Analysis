-- Display all indexes in the 'public' schema.
-- Helps identify redundant and non-used indexes to understand performance and optimization potential.

select
    t.relname as table_name,
    i.relname as index_name,
    a.attname as column_name,
    ix.indisunique as is_unique,
    ix.indisprimary as is_primary
from pg_class t
join pg_index ix on t.oid = ix.indrelid
join pg_class i on i.oid = ix.indexrelid
join pg_attribute a on a.attrelid = t.oid and a.attnum = any(ix.indkey)
join pg_namespace n on n.oid = t.relnamespace
where n.nspname = 'public'
order by t.relname, i.relname;