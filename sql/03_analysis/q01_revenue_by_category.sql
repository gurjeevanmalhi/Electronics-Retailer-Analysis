-- Which product categories drove the most revenue in the last 12 months?

select c.category,
       sum((s.quantity * p.unit_price_usd * f.fx_rate)) as revenue
from sales s
         left join products p
                   on s.product_key = p.product_key
         left join categories c
                   on p.category_key = c.category_key
         left join fx_rates f
                   on s.fx_key = f.fx_key
where s.order_date >= (select max(order_date) - interval '12 months'
                       from sales)
group by 1
order by 2 desc;


