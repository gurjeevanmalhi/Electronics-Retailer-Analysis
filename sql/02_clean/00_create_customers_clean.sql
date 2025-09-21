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
