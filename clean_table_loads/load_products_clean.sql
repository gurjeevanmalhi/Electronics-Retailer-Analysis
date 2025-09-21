-- Created clean table
create table products
(
    product_key     int primary key,
    product_name    text,
    brand           text,
    color           text,
    unit_cost_usd   numeric,
    unit_price_usd  numeric,
    subcategory_key char(4),
    category_key    char(4),
    constraint fk_subcategory foreign key (subcategory_key)
        references subcategories (subcategory_key),
    constraint fk_category foreign key (category_key)
        references categories (category_key)
);

-- Inserting clean data
insert into products(product_key, product_name, brand, color, unit_cost_usd, unit_price_usd, subcategory_key,
                     category_key)
select product_key::int,
       product_name,
       brand,
       color,
       unit_cost_usd::numeric,
       unit_price_usd::numeric,
       subcategory_key,
       category_key
from products_staging;










