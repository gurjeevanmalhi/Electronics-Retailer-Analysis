-- Identify all foreign key relationships in the 'public' schema.
select
    tc.table_name as child_table,
    kcu.column_name as child_column,
    ccu.table_name as parent_table,
    ccu.column_name as parent_column
from information_schema.table_constraints as tc
join information_schema.key_column_usage as kcu
    on tc.constraint_name = kcu.constraint_name
join information_schema.constraint_column_usage as ccu
    on ccu.constraint_name = tc.constraint_name
where tc.constraint_type = 'FOREIGN KEY'
    and tc.table_schema = 'public'
order by child_table;
