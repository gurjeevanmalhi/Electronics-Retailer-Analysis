-- Loading clean fx_rates data
insert into fx_rates(fx_date, currency, fx_rate)
select fx_date::date, currency, fx_rate::decimal(5, 4)
from exchange_rates_staging;

-- Dropped staging table
drop table if exists exchange_rates_staging cascade;
