-- Is there a difference in average order value (AOV) for online vs. in-store sales?

with aov as(
    select
    case
        when s2. country = 'Online' then 'Online'
        else 'In Store'
    end as store_type,
    sum(s.quantity * p.unit_price_usd * fr.fx_rate) /
    count(distinct s.order_number) as aov
from sales s
left join stores s2 on s.store_key = s2.store_key
left join products p on s.product_key = p.product_key
left join fx_rates fr on s.fx_key = fr.fx_key
group by 1
order by 2 desc)

select *
from aov

union all

select
    'Difference' as store_type,
    max(aov) - min(aov) as aov
from aov;


