-- What is the 3-month moving average of total sales revenue?

with sales_usd as (select extract(year from order_date)                   as year,
                          extract(month from s.order_date)                as month,
                          sum(s.quantity * p.unit_price_usd * fr.fx_rate) as total_revenue
                   from sales s
                            left join products p on s.product_key = p.product_key
                            left join fx_rates fr on s.fx_key = fr.fx_key
                   group by 1, 2
                   order by 1, 2)
select year,
       month,
       total_revenue,
       avg(total_revenue) over (
           order by year, month
           rows between 2 preceding and current row) as moving_avg_3
from sales_usd;