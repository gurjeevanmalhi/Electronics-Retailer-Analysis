-- Inserted clean data
insert into stores(store_key, country, state, square_meters, open_date)
select store_key::smallint,
       country,
       state,
       square_meters::int,
       open_date::date
from stores_staging;

-- Dropped staging table
drop table if exists stores_staging;