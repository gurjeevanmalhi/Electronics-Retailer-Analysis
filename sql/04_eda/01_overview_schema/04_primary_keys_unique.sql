-- List primary key and unique constraints for tables in 'public'.
select
    tc.table_name,
    tc.constraint_type,
    kcu.column_name
from information_schema.table_constraints tc
join information_schema.key_column_usage kcu
    on tc.constraint_name = kcu.constraint_name
where tc.table_schema = 'public'
    and tc.constraint_type in ('PRIMARY KEY','UNIQUE')
order by tc.table_name, tc.constraint_type, kcu.ordinal_position;