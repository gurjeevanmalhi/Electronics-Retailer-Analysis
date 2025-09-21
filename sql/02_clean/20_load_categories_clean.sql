-- Inserted clean data
insert into categories(category_key, category)
select distinct category_key::char(2), category
from products_staging;