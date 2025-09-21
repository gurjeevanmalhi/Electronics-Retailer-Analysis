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









