-- How did total sales revenue during Black Friday week (Nov 24–30) last year compare to the same week in the previous year?

-- Returns unique years in dataset
with years as(
    select
        distinct extract(year from order_date) as yr
    from sales
    order by 1 desc),

-- Assigns row number to each year
rn as(
    select
        yr,
        row_number() over() as rn
    from years
    order by 1 desc),

-- Filters to prior year and previous year
prior_two_years as(
    select yr
    from rn
    where rn between 2 and 3),

-- Returns all unique dates within defined time period
dates as(
    select distinct order_date
    from sales
    where extract(year from order_date) in (select yr from prior_two_years)
        and extract(month from order_date) = 11
        and extract(day from order_date) between 24 and 30),

-- Calculates revenue for defined time period
sales_usd as(
    select
        extract(year from s.order_date) as year,
        sum(s.quantity * p.unit_price_usd * fr.fx_rate) as revenue
    from sales s
    left join products p on s.product_key = p.product_key
    left join fx_rates fr on s.fx_key = fr.fx_key
    where s.order_date in (select order_date from dates)
    group by 1)

-- Returns revenue and YoY growth
select year,
       revenue,
       round((revenue / lead(revenue) over (
           order by year desc) - 1) * 100,2)
           as yoy_growth_pct
from sales_usd;
