-- Currency exposure: share of orders and revenue by currency, FX-adjusted to USD.

-- Calculates total orders and total revenue for each currency
with currency as(
    select
        s.currency_code as currency,
        count(*) as total_orders,
        sum(s.quantity * p.unit_price_usd * fr.fx_rate) as revenue_usd
    from sales s
    left join products p on s.product_key = p.product_key
    left join fx_rates fr on s.fx_key = fr.fx_key
    group by 1),

-- Calculates order share % and revenue share % for each currency
rev_share as(
    select
        currency,
        round(total_orders * 100.0 /
              sum(total_orders) over(),2) as order_share,
        round(revenue_usd * 100.0 /
              sum(revenue_usd) over(),2) as revenue_share
    from currency)

-- Returns order share, revenue share, and average exchange rate for each currency
select
    r.currency,
    r.order_share,
    r.revenue_share,
    round(avg(fr.fx_rate),2) as avg_fx_rate
from rev_share r
left join fx_rates fr on r.currency = fr.currency_code
group by 1,2,3
order by 3 desc;





