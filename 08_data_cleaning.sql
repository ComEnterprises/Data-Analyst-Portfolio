/*
Coffee Shop Analytics

Script: 08_data_cleaning.sql

Purpose:
Review data quality issues and validate that the
dataset is ready for reporting.
*/


-- Record count

SELECT COUNT(*) AS total_rows
FROM sales;


-- Duplicate transaction check

SELECT
    transaction_id,
    COUNT(*) AS duplicate_count
FROM sales
GROUP BY transaction_id
HAVING COUNT(*) > 1;


-- Missing value checks

SELECT
    COUNT(*) AS missing_transaction_date
FROM sales
WHERE transaction_date IS NULL;


SELECT
    COUNT(*) AS missing_transaction_time
FROM sales
WHERE transaction_time IS NULL;


SELECT
    COUNT(*) AS missing_store_location
FROM sales
WHERE store_location IS NULL;


SELECT
    COUNT(*) AS missing_product_category
FROM sales
WHERE product_category IS NULL;


SELECT
    COUNT(*) AS missing_product_type
FROM sales
WHERE product_type IS NULL;


SELECT
    COUNT(*) AS missing_product_detail
FROM sales
WHERE product_detail IS NULL;


SELECT
    COUNT(*) AS missing_unit_price
FROM sales
WHERE unit_price IS NULL;


SELECT
    COUNT(*) AS missing_quantity
FROM sales
WHERE transaction_qty IS NULL;


SELECT
    COUNT(*) AS missing_revenue
FROM sales
WHERE revenue IS NULL;


-- Check invalid numeric values

SELECT *
FROM sales
WHERE transaction_qty <= 0;


SELECT *
FROM sales
WHERE unit_price <= 0;


SELECT *
FROM sales
WHERE revenue <= 0;


-- Confirm revenue calculation

SELECT *
FROM sales
WHERE ROUND(unit_price * transaction_qty, 2) <> revenue;


-- Validate hour values

SELECT *
FROM sales
WHERE hour NOT BETWEEN 0 AND 23;


-- Review date categories

SELECT DISTINCT day_name
FROM sales
ORDER BY day_name;


SELECT DISTINCT month
FROM sales
ORDER BY month;


SELECT DISTINCT day_type
FROM sales
ORDER BY day_type;


-- Review product distribution

SELECT
    product_category,
    COUNT(*) AS record_count
FROM sales
GROUP BY product_category
ORDER BY record_count DESC;


-- Review store distribution

SELECT
    store_location,
    COUNT(*) AS record_count
FROM sales
GROUP BY store_location
ORDER BY record_count DESC;


-- Transaction date range

SELECT
    MIN(transaction_date) AS first_transaction,
    MAX(transaction_date) AS last_transaction
FROM sales;


-- Revenue summary

SELECT
    MIN(revenue) AS minimum_revenue,
    MAX(revenue) AS maximum_revenue,
    ROUND(AVG(revenue), 2) AS average_revenue
FROM sales;


-- Unit price summary

SELECT
    MIN(unit_price) AS minimum_price,
    MAX(unit_price) AS maximum_price,
    ROUND(AVG(unit_price), 2) AS average_price
FROM sales;


-- Transaction quantity summary

SELECT
    MIN(transaction_qty) AS minimum_quantity,
    MAX(transaction_qty) AS maximum_quantity,
    ROUND(AVG(transaction_qty), 2) AS average_quantity
FROM sales;