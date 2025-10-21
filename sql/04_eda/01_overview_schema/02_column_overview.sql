-- Confirm structure, datatypes, and nullability
select
    table_name,
    column_name,
    data_type,
    is_nullable,
    character_maximum_length,
    numeric_precision,
    numeric_scale,
    ordinal_position
from information_schema.columns
where table_schema = 'public'
order by table_name, ordinal_position;