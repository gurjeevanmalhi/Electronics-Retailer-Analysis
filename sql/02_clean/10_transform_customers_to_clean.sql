-- Previewing Table
select *
from customers_staging;

-- 15,266 Total Records
select count(*)
from customers_staging;

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

-- Normalize accented characters in customer names to plain ASCII letters
update customers_staging
set name = initcap(translate(name,
                             'áàâäãåÁÀÂÄÃÅéèêëÉÈÊËíìîïÍÌÎÏóòôöõÓÒÔÖÕúùûüÚÙÛÜñÑçÇÿŸ',
                             'aaaaaaAAAAAAeeeeEEEEiiiiIIIIoooooOOOOOuuuuUUUUnNcCyY'));

-- Adding columns for first & last name
alter table customers_staging
    add column first_name varchar(220),
    add column last_name  varchar(220);

-- Splitting first & last names
update customers_staging
set first_name = split_part(name, ' ', 1),
    last_name  = substring(name from position(' ' in name) + 1);

-- Deleting original name column
alter table customers_staging
    drop column name;

-- Creating view for invalid first names
create view invalid_first_names as
select customer_key, first_name, last_name, city, country
from customers_staging
where first_name !~ '^[A-Za-z''-]+$';

-- Cleaning First Names

update customers_staging
set first_name = regexp_replace(first_name, '^J[^A-Za-z]Rg', 'Jurg')
where customer_key in (select customer_key
                       from invalid_first_names
                       where first_name like 'J_Rg%');

update customers_staging
set first_name = substring(first_name from 2)
where customer_key in (select customer_key
                       from invalid_first_names
                       where first_name like '%Leo%');

update customers_staging
set first_name = 'Aaron'
where first_name = 'A‰Ron';

update customers_staging
set first_name = 'Soren'
where customer_key in (select customer_key
                       from invalid_first_names
                       where first_name like '%Ren');

update customers_staging
set first_name = substring(first_name, 2)
where first_name like '%Gatha%';

update customers_staging
set first_name =
        case
            when first_name like 'J_Lia' then 'Julia'
            when first_name like 'Luk%' then 'Luke'
            when first_name like 'J_n' then 'Jan'
            when first_name like 'K_Rsad' then 'Karsed'
            when first_name like 'T_Nia' then 'Tania'
            when first_name like 'Adri_N' then 'Adrien'
            when first_name like '%Heda' then 'Sheda'
            when first_name like 'Ces%' then 'Cesareo'
            when first_name like '%Agla' then 'Agla'
            when first_name like 'G_K%' then 'Gkae'
            when first_name like 'V_Clav' then 'Vclav'
            when first_name like 'Jo%' then 'Joao'
            else first_name
            end
where customer_key in (select customer_key
                       from invalid_first_names);

update customers_staging
set first_name = 'Jan'
where first_name like 'J_N';

update customers_staging
set first_name = 'Ike'
where customer_key = '1982772';

update customers_staging
set first_name = 'E' || substring(first_name from 2)
where customer_key in (select customer_key from invalid_first_names);

------------------------------------------------------------------------------------------------------------------------
-- Last Name Column

-- Creating View for Invalid Last Names
create view invalid_last_names as
select customer_key, last_name
from customers_staging
where last_name !~ '^[A-Za-z'' -]+$';

-- Removing '?' from names
update customers_staging
set last_name = replace(last_name, '?', '');

update customers_staging
set last_name = 'Gartner'
where customer_key in (select customer_key
                       from invalid_last_names
                       where last_name like 'G_Rt%');

------------------------------------------------------------------------------------------------------------------------
-- City

-- 0 Null Values
select count(*) - count(city)
from customers_staging;

update customers_staging
set city = initcap(city);

------------------------------------------------------------------------------------------------------------------------
-- State Code

-- 0 Null Values
select count(*) - count(state_code)
from customers_staging;

------------------------------------------------------------------------------------------------------------------------
-- Zip Code

-- 0 Null Values
select count(*) - count(zip_code)
from customers_staging;

-- Adding leading 0's to US zip codes
update customers_staging
set zip_code = '0' || zip_code
where length(zip_code) = 4
  and country = 'United States';

------------------------------------------------------------------------------------------------------------------------
-- Country

-- 0 Null Values
select count(*) - count(country)
from customers_staging;

------------------------------------------------------------------------------------------------------------------------

-- Continent

select count(*) - count(continent)
from customers_staging;

select distinct continent
from customers_staging;

------------------------------------------------------------------------------------------------------------------------

-- Birthday

select count(*) - count(birthday)
from customers_staging;

update customers_staging
set birthday =
        case
            when birthday::date > current_date
                then ((birthday::date - interval '100 years')::date)::text
            else (birthday::date)::text
            end;
