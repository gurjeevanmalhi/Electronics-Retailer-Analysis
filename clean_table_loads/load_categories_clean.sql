-- Created clean table
create table categories
(
    category_key char(2) primary key,
    category     text
);

-- Inserted clean data
insert into categories(category_key, category)
select distinct category_key::char(2), category
from products_staging;

