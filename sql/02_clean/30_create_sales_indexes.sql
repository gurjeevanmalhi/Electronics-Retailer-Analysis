-- Create indexes for retrieval speed
create index indx_sales_customer_key on sales(customer_key);
create index indx_sales_product_key on sales(product_key);
create index indx_sales_store_key on sales(store_key);
create index idx_sales_fx_key on sales(fx_key);

-- Check
select indexname, indexdef
from pg_indexes
where tablename = 'sales';