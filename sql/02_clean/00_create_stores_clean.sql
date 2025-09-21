-- Created clean table
create table stores
(
    store_key     smallint primary key,
    country       text,
    state         text,
    square_meters int,
    open_date     date
);