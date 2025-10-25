-- Who are the top customers by lifetime revenue and what are their latest purchase dates?

-- Finds most recent order per customer
with max_order_date as (select
                            customer_key,
                            max(order_date) as max_dt
                        from sales
                        group by 1)
-- Computes lifetime revenue per customer
-- Returns the top 10 customers by revenue with latest order date
select
    c.first_name || ' ' || c.last_name as customer_name,
    c.country,
    md.max_dt,
    (round(sum(p.unit_price_usd * s.quantity * fr.fx_rate), 2)) as lifetime_revenue
from sales s
         left join customers c on s.customer_key = c.customer_key
         left join products p on s.product_key = p.product_key
         left join fx_rates fr on s.fx_key = fr.fx_key
         left join max_order_date as md on s.customer_key = md.customer_key
group by 1, 2, 3
order by 4 desc
limit 10;


