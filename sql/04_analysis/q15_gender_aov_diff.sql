-- Does AOV (average order value) differ by gender and does that gap change over time?

-- Finds average order value by gender for each year
with aov_data as(
    select
        c.gender,
        extract(year from s.order_date) as year,
        sum(s.quantity * p.unit_price_usd * fr.fx_rate)
            / count(distinct s.order_number) as aov
    from sales s
    left join customers c on s.customer_key = c.customer_key
    left join products p on s.product_key = p.product_key
    left join fx_rates fr on s.fx_key = fr.fx_key
    group by 1,2
    order by 2 desc),

-- Summarizes data into pivot
aov_pivot as(
    select
        year,
        sum(case when gender = 'Female' then aov end) as female,
        sum(case when gender = 'Male' then aov end) as male
    from aov_data
    group by 1
    order by 1 desc),

-- Calculates AOV difference for genders
aov_gap as(
    select
        *,
        abs(female - male) as gap
    from aov_pivot)

-- Finds AOV gap percent change over time
select
    *,
    round(((gap / lead(gap) over() - 1)* 100.0),2) as change_pct
from aov_gap;

