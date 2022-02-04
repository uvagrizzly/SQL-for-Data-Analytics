SELECT username
FROM salespeople
WHERE gender= 'Female'
ORDER BY hire_date
LIMIT 10;



-- exploratory join work - TE

select sp.first_name, sp.last_name, sp.hire_date, d.dealership_id, d.city, d.state

from salespeople as sp
join dealerships as d
on sp.dealership_id = d.dealership_id

order by d.dealership_id, sp.hire_date
;

--sales by dealership and product

select d.city, p.model, sum(s.sales_amount)::integer as total_sales
from dealerships as d
join sales as s
    on d.dealership_id = s.dealership_id
join products as p
    on p.product_id = s.product_id
group by d.city, p.model
order by p.model, d.city
;

select d.city, p.model, sum(s.sales_amount)::integer as total_sales
from dealerships as d

