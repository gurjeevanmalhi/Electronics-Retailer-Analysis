-- Quick Checks
-- verified no duplicates that would block a PK
select fx_date,currency_code,fx_rate, count(*)
from fx_rates
group by 1,2,3
having count(*) > 1;

-- 0 rows in sales that won’t match fx_rates
select s.*
from sales s
left join fx_rates f
  on f.fx_date = s.order_date
 and f.currency_code = s.currency_code
where f.fx_date is null;

------------------------------------------------------------------------------------------------------------------------
-- create foreign and primary keys for fx_rates

-- create surrogate key in fx_rates
alter table fx_rates
add column fx_key serial primary key;

-- add column in sales to hold ID
alter table sales
add column fx_key int;

-- update sales.fx_key by matching date + currency
update sales s
set fx_key = f.fx_key
from fx_rates f
where s.order_date = f.fx_date
    and s.currency_code = f.currency_code;

-- add foreign key constraint to sales table
alter table sales
add constraint fk_sales_fx
foreign key (fx_key) references fx_rates(fx_key);




