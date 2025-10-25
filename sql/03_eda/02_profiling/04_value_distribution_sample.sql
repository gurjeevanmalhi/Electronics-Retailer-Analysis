-- Sample of value distributions (top 10 frequent values per column).
-- Identifies categorical columns and spot skewed data patterns quickly.
-- Works without anyarray casts by routing through JSONB.

select
  s.tablename  as table_name,
  s.attname    as column_name,
  v.value      as most_common_value,
  (f.freq_json)::numeric as frequency
FROM pg_stats s
join lateral jsonb_array_elements_text(to_jsonb(s.most_common_vals)) with ordinality as v(value, ord) on true
join lateral jsonb_array_elements(to_jsonb(s.most_common_freqs))      with ordinality as f(freq_json, ord2)
  on v.ord = f.ord2
where s.schemaname = 'public'
  and s.most_common_vals is not null
order by table_name, column_name, frequency desc
limit 100;
