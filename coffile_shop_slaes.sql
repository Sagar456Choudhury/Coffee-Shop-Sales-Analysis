select * from coffee_shop_sales;

update coffee_shop_sales
set transaction_date = str_to_date(transaction_date,'%d-%m-%Y');

alter table coffee_shop_sales
modify column transaction_date date;

update coffee_shop_sales
set transaction_time = str_to_date(transaction_time,'%H:%i:%s');

alter table coffee_shop_sales
modify column transaction_time time;

ALTER TABLE coffee_shop_sales
CHANGE COLUMN `ï»¿transaction_id` `transaction_id` INT NOT NULL ,
ADD PRIMARY KEY (`transaction_id`);

select round(sum(unit_price * transaction_qty),1) as total_Sales
from coffee_shop_sales 
where month(transaction_date) = 5; 


select round(sum(unit_price * transaction_qty),1) as total_Sales
from coffee_shop_sales 
where month(transaction_date) = 3; 

select
 month(transaction_date) as month,
 round(sum(unit_price * transaction_qty)) as total_sales,
 (sum(unit_price * transaction_qty) - lag(sum(unit_price * transaction_qty),1)
 over (order by month(transaction_date)))/ lag (sum(unit_price * transaction_qty),1)
 over (order by month(transaction_date)) * 100 as mom_increase_percentage
 from 
  coffee_shop_sales
  where
  month(transaction_date) in (4,5)
  group by
  month(transaction_date)
  order by 
  month(transaction_date);
  
  select count(transaction_id) as total_orders
  from coffee_shop_sales where month(transaction_date) =5;
  
select
 month(transaction_date) as month,
 round(count(transaction_id)) as total_orders,
 (count(transaction_id) - lag(count(transaction_id),1)
 over (order by month(transaction_date)))/ lag (count(transaction_id),1)
 over (order by month(transaction_date)) * 100 as mom_increase_percentage
 from 
  coffee_shop_sales
  where
  month(transaction_date) in (4,5)
  group by
  month(transaction_date)
  order by 
  month(transaction_date);

select sum(transaction_qty) as Total_Quantity_Sold
from coffee_shop_sales
where month(transaction_date)= 5;

select
 month(transaction_date) as month,
 round(sum(transaction_qty)) as total_orders,
 (sum(transaction_qty) - lag(sum(transaction_qty),1)
 over (order by month(transaction_date)))/ lag (sum(transaction_qty),1)
 over (order by month(transaction_date)) * 100 as mom_increase_percentage
 from 
  coffee_shop_sales
  where
  month(transaction_date) in (4,5)
  group by
  month(transaction_date)
  order by 
  month(transaction_date);

select 
	concat(round(sum(unit_price * transaction_qty)/1000,1), 'K') as total_sales,
    concat(round(sum(transaction_qty)/1000,1), 'K') as Total_Quantity_Sold,
    concat(round(count(transaction_id)/1000,1), 'K') as total_orders
from coffee_shop_sales 
where transaction_date = '2023-05-18';

select
	case when dayofweek(transaction_date) in (1,7) then 'weekends'
    else 'weekdays'
    end as day_type,
    concat(round(sum(unit_price * transaction_qty)/1000,1),'K') as Total_sales
    from coffee_shop_sales 
    where month(transaction_date) = 5
group by 
	case when dayofweek(transaction_date) in (1,7) then 'weekends'
    else 'weekdays'
    end;

select store_location,
concat(round(sum(unit_price * transaction_qty)/1000,2),'K') as total_sales
from coffee_shop_sales
where month(transaction_date) = 5
group by store_location
order by sum(unit_price * transaction_qty) desc;

select
	concat(round(avg(total_sales)/1000,2),'K') as avg_sales
from 
	(select sum(unit_price * transaction_qty) as total_sales
    from coffee_shop_sales
    where month(transaction_date) = 5
	group by transaction_date)
    as inner_querry;

select 
	day(transaction_date) as day_of_month,
    concat(round(sum(unit_price * transaction_qty)/1000,1),'K') as total_sales
from coffee_shop_sales
where month(transaction_date) =5 
group by day(transaction_date)
order by day(transaction_date);

select 
	day_of_month,
    case 
		when total_sales > avg_sales then 'Above Average'
        when total_sales < avg_sales then 'Below Average'
        else 'Equal to Avg'
        end as sales_status,
        total_sales
from(
	select 
    day(transaction_date) as day_of_month,
    concat(round(sum(unit_price * transaction_qty)/1000,2),'K') as total_sales,
    avg(sum(unit_price * transaction_qty)) over() as avg_sales
    from coffee_shop_sales
    where month(transaction_date) = 5
    group by day(transaction_date))
as sales_data
order by day_of_month;

select 
	product_category,
    concat(round(sum(unit_price * transaction_qty)/1000,1),'K') as total_sales
from coffee_shop_sales
where month(transaction_date) = 5
group by product_category
order by sum(unit_price * transaction_qty) desc ;
    
select 
	product_type,
    concat(round(sum(unit_price * transaction_qty)/1000,1),'K') as total_sales
from coffee_shop_sales
where month(transaction_date) = 5
group by product_type
order by sum(unit_price * transaction_qty) desc limit 10;

select 
	product_type,
    concat(round(sum(unit_price * transaction_qty)/1000,1),'K') as total_sales
from coffee_shop_sales
where month(transaction_date) = 5 and product_category = 'coffee'
group by product_type
order by sum(unit_price * transaction_qty) desc limit 10;

select 
	concat(round(sum(unit_price * transaction_qty)/1000,1),'K') as total_sales,
	sum(transaction_qty) as Total_qty_sold,
    count(*) as total_orders
from coffee_shop_sales 
where month(transaction_date) = 5
and dayofweek(transaction_date) = 2
and hour(transaction_time) = 8;

select 
	 hour(transaction_time),
     concat(round(sum(unit_price * transaction_qty)/1000,1),'K') as total_sales
from coffee_shop_sales
where month(transaction_date) = 5
group by hour(transaction_time)
order by hour(transaction_time);

select 
	 case 
	when dayofweek(transaction_date) = 2 then 'Monday'
    when dayofweek(transaction_date) = 3 then 'Tuesday'
    when dayofweek(transaction_date) = 4 then 'Wednesday'
    when dayofweek(transaction_date) = 5 then 'Thusday'
    when dayofweek(transaction_date) = 6 then 'Friday'
    when dayofweek(transaction_date) = 7 then 'Saturday'
    else 'Sunday'
    end as Day_of_week,
    concat(round(sum(unit_price * transaction_qty)/1000,1),'K') as total_sales
from coffee_shop_sales
where month(transaction_date) = 5 
group by 
	 case 
	when dayofweek(transaction_date) = 2 then 'Monday'
    when dayofweek(transaction_date) = 3 then 'Tuesday'
    when dayofweek(transaction_date) = 4 then 'Wednesday'
    when dayofweek(transaction_date) = 5 then 'Thusday'
    when dayofweek(transaction_date) = 6 then 'Friday'
    when dayofweek(transaction_date) = 7 then 'Saturday'
    else 'Sunday'
    end;
    
    
    
    

-- Sales Trends Over Time:
select 
    date(transaction_date) as date, 
    round(sum(unit_price * transaction_qty), 1) as total_sales
from coffee_shop_sales
group by date
order by date;

-- Product Performance Analysis
select 
    product_type,
    round(sum(unit_price * transaction_qty), 1) as total_sales,
    sum(transaction_qty) as total_quantity_sold
from coffee_shop_sales
group by product_type
order by total_sales desc
limit 10;

-- Profitability Analysis
select 
    product_type,
    round(sum(unit_price * transaction_qty), 1) as total_sales,
    round(sum(unit_price * transaction_qty) * 0.6, 1) as total_cost,
    round(sum(unit_price * transaction_qty) - sum(unit_price * transaction_qty) * 0.6, 1) as total_profit,
    round((sum(unit_price * transaction_qty) - sum(unit_price * transaction_qty) * 0.6) / sum(unit_price * transaction_qty) * 100, 2) as profit_margin
from coffee_shop_sales
group by product_type
order by total_profit desc;

-- Time-Based Performance
select 
    hour(transaction_time) as hour_of_day,
    round(sum(unit_price * transaction_qty), 1) as total_sales
from coffee_shop_sales
group by hour_of_day
order by hour_of_day;

-- seasonal Impact
select 
    month(transaction_date) as month,
    round(sum(unit_price * transaction_qty), 1) as total_sales,
    count(transaction_id) as total_orders
from coffee_shop_sales
group by month
order by month;

-- Common Table Expressions (CTEs) MoM sales increase
with monthly_sales as (
    select 
        month(transaction_date) as month,
        round(sum(unit_price * transaction_qty), 1) as total_sales
    from coffee_shop_sales
    group by month
)
select 
    month,
    total_sales,
    lag(total_sales, 1) over (order by month) as previous_month_sales,
    (total_sales - lag(total_sales, 1) over (order by month)) / lag(total_sales, 1) over (order by month) * 100 as mom_increase_percentage
from monthly_sales;





	

























































