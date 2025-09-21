-- Created clean table
create table sales
(
    order_number  int,
    line_item     smallint,
    order_date    date,
    delivery_date date,
    customer_key  int,
    store_key     smallint,
    product_key   int,
    quantity      smallint,
    currency_code char(3),
    constraint fk_customer foreign key (customer_key)
        references customers (customer_key),
    constraint fk_store foreign key (store_key)
        references stores (store_key),
    constraint fk_product foreign key (product_key)
        references products (product_key)
);

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
