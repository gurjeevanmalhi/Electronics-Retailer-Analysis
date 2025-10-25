-- For each customer’s first-purchase month, calculate the number of active customers (unique purchasers)
-- for each month up to 6 months after their first purchase.

-- Identify each customer's first purchase month
with first_order as(
    select
        customer_key,
        min(order_date) as first_order_date,
        extract(month from min(order_date)) as cohort_month
    from sales
    group by 1),

-- Calculate how many months since each customer's first purchase
order_dates as(
    select
        s.customer_key,
        extract(month from s.order_date) as order_month,
        fo.cohort_month,
        extract(year from s.order_date) * 12 +
               extract(month from s.order_date) -
               (extract(year from fo.first_order_date) * 12 +
                extract(month from fo.first_order_date)) as months_since_first
    from sales s
    join first_order fo on s.customer_key = fo.customer_key),

-- Count unique active customers for each month within 6 months after cohort start
cohort_activity as(
    select
        cohort_month,
        months_since_first,
        count(distinct customer_key) as active_customers
    from order_dates
    where months_since_first between 0 and 6
    group by 1,2)

-- View active customers by cohort and months since first purchase
select *
from cohort_activity
order by 1,2;