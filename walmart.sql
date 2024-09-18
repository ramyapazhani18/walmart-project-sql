create database Walmartsalesdata
use Walmartsalesdata


select * from sales

-- time of the day

select
time,
case when time between '00:00:00' and '12:00:00' then 'Morning'
when time between '12:01:00' and '16:00:00' then 'Afternoon'
else 'Evening'
end as time_of_the_day
from sales

alter table sales add time_of_the_day varchar(20)

update sales
set time_of_the_day =
case when time between '00:00:00' and '12:00:00' then 'Morning'
when time between '12:01:00' and '16:00:00' then 'Afternoon'
else 'Evening'
end      

-- Add day column

alter table sales
add day_name varchar(20)

update sales
set day_name = DATENAME(dw, date) 

--month_name
alter table sales
add month_name varchar(20)

update sales
set month_name = datename(month,date)
select * from sales

--How many unique cities does the data have?

select count(distinct city) from sales

--In which city is each branch?

select distinct city,branch from sales

--How many unique product lines does the data have?

select distinct product_line from sales

--What is the most common payment method?

select
	top 1 payment,count(payment) 
from
	sales
group by
	payment
order by 
	count(payment) desc

--What is the most selling product line?


select top 1product_line,sum(total) as amount
from
	sales
group by
	product_line
order by 
	amount desc

--What is the total revenue by month?

select * from sales

select 
	month_name,sum(total) as total
from 
	sales 
group by 
	month_name
order by
	month_name desc


--What month had the largest COGS?

select
	top 1 month_name,sum(cogs) as total_amount
from
	sales
group by
	month_name
order by
	total_amount desc
	
select * from sales

--What product line had the largest revenue?

select top 1 product_line,sum(total) as total_amount from sales group by product_line order by total_amount  desc

--What is the city with the largest revenue

select top 1 city,
		 sum(total) as largest_revenue
from 
	sales
group by
	city
order by 
	largest_revenue desc

--What product line had the largest VAT?
select * from sales

select top 1 Product_line, 
	sum(VAT) as largest_VAT
from sales 
group by product_line
order by largest_VAT desc

--Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

select product_line from sales where product_line > (select product_line,avg(total) as average
from sales
group by
	product_line)

--Which branch sold more products than average product sold?


select branch,sum(quantity)
from sales
group by branch having sum(quantity) > (select avg(total_quantity) from (select sum(quantity) as total_quantity from sales group by branch) as a );

--What is the most common product line by gender


WITH GenderProductLineCount AS (
    SELECT gender, product_line, COUNT(*) AS count
    FROM sales
    GROUP BY gender, product_line
),
MaxGenderProductLineCount AS (
    SELECT gender, MAX(count) AS max_count
    FROM GenderProductLineCount
    GROUP BY gender
)
SELECT gplc.gender, gplc.product_line, gplc.count
FROM GenderProductLineCount gplc
JOIN MaxGenderProductLineCount mgplc
    ON gplc.gender = mgplc.gender AND gplc.count = mgplc.max_count;

--What is the average rating of each product line?

select product_line, avg(rating) as avg_rating
from
	sales
group by
	product_line

--Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

select product_line,avg(total),
	case when sum(total) > avg(total) then 'Good'
	else 'bad'
	end
	from sales 
	group by

--Number of sales made in each time of the day per weekday


select time_of_the_day, day_name, sum(total) as total_sales
from sales where day_name <> 'saturday' and day_name <> 'sunday' group by time_of_the_day,day_name order by day_name

--Which of the customer types brings the most revenue

select top 1 customer_type,sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc

--Which city has the largest tax percent/ VAT (Value Added Tax)

select top 1 city,
	max(vat) as VAT 
from 
	sales
group by 
	city
order by 
	vat desc

--Which customer type pays the most in VAT?

select customer_type, sum(vat) as vat 
from sales 
group by customer_type
order by vat desc

--How many unique customer types does the data have?

select 
	count (distinct customer_type) as customer_type
from
	sales

--What is the most common customer type

select
	top 1 with ties customer_type, count(customer_type) as counts
from
	Sales
group by
	customer_type
order by 
	counts desc

--Which customer type buys the most

select top 1 customer_type,sum(quantity) as product_sold
from sales 
group by customer_type 
order by product_sold desc

--What is the gender of most of the customers

select  
 top 1 gender,count(Quantity) as customers_count
from
sales
group by gender
order by customers_count desc

--What is the gender distribution per branch


select branch,count(gender) as gender_counts,
case when gender = 'Male' then 'M'
when gender = 'Female' then 'f'
end as gender
from sales
group by gender,branch
order by branch

--Which time of the day do customers give most ratings

select count(rating) as rating_count,
time_of_the_day 
from sales
group by time_of_the_day

--Which time of the day do customers give most ratings per branch?

select max(rating_count) as max_count,branch 
from (
select count(rating) as rating_count,branch,
time_of_the_day 
from sales
group by time_of_the_day,branch) as a
group by branch

--Which day fo the week has the best avg ratings

select day_name,avg(rating) as rating
from sales
group by day_name
order by rating desc 

--Which day of the week has the best average ratings per branch?
select  max(rating) as rating,branch,day_name
from
(select day_name, avg(rating) as rating,branch
from sales
group by day_name,branch ) as a
group by branch,day_name

