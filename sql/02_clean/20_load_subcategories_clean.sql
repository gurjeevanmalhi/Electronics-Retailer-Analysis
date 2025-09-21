-- Inserted clean data
insert into subcategories(subcategory_key, subcategory)
select distinct subcategory_key::char(4), subcategory
from products_staging;
