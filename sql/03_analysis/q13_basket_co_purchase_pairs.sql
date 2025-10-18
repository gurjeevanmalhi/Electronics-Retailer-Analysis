-- Basket analysis: Identify the most frequently purchased product pairs that appear together
-- in the same customer order to uncover cross-selling opportunities.

-- Create unique product pairs bought together in the same order
with basket as(
    select
        s1.product_key as prod_a,
        s2.product_key as prod_b,
        count(*) as frequency
    from sales s1
    inner join sales s2 on s1.order_number = s2.order_number
    where s1.line_item > 1
      and s1.product_key < s2.product_key
    group by 1,2
    order by 3 desc)

-- Returns top-selling product pairs and product names
select
    p1.product_name as prod_name_a,
    p2.product_name as prod_name_b,
    b.frequency
from basket b
left join products p1 on p1.product_key = b.prod_a
left join products p2 on p2.product_key = b.prod_b
where b.frequency = (select max(frequency) from basket);