-- Table Profiling

-- 11,215 records
select count(*)
from exchange_rates_staging;

-- 0 Nulls
select count(*) - count(fx_date), count(*) - count(currency), count(*) - count(fx_rate)
from exchange_rates_staging;

-- 0 Blanks
select count(*)
from exchange_rates_staging
where fx_date = ''
   or currency = ''
   or fx_rate = '';

------------------------------------------------------------------------------------------------------------------------
-- Fx Date

--2,243 unique dates
select distinct fx_date
from exchange_rates_staging;

update exchange_rates_staging
set fx_date = (fx_date::date)::text;

-- Date Ranges from 2015-01-01 to 2021-02-20
select min(fx_date::date) as min, max(fx_date::date) as max
from exchange_rates_staging;

------------------------------------------------------------------------------------------------------------------------
-- Currency

-- 5 unique currencies
select distinct currency
from exchange_rates_staging;

------------------------------------------------------------------------------------------------------------------------
-- Fx rate

select fx_rate
from exchange_rates_staging;

select min(fx_rate::decimal) as min, avg(fx_rate::decimal) as avg, max(fx_rate::decimal) as max
from exchange_rates_staging;

-- 6 Total Characters
select max(length(fx_rate)) as max_length
from exchange_rates_staging;

select fx_rate
from exchange_rates_staging
where length(fx_rate) < (select max(length(fx_rate))
                         from exchange_rates_staging);

-- Converting to 6 digits total, 4 after decimal
update exchange_rates_staging
set fx_rate = (fx_rate::decimal(5, 4));

-- Converting back to text
update exchange_rates_staging
set fx_rate = (fx_rate::text);

-- Validated precision
select min(length(fx_rate)) as min, max(length(fx_rate)) as max
from exchange_rates_staging;