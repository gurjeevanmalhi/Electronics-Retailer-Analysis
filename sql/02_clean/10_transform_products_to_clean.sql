------------------------------------------------------------------------------------------------------------------------

-- Table Profiling

select *
from products_staging;

-- 2,517 Records
select count(*)
from products_staging;

-- 0 Duplicate Reocrds
select product_key,
       product_name,
       brand,
       color,
       unit_cost_usd,
       unit_price_usd,
       subcategory_key,
       category_key,
       category,
       count(*)
from products_staging
group by 1, 2, 3, 4, 5, 6, 7, 8, 9
having count(*) > 1;

-- 0 Null Values
select count(*) - count(product_key)     as product_key_nulls,
       count(*) - count(product_name)    as product_name_nulls,
       count(*) - count(brand)           as brand_nulls,
       count(*) - count(color)           as color_nulls,
       count(*) - count(unit_cost_usd)   as unit_cost_usd_nulls,
       count(*) - count(unit_price_usd)  as unit_price_usd_nulls,
       count(*) - count(subcategory_key) as subcategory_key_nulls,
       count(*) - count(subcategory)     as subcategory_nulls,
       count(*) - count(category_key)    as category_key_nulls,
       count(*) - count(category)        as category_nulls
from products_staging;

------------------------------------------------------------------------------------------------------------------------

-- Product Key

-- All keys are unique
select count(product_key) - count(distinct product_key)
from products_staging;

-- Verified numeric format
select product_key
from products_staging
where product_key !~ '^[0-9]+$';

------------------------------------------------------------------------------------------------------------------------

-- Product Name

-- All products are unique
select count(product_name) - count(distinct product_name)
from products_staging;

select distinct product_name
from products_staging;

------------------------------------------------------------------------------------------------------------------------

-- Brand

-- Records are clean
select distinct brand
from products_staging;

-- 11 total brands
select count(distinct brand)
from products_staging;

------------------------------------------------------------------------------------------------------------------------

-- Color

-- Records are clean
select distinct color
from products_staging;

------------------------------------------------------------------------------------------------------------------------

-- Unit Cost USD

-- All records begin with a '$' character
select count(unit_cost_usd)
from products_staging
where unit_cost_usd not like '$%';

-- Removing '$'
update products_staging
set unit_cost_usd = substring(unit_cost_usd from 2);

-- Identified Comma Characters
select unit_cost_usd
from products_staging
where unit_cost_usd like '%,%';

-- Replaced Commas with Blanks
update products_staging
set unit_cost_usd = replace(unit_cost_usd, ',', '');

select min(unit_cost_usd::decimal) as min,
       avg(unit_cost_usd::decimal) as avg,
       max(unit_cost_usd::decimal) as max
from products_staging;

------------------------------------------------------------------------------------------------------------------------

-- Unit Price USD

select products_staging.unit_price_usd
from products_staging
limit 10;

-- All records begin with a '$' character
select count(unit_price_usd)
from products_staging
where unit_price_usd not like '$%';

-- Removing '$' Character
update products_staging
set unit_price_usd = substring(unit_price_usd from 2);

-- Identified Comma Characters
select unit_price_usd
from products_staging
where unit_price_usd like '%,%';

-- Removing Comma Characters
update products_staging
set unit_price_usd = replace(unit_price_usd, ',', '');

select min(unit_price_usd::decimal) as min,
       avg(unit_price_usd::decimal) as avg,
       max(unit_price_usd::decimal) as max
from products_staging;

------------------------------------------------------------------------------------------------------------------------
-- Subcategory Key

-- 32 Unique Subcategories
select distinct subcategory_key
from products_staging;

-- Validated Pattern
select distinct products_staging.subcategory_key
from products_staging
where subcategory_key !~ '^\d{4}$';

------------------------------------------------------------------------------------------------------------------------
-- Subcategory

select distinct products_staging.subcategory
from products_staging;

-- Cleaned Subcategory Value
update products_staging
set subcategory = 'MP4 & MP3'
where subcategory = 'MP4&MP3';

------------------------------------------------------------------------------------------------------------------------
-- Category Key

-- 8 Unique Subcategories
select count(distinct category_key)
from products_staging;

select distinct products_staging.category_key
from products_staging;

------------------------------------------------------------------------------------------------------------------------
-- Category

-- 8 Unique Categories
select count(distinct category)
from products_staging;

select distinct category
from products_staging;

-- Cleaned Category Name
update products_staging
set category = 'Cameras and Camcorders'
where category = 'Cameras and camcorders';





