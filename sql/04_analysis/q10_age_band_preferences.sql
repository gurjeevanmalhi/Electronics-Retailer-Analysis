-- Which age bands (derived from Birthday) buy which categories most (units)?

-- Finds customer age and product category for each transaction
with age_data as(
    select
        extract(year from age(s.order_date,c.birthdate)) as age,
        c2.category
    from sales s
    left join customers c on s.customer_key = c.customer_key
    left join products p on s.product_key = p.product_key
    left join categories c2 on p.category_key = c2.category_key),

-- Groups age bands by category and calculates units sold
age_cat as(
    select
        case
            when age < 18 then '<18'
            when age between 18 and 24 then '18-24'
            when age between 25 and 34 then '25-34'
            when age between 35 and 44 then '35-44'
            when age between 45 and 54 then '45-54'
            when age between 55 and 64 then '55-64'
        else '65+'
        end as age_band,
        category,
        count(*) as units_sold
    from age_data
    group by 1,2),

-- Ranks product categories by units sold for each age band
ranked as(
    select
        age_band,
        category,
        units_sold,
        dense_rank() over(
            partition by age_band
            order by units_sold desc
            ) as rank
    from age_cat
    order by 1,3 desc)

-- Returns top product category by units sold for each age band
select *
from ranked
where rank = 1;

