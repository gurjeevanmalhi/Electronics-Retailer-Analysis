-- Creating clean fx_rate table
create table fx_rates
(
    fx_date  date,
    currency varchar(3),
    fx_rate  decimal(5, 4)
);
