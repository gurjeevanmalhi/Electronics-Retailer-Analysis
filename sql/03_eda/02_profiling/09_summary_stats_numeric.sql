-- Approx numeric summary per column using pg_stats

with s as (
    select
        s.schemaname,
        s.tablename,
        s.attname,
        to_jsonb(s.histogram_bounds) as hb, -- histogram bucket bounds
        s.null_frac,
        c.reltuples::numeric as rows
    from pg_stats s
    join pg_class c on c.relname = s.tablename
    join pg_namespace n on n.oid = c.relnamespace and n.nspname = s.schemaname
    join pg_attribute a on a.attrelid = c.oid and a.attname = s.attname
    join pg_type t on t.oid = a.atttypid
    where s.schemaname = 'public'
        and s.histogram_bounds is not null
    and t.typcategory = 'N'), -- numeric types only

p as (
    select
        schemaname,
        tablename,
        attname,
        hb,
        null_frac,
        rows,
        jsonb_array_length(hb) as m,
        greatest(jsonb_array_length(hb) - 1, 1) as k -- bucket count
    from s)

select
  tablename as table_name,
  attname as column_name,
  round(((hb ->> 0)::numeric), 4) as approx_min,
  round(((hb ->> CEIL(0.25 * k)::int)::numeric), 4) as approx_p25,
  round(((hb ->> CEIL(0.50 * k)::int)::numeric), 4)as approx_median,
  round(((hb ->> CEIL(0.75 * k)::int)::numeric), 4) as approx_p75,
  round(((hb ->> (m - 1))::numeric), 4) as approx_max,
  round((null_frac * 100)::numeric, 2) as null_percent
from p
order by 1,2;