-- Activity 5 pg 98

--2. join customers to sales
select *
from customers c
join sales s
 on c.customer_id = s.customer_id
;
--3. join products to sales
select *
from products p
join sales s
on p.product_id = s.product_id
;
--4. join dealerships to sales
select *
from dealerships d
join sales s
on d.dealership_id = s.dealership_id
;
--5. return all columns of customers and products
select c.*, p.*
from customers c
join sales s on c.customer_id = s.customer_id
join products p on p.product_id = s.product_id
join dealerships d on d.dealership_id = s.dealership_id
;
--6. return dealiershipid from sales, fill in dealership_id in sales with -1 if its null
select dealership_id from sales;
select coalesce(dealership_id, -1) as dealership_id from sales;

-- was building out each step additively, not sure that was necessary
select c.*, p.*,
       coalesce(s.dealership_id,-1) as dealership_id
from customers c
left join sales s on c.customer_id = s.customer_id
left join products p on p.product_id = s.product_id
left join dealerships d on d.dealership_id = s.dealership_id
;

--7. add column called high_savings that returns 1 if sales amount was 500 less than base_msrp or lower, otherwise returns 0
select c.*, p.*,
       coalesce(s.dealership_id,-1) as dealership_id,
       case when p.base_msrp - s.sales_amount > 500 then 1
        else 0 end
            as high_savings
from sales s
join customers c on c.customer_id = s.customer_id
join products p on p.product_id = s.product_id
left join dealerships d on d.dealership_id = s.dealership_id
;

-- notes
-- from build out step over step, didnt see when/why to change from to sales over customer
-- not clear on needing the one left join for dealerships
-- coalesce and case statements made sense - did have a different math logic, but should have been ok