use sql_project_p2;

select * from retail_sales limit 2000;

select *from retail_sales where age is null;

select * from retail_sales 
where transaction_id is null 
	or sales_date is null
    or sales_time is null
    or customer_id is null
    or gender is null
    or age is null
    or category is null
    or sales_date is null
    or quantity is null
    or price_per_unit is null
    or cogs is null
    or total_sales is null;
    
    select * from retail_sales where transaction_id=679;
    
    -- delete null rows 
    DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

select count(distinct transaction_id) from retail_sales;

-- unique category 
select distinct category from retail_sales;

-- ------------------------------------------------

SELECT DISTINCT category FROM retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17) --

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05' order by transaction_id;

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    sale_date between '2022-11-01' AND '2022-11-30'
    AND
    quantity >= 4;
    

select * 
from retail_sales 
	WHERE 
    category = 'Clothing'
    AND 
    date_format(sale_date,'%Y-%m')= '2022-11'
    AND
    quantity >= 4;


select sale_date,sum(quantity) as x from retail_sales where category='Clothing' and 
sale_date between '2022-11-01' AND '2022-11-30'  group by sale_date having x>=10 order by sale_date ;
;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category,sum(total_sale) total_sale,count(*) total_sale 
from retail_sales 
group by category 
order by 2;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age),2) avg_age,category
from retail_sales 
where category='Beauty' ;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category,gender,count(transaction_id) transactions 
from retail_sales 
group by category, gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
	
with ranks_tbl as(    
    select year(sale_date),
	month(sale_date),
	avg(total_sale)avgSales ,
	dense_rank() over(partition by year(sale_date) order by avg(total_sale) desc ) ranks
	from retail_sales 
	group by 
		year(sale_date),
		month(sale_date) 
	order by 
		year(sale_date),
        ranks)
    select * 
    from ranks_tbl where ranks=1;
    
    
  -- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
  select customer_id,sum(total_sale) 
  from retail_sales
  group by customer_id 
  order by 2 desc limit 5;
  
  
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category,count(distinct(customer_id)) unnique_customers 
from retail_sales 
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17) 

with shifts_tbl AS(
select transaction_id,case
	when time_format(sale_time,"%H")<12 then 'Morning' 
    when (time_format(sale_time,"%H")>=12 and time_format(sale_time,"%H") <=17 ) then 'Afternoon' 
    else 'Evening' end as shift
from retail_sales )
select shift,count(transaction_id) num_of_transactions
from shifts_tbl group by shift;

select time_format(sale_time,"%H") from retail_sales where transaction_id=2;