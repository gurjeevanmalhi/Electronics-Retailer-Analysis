-- Creating Staging Table
create table sales_staging
(
    order_number  varchar(220),
    line_item     varchar(220),
    order_date    varchar(220),
    delivery_date varchar(220),
    customer_key  varchar(220),
    store_key     varchar(220),
    product_key   varchar(220),
    quantity      varchar(220),
    currency_code varchar(220)
);