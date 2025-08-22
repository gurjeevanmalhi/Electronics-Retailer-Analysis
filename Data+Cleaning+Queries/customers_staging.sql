-- Storing Raw Data
create table raw_customers(
    customer_key varchar(220),
    gender varchar(220),
    name varchar(220),
    city varchar(220),
    state_code varchar(220),
    state varchar(220),
    zip_code varchar(220),
    country varchar(220),
    continent varchar(220),
    birthday varchar(220)
);

-- Creating Staging Table
create table customers_staging(
    customer_key varchar(220),
    gender varchar(220),
    name varchar(220),
    city varchar(220),
    state_code varchar(220),
    state varchar(220),
    zip_code varchar(220),
    country varchar(220),
    continent varchar(220),
    birthday varchar(220)
);

-- Previewing Table
select * from customers_staging;

-- 15,266 Total Records
select count(*) from customers_staging;

-- Verified Unique Keys
select count(distinct customer_key)
from customers_staging;

-- Verified No Null or Blank Values
select count(customer_key)
from customers_staging
where customer_key is null
    or customer_key = ' ';

-- Verified No Null or Blank Values
select count(gender)
from customers_staging
where gender is null
    or gender = ' ';

select distinct(gender)
from customers_staging;

-- Verified No Null Values
select count(*) - count(name)
from customers_staging;

-- Verified No Blank Values
select name
from customers_staging
where name = ' ';

-- Returning Non-Conventional Names
select customer_key, name
from customers_staging
where name !~ '^[A-Za-z]+ [A-Za-z]+$';
-- ^ = start of string
-- [A-Za-z]+ = one or more upper or lowercase letters
-- [A-Za-z]+ = space + one more upper or lowercase letters
-- $ = end of string

-- Creating View for Non Standard Names
create view vw_nonstandard_names as
select customer_key,name
from customers_staging
where name !~ '^[A-Za-z'' -]+$';

-- Updating Special or Invalid Characters
update customers_staging
set name = regexp_replace(name, '^J[^A-Za-z]rg', 'Jurg')
where customer_key in (select customer_key
                       from vw_nonstandard_names
                       where name like 'J_rg%');

-- Removing '?' from Name
update customers_staging
set name = replace(name,'?','')
where name like '%?%';

-- Updating Missing Characters
update customers_staging
set name = regexp_replace(name, '[^A-Za-z ]', 'i', 'g')
where customer_key in (select customer_key
                       from vw_nonstandard_names
                       where name like '%M_ller%');
-- Updating Missing Characters
update customers_staging
set name = regexp_replace(name, '[^A-Za-z ]', 'o', 'g')
where customer_key in (select customer_key
                       from vw_nonstandard_names
                       where name like '%Schr_der');

-- Updating Missing Characters
update customers_staging
set name = regexp_replace(name, '[^A-Za-z ]', 'a', 'g')
where customer_key in (select customer_key
                       from vw_nonstandard_names
                       where name like '%G_rtner');

-- Updating Missing Characters
update customers_staging
set name = regexp_replace(name, '[^A-Za-z ]', 'o', 'g')
where customer_key in (select customer_key
                       from vw_nonstandard_names
                       where name like '%K_n%'
                          or name like '%K_h%');





