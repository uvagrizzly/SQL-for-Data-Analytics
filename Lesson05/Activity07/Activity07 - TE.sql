-- Activity 07 page 140

--2. Calculate total sales amount by day for all of the days in the year 2018 (that is before Jan 1, 2019)

--sales per day for the year 2018


    SELECT sales_transaction_date::DATE as date, sum(sales_amount) as daily_sales
    from sales
    where sales_transaction_date >= '2018-01-01'
        AND sales_transaction_date < '2019-01-01'
    group by date
    order by date;


--3. Calculate the rolling 30-day average for the daily number of sales deals.

with daily_deals as (
    SELECT sales_transaction_date::DATE,
           count(*) as total_deals
    from sales
   -- move where clauses down from here, as filtering here shortens the data to limit the first month
   -- could leave here and expand to cover 30+ days prior in 2017
   -- where sales_transaction_date >= '2018-01-01'
   --   AND sales_transaction_date < '2019-01-01'
    group by 1
    ),

rolling_average_calculation_30 as (
    select sales_transaction_date,
           total_deals,
        avg(total_deals) over(order by sales_transaction_date rows between 30 preceding and current row) as deals_rolling_avg,
        ROW_NUMBER() over (order by sales_transaction_date) as row_number
    from daily_deals
    order by sales_transaction_date
    )

Select sales_transaction_date,
    Case when row_number >= 30 then deals_rolling_avg else null end
    as deals_moving_average_30
from rolling_average_calculation_30
where sales_transaction_date >= '2018-01-01'
      AND sales_transaction_date < '2019-01-01';


--4. Calculate what decile each dealership would be in compared to other dealerships based on their total sales amount.

--get total sales per dealership
with total_dealership_sales as
     (
         select dealership_id, sum(sales_amount) as total_sales
         from sales
         where sales_transaction_date >= '2018-01-01'
           AND sales_transaction_date < '2019-01-01'
           AND channel = 'dealership'
         group by 1
         order by 2 desc
     )
--calculate deciles and rank
Select *,
ntile(10) over (order by total_sales) as decile
from total_dealership_sales
;