-- Which stores are most productive by revenue per square meter?**

select s.store_key,
       st.state,
       st.country,
       round(sum((s.quantity * p.unit_price_usd * f.fx_rate)) / sum(st.square_meters),2) as rev_per_sqm
from sales s
         left join products p on s.product_key = p.product_key
         left join fx_rates f on s.fx_key = f.fx_key
         left join stores st on s.store_key = st.store_key
where st.square_meters is not null
group by 1, 2, 3
order by 4 desc;

