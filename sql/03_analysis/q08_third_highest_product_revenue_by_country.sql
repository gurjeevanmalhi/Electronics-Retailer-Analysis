-- Which products had the 3rd highest total sales revenue in each country last year?
with prev_yr as(
    select max(extract(year from order_date)) - 1 as prior_yr
    from sales),

sales_usd as(
    select
        extract(year from s.order_date) as year,
        st.country,
        p.product_name,
        sum(s.quantity * p.unit_price_usd * fr.fx_rate) as sales_usd
    from sales s
    left join stores st on s.store_key = st.store_key
    left join products p on s.product_key = p.product_key
    left join fx_rates fr on s.fx_key = fr.fx_key
    left join prev_yr py on extract(year from s.order_date) = py.prior_yr
    where extract(year from s.order_date) = prior_yr
    group by 1,2,3
    order by 1,2,4 desc),

ranked as(
    select
        *,
        dense_rank() over (
            partition by country order by sales_usd desc) as ranked
from sales_usd)

select *
from ranked
where ranked = 3;