-- Created table for clean data
create table customers
(
    customer_key int primary key,
    gender       text,
    city         text,
    state_code   text,
    state        text,
    zip_code     text,
    country      text,
    continent    text,
    birthdate    date,
    first_name   text,
    last_name    text
);

-- Inserting cleaning data
insert into customers(customer_key, gender, city, state_code, state, zip_code, country, continent, birthdate,
                      first_name, last_name)
select cast(customer_key as int),
       gender,
       city,
       state_code,
       state,
       zip_code,
       country,
       continent,
       cast(birthday as date),
       first_name,
       last_name
from customers_staging;

-- Dropped staging table
drop table if exists customers_staging;


