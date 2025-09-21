------------------------------------------------------------------------------------------------------------------------

-- Table Profiling

-- Returning Table Size
select count(*)
from stores_staging;

-- Returning Duplicate Records
select store_key, country, square_meters, open_date
from stores_staging
group by 1, 2, 3, 4
having count(*) > 1;

-- Returning Null Values
select count(*) - count(store_key)     as store_key_nulls,
       count(*) - count(country)       as country_nulls,
       count(*) - count(state)         as state_nulls,
       count(*) - count(square_meters) as square_meters_nulls,
       count(*) - count(open_date)     as open_date_nulls -- 1 null
from stores_staging;

------------------------------------------------------------------------------------------------------------------------

-- Store Key

-- Verified store keys are unique
select count(distinct store_key)
from stores_staging;

-- Verified numeric values
select store_key
from stores_staging
where store_key !~ '[0-9]';

------------------------------------------------------------------------------------------------------------------------

-- Country

select distinct country
from stores_staging;

------------------------------------------------------------------------------------------------------------------------

-- State

-- Returning Invalid State Names
select store_key, state, country
from stores_staging
where state !~ '^[A-Za-z -]+$';

-- Cleaning State Names
update stores_staging
set state =
        case
            when store_key = '22' then 'Freistaat Thuringen'
            when store_key = '15' then 'La Reunion'
            when store_key = '14' then 'Franche-Comte'
            else state
            end;
------------------------------------------------------------------------------------------------------------------------

-- Square Meters

select distinct square_meters
from stores_staging;

------------------------------------------------------------------------------------------------------------------------

-- Open Date

update stores_staging
set open_date = (open_date::date)::varchar(220);

