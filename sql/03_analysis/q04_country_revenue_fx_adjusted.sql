-- Which countries deliver the highest FX-adjusted revenue and YoY growth in 2020?

-- Finds revenue by country for years 2020 and 2019
with revenue as (
    select
        st.country,
        extract(year from s.order_date) as year,
        sum(p.unit_price_usd * s.quantity * fx_rate) as rev_usd
    from sales s
    left join stores st on s.store_key = st.store_key
    left join products p on s.product_key = p.product_key
    left join fx_rates fr on s.fx_key = fr.fx_key
    where extract(year from s.order_date) in (2020, 2019)
    group by 1, 2
    order by 1, 2 desc
),
-- Calculates YoY growth
yoy as (
    select
        *,
        (rev_usd / lead(rev_usd) over (partition by country order by year desc) - 1) * 100 as yoy_growth
    from revenue
)
-- Ranks countries by YoY growth
select
    country,
    yoy_growth,
    rank() over (order by yoy_growth desc) as rank
from yoy
where yoy_growth is not null;



