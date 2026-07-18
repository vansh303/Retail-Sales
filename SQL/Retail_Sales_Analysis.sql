CREATE DATABASE retail_analysis;
USE retail_analysis;
-- Busness Queries 
-- 1. Total Transaction 
SELECT COUNT(*) AS total_transaction FROM Retail;
-- 2. Total Revenue  
SELECT SUM(total_amount) AS total_revenue FROM Retail;
-- 3. Average Transaction Value 
SELECT ROUND(AVG(total_amount),2) AS average_transaction_value FROM Retail;
-- 4. Average Product Price
SELECT ROUND(AVG(price_per_unit),2) AS average_product_price FROM Retail;
-- 5. Total Quantity Sold
SELECT SUM(quantity) AS total_quantity FROM Retail;

-- Product Analysis
-- 6. Revenue by Product Category 
SELECT product_category, SUM(total_amount) AS revenue FROM Retail GROUP BY product_category ORDER BY revenue DESC;
-- 7. Quantity Sold by Category
SELECT product_category, SUM(quantity) AS quantity_sold FROM Retail GROUP BY product_category ORDER BY quantity_sold DESC;
-- 8. Average Selling Price
SELECT product_category, ROUND(AVG(price_per_unit),2) AS average_selling FROM Retail GROUP BY product_category ORDER BY average_selling DESC;

-- Customer Analysis
-- 9. Revenue by Gender
SELECT gender, SUM(total_amount) AS revenue FROM Retail GROUP BY gender;
-- 10. Average Spending by Gender
SELECT gender, ROUND(AVG(total_amount),2) AS avg_spending FROM Retail GROUP BY gender;
-- 11. Top 10 Customers
SELECT customer_id, SUM(total_amount) AS total_spent FROM Retail GROUP BY  customer_id ORDER BY total_spent DESC LIMIT 20;
-- 12. Repeat Customers
SELECT customer_id, COUNT(*) AS total_orders FROM Retail GROUP BY customer_id HAVING COUNT(*) > 1 ORDER BY total_orders DESC;

-- Age Analysis
-- 13. Average Spending by Age
SELECT age, ROUND(AVG(total_amount),2) AS total_spend FROM Retail GROUP BY age ORDER BY age;
-- 14. Age Group Analysis
WITH CategorizedRetail AS (
  SELECT 
    customer_id,   
    total_amount,  
    CASE
      WHEN age <= 18 THEN 'Teen'
      WHEN age <= 25 THEN 'Young Adult'
      WHEN age <= 35 THEN 'Adult'
      WHEN age <= 50 THEN 'Middle Age'
      ELSE 'Senior'
    END AS age_group
  FROM Retail
)
SELECT 
  age_group,
  COUNT(*) AS customers,
  SUM(total_amount) AS revenue
FROM CategorizedRetail
GROUP BY age_group
ORDER BY revenue DESC;

-- Time Analysis
-- 15. Monthly Revenue
SELECT MONTHNAME(date) AS month, SUM(total_amount) AS revenue FROM Retail GROUP BY MONTH(date), MONTHNAME(date) ORDER BY MONTH(date);

-- Product Performance
-- 16. Highest Transaction
SELECT * FROM Retail ORDER BY total_amount DESC LIMIT 5;
-- 17. Lowest Transaction
SELECT * FROM Retail ORDER BY total_amount LIMIT 5;
-- 18. Highest Quantity Purchase
SELECT * FROM Retail ORDER BY quantity DESC LIMIT 10;

-- Advanced SQL (Intermediate Level)
-- 19. Revenue Contribution %
SELECT product_category, SUM(total_amount) AS revenue, ROUND(SUM(total_amount)*100/(SUM(SUM(total_amount)) OVER()),2) AS revenue_percentage FROM Retail GROUP BY product_category;
-- 20. Rank Categories
SELECT product_category, SUM(total_amount) AS revenue, RANK() OVER(ORDER BY SUM(total_amount) DESC) AS catgory_rank FROM Retail GROUP BY product_category;
-- 21. Running Revenue
SELECT date, SUM(total_amount) 	AS daily_sales, SUM(SUM(total_amount)) OVER(ORDER BY date) AS running_sales FROM Retail GROUP BY date;
-- 20. Monthly Growth
SELECT
MONTHNAME(date) AS month,
SUM(total_amount) AS sales,
LAG(SUM(total_amount))
OVER(
ORDER BY MONTH(date)
) AS previous_month_sales
FROM Retail
GROUP BY MONTH(date),MONTHNAME(date);
