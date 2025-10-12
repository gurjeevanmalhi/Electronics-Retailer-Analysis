--  What is the year-over-year trend in online order delivery times?

-- Finds avg delivery time by year for online orders
with avg_delivery as (
    select st.country,
        extract(year from order_date) as year,
        round(avg(delivery_date - order_date), 2) as avg_del_time
        from sales s
        left join stores st on s.store_key = st.store_key
        where delivery_date is not null
        and country = 'Online' -- only online orders have delivery
        group by 1, 2
        order by year desc)
-- Measures delivery-time variance vs. prior year and net change over time
select
    *,
    (avg_del_time - lead(avg_del_time) over (order by year desc )) as change_pr_yr,
    (first_value(avg_del_time) over (order by year desc rows between unbounded preceding and unbounded following)
    - last_value(avg_del_time) over (order by year desc rows between unbounded preceding and unbounded following)
) as total_change
from avg_delivery;