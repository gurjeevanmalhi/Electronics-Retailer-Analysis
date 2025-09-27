-- Who are the top customers by lifetime revenue, and what’s their latest purchase date?

select c.first_name || ' ' || c.last_name                       as cust_name,
       round(sum(s.quantity * p.unit_price_usd * f.fx_rate), 2) as lifetime_rev_usd,
       max(s.order_date)                                        as last_purchase_date
from sales s
         join customers c on s.customer_key = c.customer_key
         join products p on s.product_key = p.product_key
         join fx_rates f on s.order_date = f.fx_date and s.currency_code = f.currency
group by 1
order by 2 desc;

