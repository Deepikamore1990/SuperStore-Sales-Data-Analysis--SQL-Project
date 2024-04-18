CREATE DATABASE IF NOT EXISTS Walmart;

USE Walmart;

CREATE TABLE Sales(
Invoice_Id VARCHAR(30) NOT NULL PRIMARY KEY,
Branch VARCHAR(5) NOT NULL,
City VARCHAR(30) NOT NULL,
Customer_type VARCHAR(30) NOT NULL,
Gender VARCHAR(10) NOT NULL,
Product_Line VARCHAR(100) NOT NULL,
Unit_Price DECIMAL(10,2) NOT NULL,
Quantity INT(20) NOT NULL,
GST FLOAT(6,2) NOT NULL,
Total DECIMAL(12, 2) NOT NULL,
Date DATE NOT NULL,
Time TIME NOT NULL,
Payment VARCHAR(15) NOT NULL,
Cogs DECIMAL(10,2) NOT NULL,
Gross_Margin_Percentage FLOAT(11,2),
Gross_Income DECIMAL(12, 2),
Rating FLOAT(2, 1)
);

select * from sales;

##------------------- Feature extraction -------------------------##

## Time of Day ##
select Case
when Time(time) between '00:00:00' and '12:00:00' then 'Morning'
when Time(time) between '12:01:00' and '16:00:00' then 'Afternoon'
else 'Evening'
end as time_of_day 
from Sales;

Alter table Sales add column Time_of_Day varchar (30) not null;

UPDATE sales
SET time_of_day =
	CASE 
		WHEN Time(time) BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN Time(time) BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening" 
	END;
    
    ## Month Name##
    Select Monthname(date) as Month_name from sales;
    
    Alter table sales add column Month_name varchar(30) not null;
    
    update sales
    set Month_name = Monthname(date);
    
    ## Day Name ##
    
    Select Dayname (date) as Day_name from sales;
    
    Alter table sales add column Day_name varchar (30) not null;
    
    Update sales
    set Day_name = Dayname(date);
    
    ##----------------Exploratory Data Analysis (EDA)----------------------##
## Generic Questions
# 1.How many distinct cities are present in the dataset?
Select Distinct city from sales;

# 2.In which city is each branch situated?
Select Distinct Branch, City from Sales;

# Product Analysis
# 1.How many distinct product lines are there in the dataset? 
Select Count(Distinct Product_Line) from Sales;

# 2.What is the most common payment method?
Select Payment, Count(Payment) as Common_Payment_Method
From Sales
Group By Payment
Order By Common_Payment_Method desc;

# 3.What is the most selling product line? 
Select Product_Line, Count(Product_Line) as Selling_Product_Line
From Sales
Group By Product_Line
Order By Selling_Product_Line desc;

# 4.What is the total revenue by month?
Select Month_name, Sum(total) As Total_Revenue_by_Month
From Sales
Group By Month_Name
Order by Total_revenue_By_Month desc;

# 5.Which month recorded the highest Cost of Goods Sold (COGS)?
Select Month_Name, Sum(COGS) As Highest_COGS
From Sales
Group By Month_Name
Order By Highest_COGS Desc;

# 6.Which product line generated the highest revenue?
Select Product_Line, Sum(Total) as Highest_revenue
from Sales
Group By Product_line
Order By Highest_revenue desc
limit 1;

# 7.Which city has the highest revenue?
Select City, Sum(Total) as Highest_Revenue
From Sales
Group By City
Order By Highest_Revenue
Limit 1;

# 8.Which product line incurred the highest GST?
Select Product_line, Sum(GST) as GST
From Sales
Group By Product_line
order by GST Desc
Limit 1;

# 9.Which branch sold more products than average product sold?
Select Branch, Sum(quantity) as Quantity
From Sales
group by Branch
Having sum(Quantity)> Avg(Quantity)
Order By Quantity Desc;

# 10.What is the most common product line by gender?
Select Gender, Product_Line, Count(Gender) as Total_Gender 
From Sales
Group By Gender, Product_line
Order By Total_Gender
Limit 1;

# 11.What is the average rating of each product line?
Select Product_line, Avg(Rating)  As Avg_rating
From Sales
Group By Product_line
Order By Avg_rating desc;

#  Sales Analysis #
# 1.Number of sales made in each time of the day per weekday
Select Day_name, time_of_day, count(invoice_ID) as Total_Sales
From Sales
Group By Day_name, Time_of_Day
Having Day_Name not in ('Saturday', 'Sunday');

# 2.Identify the customer type that generates the highest revenue.
Select Customer_Type, Sum(Total) as Total_Revenue
From Sales
Group By Customer_type
Order By Total_Revenue Desc
Limit 1;

# 3.Which city has the largest tax percent/ GST ?
Select City, Sum(GST) GST
From Sales
Group By City
Order By GST Desc
Limit 1;

# 4.Which customer type pays the most in GST?
Select Customer_Type, Sum(GST) As GST
From Sales
Group By Customer_type
Order By GST Desc
limit 1;

# Customer Analysis #

# 1.How many unique customer types does the data have?
Select Customer_Type, Count(Customer_Type) as Count from Sales
Group By Customer_Type;

SELECT COUNT(DISTINCT Customer_Type) FROM Sales;

# 2.How many unique payment methods does the data have?
Select Payment, Count(Payment) as Payment_Method 
From Sales
Group By Payment;

Select count(Distinct payment) from Sales;

# 3.Which is the most common customer type?
Select Customer_Type, Count(Customer_Type) As Common_Customer_Type
From Sales
Group By Customer_type
Order By Common_Customer_Type Desc
Limit 1;

# 4.Which customer type buys the most?
Select Customer_Type, Count(Total) as Most_buyer
From Sales
Group By Customer_Type
Order By Most_buyer Desc
Limit 1;

# 5.What is the gender of most of the customers?
Select Gender, Count(*) as All_Gender
From Sales
Group By Gender
Order by All_Gender Desc
Limit 1;

# 6.What is the gender distribution per branch?
Select Branch, gender, Count(Gender) as Gender_Distribution
From Sales
Group By Branch, Gender
Order By Gender_Distribution desc;

# 7.Which time of the day do customers give most ratings?
Select Time_of_day, Avg(Rating) as Rating
From Sales
Group By Time_Of_Day
Order by Rating Desc
Limit 1;

# 8.Which time of the day do customers give most ratings per branch?
Select Time_of_day, Branch, Avg(Rating) as rating
From Sales
Group By Branch, Time_of_day
Order By Rating desc;

# 9.Which day of the week has the best avg ratings?
Select Day_Name, Avg(Rating) as Rating
FROM sales 
GROUP BY day_name 
ORDER BY rating DESC 
LIMIT 1;

# 10.Which day of the week has the best average ratings per branch?
Select Day_name, Branch, Avg(rating) as Rating
From Sales
Group By Day_Name, Branch
Order By Rating Desc;