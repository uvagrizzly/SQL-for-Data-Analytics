-- Activity06 page 119

--2. Calculate the total number of unit sales the company has done
select * from sales;

select count(*) from sales;


--3. Calculate the total sales amount in dollars for each state.
-- i first setup using dealerships to show total sales per dealership state
select d.state, sum(s.sales_amount) as total_sales_amount
from sales s
join dealerships d on s.dealership_id = d.dealership_id
group by 1
order by 1
;
        -- this is only getting dealership sales and misses internet sales
        select channel, count(*)
        from sales
        group by 1
        order by 2
        ;

                --checking dealership per state count
                select state, count(*)
                from dealerships
                group by 1
                order by 1
                ;
                --checking customer per state count
                select state, count(*)
                from customers
                group by 1
                order by 1
                ;

-- answer shows by customer and not reflecting dealership perspective
-- (results are different from dealerships as this picks up internet sales)
select c.state, sum(s.sales_amount) as total_sales_amount
from sales s
join customers c on s.customer_id = c.customer_id
group by 1
order by 1
;


--4. Identify the top five best dealerships in terms of the most units sold (ignore internet sales)
-- checking channel values
select distinct channel from sales;

select s.dealership_id, count(*)
from sales s
    --join dealerships d on s.dealership_id = d. dealership_id --(not needed)
where s.channel <> 'internet'  -- could also use = 'dealership' as in this case, these are the only 2 values
group by 1
order by 2 desc
limit 5
;

--5. Calculate the average sales amount for each channel, as seen in the sales table, and
-- look at the average sales amount first by channel sales,
-- then by product_id and
-- then by both together

select s.channel, s.product_id, avg (sales_amount) as avg_sales_amount

from sales s
group by
    grouping sets (
                    (s.channel),
                    (s.product_id),
                    (s.channel, s.product_id)
    )
order by 1,2
;


