-- Created clean table
create table subcategories
(
    subcategory_key char(4) primary key,
    subcategory     text
);

-- Inserted clean data
insert into subcategories(subcategory_key, subcategory)
select distinct subcategory_key::char(4), subcategory
from products_staging;


