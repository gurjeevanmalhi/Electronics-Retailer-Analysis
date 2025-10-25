-- Display data type by column for each table and total count of data types per table.

select
    table_name,
    column_name,
    data_type
from information_schema.columns
where table_schema = 'public'
order by 1,2;
------------------------------------------------------------------------------------------------------------------------
select
    table_name,
    data_type,
    count(data_type)
from information_schema.columns
where table_schema = 'public'
group by 1,2
order by 1,3 desc;