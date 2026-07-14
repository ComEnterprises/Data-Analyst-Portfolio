/*
Coffee Shop Analytics Project

Data Validation

Script: 02_data_validation.sql

Purpose:
Validate imported sales data before analysis.
*/

-- Count all rows

SELECT COUNT(*) AS total_rows
FROM sales;

-- Preview the data

SELECT *
FROM sales
LIMIT 20;

-- Purpose: How many stores exist?

SELECT DISTINCT store_location
FROM sales;

-- Count transactions per store

SELECT store_location, COUNT(*) AS transactions
FROM sales
GROUP BY store_location
ORDER BY transactions DESC;

-- Verify product categories

SELECT DISTINCT product_category
FROM sales
ORDER BY product_category;

-- Verify product types

SELECT DISTINCT product_type
FROM sales
ORDER BY product_type;

-- Check for missing revenue

SELECT COUNT(*) AS missing_revenue
FROM sales
WHERE revenue IS NULL;

-- Check for missing quantity

SELECT *
FROM sales
WHERE transaction_qty IS NULL;

-- Check for missing store

SELECT *
FROM sales
WHERE store_location IS NULL;

-- Check for invalid revenue

SELECT *
FROM sales
WHERE revenue < 0;

-- Check for invalid quantity

SELECT *
FROM sales
WHERE transaction_qty <= 0;

-- Find any duplicate transactions

SELECT transaction_id, COUNT(*) AS duplicate_count
FROM sales
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- Uncover the revenue range

SELECT MIN(unit_price) AS min_price, 
MAX(unit_price) AS max_price
FROM sales;

-- Uncover the transaction quantity range

SELECT MIN(transaction_qty) AS min_qty, 
MAX(transaction_qty) AS max_qty
FROM sales;

-- Check the date range

SELECT MIN(transaction_date) AS first_sale, 
MAX(transaction_date) AS last_sale
FROM sales;

-- Check hour values

SELECT DISTINCT hour
FROM sales
ORDER BY hour;

-- verify date names

SELECT DISTINCT day_name
FROM sales
ORDER BY day_name;

-- Verify month names

SELECT DISTINCT month
FROM sales
ORDER BY month;


/*
Validation Summary

✓ 149,116 rows imported successfully
✓ No missing revenue values
✓ No missing quantity values
✓ No missing store locations
✓ No negative revenue values
✓ No invalid quantities
✓ Store names are consistent
✓ Product categories are consistent
✓ Date range verified
✓ Hour values verified
✓ Duplicate transaction check completed
*//*
Coffee Shop Analytics

Script: 02_data_validation.sql

Purpose:
Review data quality and confirm the imported sales data
is ready for analysis.
*/


-- Confirm record count

SELECT COUNT(*) AS total_rows
FROM sales;


-- Preview imported records

SELECT *
FROM sales
LIMIT 20;


-- Review available store locations

SELECT DISTINCT store_location
FROM sales
ORDER BY store_location;


-- Transaction volume by store

SELECT
    store_location,
    COUNT(*) AS transaction_count
FROM sales
GROUP BY store_location
ORDER BY transaction_count DESC;


-- Review product categories

SELECT DISTINCT product_category
FROM sales
ORDER BY product_category;


-- Review product types

SELECT DISTINCT product_type
FROM sales
ORDER BY product_type;


-- Check for missing revenue values

SELECT
    COUNT(*) AS missing_revenue
FROM sales
WHERE revenue IS NULL;


-- Check for missing transaction quantities

SELECT
    COUNT(*) AS missing_quantity
FROM sales
WHERE transaction_qty IS NULL;


-- Check for missing store locations

SELECT
    COUNT(*) AS missing_stores
FROM sales
WHERE store_location IS NULL;


-- Check for negative revenue values

SELECT *
FROM sales
WHERE revenue < 0;


-- Check for invalid transaction quantities

SELECT *
FROM sales
WHERE transaction_qty <= 0;


-- Check for duplicate transaction IDs

SELECT
    transaction_id,
    COUNT(*) AS duplicate_count
FROM sales
GROUP BY transaction_id
HAVING COUNT(*) > 1;


-- Review pricing range

SELECT
    MIN(unit_price) AS minimum_price,
    MAX(unit_price) AS maximum_price
FROM sales;


-- Review transaction quantity range

SELECT
    MIN(transaction_qty) AS minimum_quantity,
    MAX(transaction_qty) AS maximum_quantity
FROM sales;


-- Confirm date range

SELECT
    MIN(transaction_date) AS first_transaction,
    MAX(transaction_date) AS last_transaction
FROM sales;


-- Review available hours

SELECT DISTINCT hour
FROM sales
ORDER BY hour;


-- Review day names

SELECT DISTINCT day_name
FROM sales
ORDER BY day_name;


-- Review month values

SELECT DISTINCT month
FROM sales
ORDER BY month;