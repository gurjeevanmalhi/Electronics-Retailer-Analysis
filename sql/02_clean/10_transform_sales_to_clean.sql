------------------------------------------------------------------------------------------------------------------------
-- Table Profiling

-- 62,884 records
select count(*)
from sales_staging;

-- 0 Duplicates
select order_number,
       line_item,
       order_date,
       delivery_date,
       customer_key,
       store_key,
       product_key,
       quantity,
       currency_code,
       count(*)
from sales_staging
group by 1, 2, 3, 4, 5, 6, 7, 8, 9
having count(*) > 1;

-- Returning Null Count
select count(*) - count(order_number)  as order_number_nulls,
       count(*) - count(line_item)     as line_item_nulls,
       count(*) - count(order_date)    as order_date_nulls,
       count(*) - count(delivery_date) as deliver_date_nulls, -- 49,719 nulls
       count(*) - count(customer_key)  as customer_key_nulls,
       count(*) - count(store_key)     as store_key_nulls,
       count(*) - count(product_key)   as product_key_nulls,
       count(*) - count(quantity)      as quantity_nulls,
       count(*) - count(currency_code) as currency_code_nulls
from sales_staging;

------------------------------------------------------------------------------------------------------------------------
-- Order Number

-- 36,558 unique order numbers
select count(*) - count(distinct order_number)
from sales_staging;

-- Returning orders with multiple line items
select *
from sales_staging
where order_number in (select order_number
                       from sales_staging
                       group by 1
                       having count(order_number) > 1);

-- Order numbers may be 6-7 digits
select min(length(sales_staging.order_number)) as min, max(length(sales_staging.order_number)) as max
from sales_staging;

-- Validated pattern
select order_number
from sales_staging
where order_number !~ '^[0-9]+$';

------------------------------------------------------------------------------------------------------------------------
-- Line Item
select distinct line_item
from sales_staging;

------------------------------------------------------------------------------------------------------------------------
-- Order Date

select order_date
from sales_staging
limit 100;

-- Updated to 'YYYY-MM-DD'
update sales_staging
set order_date = (order_date::date)::text;

------------------------------------------------------------------------------------------------------------------------
-- Delivery Date

select order_number, delivery_date
from sales_staging
limit 50;

-- Updated to 'YYYY-MM-DD'
update sales_staging
set delivery_date = (delivery_date::date)::text;

------------------------------------------------------------------------------------------------------------------------
-- Customer Key

-- 11,887 unique customer keys
select count(distinct customer_key)
from sales_staging;

-- Validated numeric format
select customer_key
from sales_staging
where customer_key !~ '^[0-9]+$';

------------------------------------------------------------------------------------------------------------------------
-- Store Key

select distinct store_key from sales_staging;

-- Validated numeric format
select store_key
from sales_staging
where store_key !~ '^[0-9]+$';

------------------------------------------------------------------------------------------------------------------------
-- Product Key

select distinct product_key from sales_staging;

-- Validated numeric format
select store_key
from sales_staging
where store_key !~ '^[0-9]+$';

------------------------------------------------------------------------------------------------------------------------
-- Quantity

-- Validated
select distinct quantity from sales_staging;

------------------------------------------------------------------------------------------------------------------------
-- Currency Code

-- Validated
select distinct currency_code from sales_staging;
