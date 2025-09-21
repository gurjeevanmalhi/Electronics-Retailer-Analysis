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