-- Inserting clean data
insert into sales(order_number, line_item, order_date, delivery_date, customer_key, store_key, product_key, quantity,
                  currency_code)
select order_number::int,
       line_item::smallint,
       order_date::date,
       delivery_date::date,
       customer_key::int,
       store_key::smallint,
       product_key::int,
       quantity::smallint,
       currency_code
from sales_staging;

-- Dropped staging table
drop table if exists sales_staging;
