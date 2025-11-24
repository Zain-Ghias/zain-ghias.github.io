-- ============================================================
-- Sales Intelligence Analysis (SQL) – Exploratory Insights
-- Author: Zain Aamer Ghias
-- Description: Data validation + analytical queries for revenue, 
--              profit, margin, customer behavior, and product 
--              performance. Prepared for Power BI visualization.
--				(Added insights to my notes)
-- ============================================================

USE sales_intelligence_db;

-- ============================================================
-- 0. DATA VALIDATION CHECKS
-- ============================================================

-- 0.1 Null check for key fields   (All clear)
SELECT 
    SUM(CASE WHEN Revenue IS NULL THEN 1 ELSE 0 END) AS Null_Revenue,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS Null_Profit,
    SUM(CASE WHEN Profit_Margin IS NULL THEN 1 ELSE 0 END) AS Null_Margin,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Null_Date
FROM sales_transactions;

-- 0.2 Check for negative or impossible values (Only -ve Profit and Revenue found)
SELECT *
FROM sales_transactions
WHERE Revenue < 0
   OR Profit < 0
   OR Unit_Price < 0
   OR Unit_Cost < 0;

-- 0.3 Revenue sanity check (Revenue vs Unit_Price * Quantity)  (nothing found)
SELECT 
    COUNT(*) AS Revenue_Mismatches
FROM sales_transactions
WHERE ROUND(Revenue, 2) <> ROUND(Unit_Price * Quantity, 2);

-- 0.4 Date range overview (2015-01-01 ,2016-07-31)
SELECT 
    MIN(Date) AS Earliest_Date,
    MAX(Date) AS Latest_Date
FROM sales_transactions;

-- ============================================================
-- 1. Executive Summary Metrics
-- ============================================================

SELECT 
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Profit_Margin), 2) AS Avg_Profit_Margin,
    SUM(Quantity) AS Total_Units_Sold,
    COUNT(*) AS Total_Transactions
FROM sales_transactions;

-- ============================================================
-- 2. Revenue / Profit by Product Category
-- ============================================================

SELECT 
    Product_Category,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Profit_Margin), 2) AS Avg_Profit_Margin,
    SUM(Quantity) AS Units_Sold
FROM sales_transactions
GROUP BY Product_Category
ORDER BY Total_Profit DESC;

-- ============================================================
-- 3. Revenue / Profit by Sub-Category (Top 15)
-- ============================================================

SELECT 
    Sub_Category,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Profit_Margin), 2) AS Avg_Profit_Margin
FROM sales_transactions
GROUP BY Sub_Category
ORDER BY Total_Profit DESC
LIMIT 15;

-- ============================================================
-- 4. Top Countries by Revenue and Profit
-- ============================================================

SELECT 
    Country,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Profit_Margin), 2) AS Avg_Profit_Margin,
    COUNT(*) AS Transactions
FROM sales_transactions
GROUP BY Country
ORDER BY Total_Profit DESC
LIMIT 10;

-- ============================================================
-- 5. State-Level Performance
-- ============================================================

SELECT 
    Country,
    State,
    ROUND(SUM(Revenue), 2) AS Revenue,
    ROUND(SUM(Profit), 2) AS Profit
FROM sales_transactions
GROUP BY Country, State
ORDER BY Profit DESC
LIMIT 20;

-- ============================================================
-- 6. Monthly Revenue & Profit Trend
-- ============================================================

SELECT 
    Year,
    Month,
    ROUND(SUM(Revenue), 2) AS Monthly_Revenue,
    ROUND(SUM(Profit), 2) AS Monthly_Profit
FROM sales_transactions
GROUP BY Year, Month
ORDER BY Year,
         FIELD(Month, 'January','February','March','April','May','June',
                      'July','August','September','October','November','December');

-- ============================================================
-- 7. Customer Segmentation (Age/Gender)
-- ============================================================

SELECT 
    Customer_Gender,
    ROUND(AVG(Customer_Age), 1) AS Avg_Age,
    ROUND(SUM(Revenue), 2) AS Revenue,
    ROUND(SUM(Profit), 2) AS Profit,
    COUNT(*) AS Transactions
FROM sales_transactions
GROUP BY Customer_Gender;

SELECT 
    Customer_Age,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM sales_transactions
GROUP BY Customer_Age
ORDER BY Revenue DESC;

-- ============================================================
-- 8. High-Margin vs Low-Margin Product Categories
-- ============================================================

SELECT 
    Product_Category,
    ROUND(AVG(Profit_Margin), 2) AS Avg_Margin
FROM sales_transactions
GROUP BY Product_Category
ORDER BY Avg_Margin DESC;


-- End of script    ( Added all insights to my notes )
-- ============================================================
