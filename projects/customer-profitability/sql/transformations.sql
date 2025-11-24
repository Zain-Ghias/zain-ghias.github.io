-- ============================================================
-- Sales Intelligence Analysis (SQL)
-- Author: Zain Aamer Ghias
-- Description: Initial cleaning and transformation of sales data
--              prior to analysis and Power BI visualization.
-- ============================================================

-- Database setup
CREATE DATABASE IF NOT EXISTS sales_intelligence_db;
USE sales_intelligence_db;

-- ============================================================
-- Note on SQL_SAFE_UPDATES:
-- MySQL Workbench enables safe-update mode by default, which 
-- prevents bulk updates without a WHERE clause. Since the 
-- following transformations intentionally apply to the entire 
-- dataset (e.g., converting all dates, computing profit), 
-- safe-update mode is disabled temporarily and re-enabled 
-- afterwards. This is standard practice for controlled 
-- full-table transformations.
-- ============================================================

-- ============================================================
-- 1. Standardize column names
-- ============================================================

ALTER TABLE sales_transactions
CHANGE COLUMN `Customer Age` Customer_Age INT,
CHANGE COLUMN `Customer Gender` Customer_Gender VARCHAR(10),
CHANGE COLUMN `Product Category` Product_Category VARCHAR(50),
CHANGE COLUMN `Sub Category` Sub_Category VARCHAR(50),
CHANGE COLUMN `Unit Cost` Unit_Cost DOUBLE,
CHANGE COLUMN `Unit Price` Unit_Price DOUBLE;

-- ============================================================
-- 2. Convert Date (text) into proper DATE type
-- ============================================================

ALTER TABLE sales_transactions
ADD COLUMN Date_Formatted DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE sales_transactions
SET Date_Formatted = STR_TO_DATE(Date, '%m/%d/%y');

SET SQL_SAFE_UPDATES = 1;

ALTER TABLE sales_transactions DROP COLUMN Date;
ALTER TABLE sales_transactions CHANGE COLUMN Date_Formatted Date DATE;

-- ============================================================
-- 3. Add derived business metrics (Profit & Margin)
-- ============================================================

ALTER TABLE sales_transactions
ADD COLUMN Profit DOUBLE,
ADD COLUMN Profit_Margin DOUBLE;

SET SQL_SAFE_UPDATES = 0;

UPDATE sales_transactions
SET Profit = (Unit_Price - Unit_Cost) * Quantity,
    Profit_Margin = ROUND(Profit / Revenue * 100, 2);

SET SQL_SAFE_UPDATES = 1;

-- ============================================================
-- 4. Optional validation checks (commented)
-- ============================================================

-- SELECT COUNT(*) AS total_rows FROM sales_transactions;
-- SELECT MIN(Date), MAX(Date) FROM sales_transactions;
-- SELECT COUNT(*) AS revenue_mismatches
-- FROM sales_transactions
-- WHERE ROUND(Unit_Price * Quantity, 2) <> ROUND(Revenue, 2);

-- End of script
-- ============================================================
