/*
Coffee Shop Analytics

Script: 01_database_setup.sql

Purpose:
Create the sales table and verify the imported dataset.
*/

DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
    transaction_id INT PRIMARY KEY NOT NULL,
    transaction_date DATE NOT NULL,
    transaction_time TIME NOT NULL,
    transaction_qty INT NOT NULL,
    store_id INT NOT NULL,
    store_location VARCHAR(50) NOT NULL,
    product_id INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    product_category VARCHAR(50) NOT NULL,
    product_type VARCHAR(100) NOT NULL,
    product_detail VARCHAR(100) NOT NULL,
    revenue NUMERIC(10,2) NOT NULL,
    hour INT NOT NULL,
    day_name VARCHAR(20) NOT NULL,
    month VARCHAR(20) NOT NULL,
    day_type VARCHAR(20) NOT NULL
);


-- Confirm table was created

SELECT *
FROM sales;


-- Check number of records loaded

SELECT COUNT(*) AS total_rows
FROM sales;


-- Preview imported data

SELECT *
FROM sales
LIMIT 10;


-- Review table structure

SELECT 
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'sales';


-- Check for duplicate transaction IDs

SELECT
    transaction_id,
    COUNT(*) AS duplicate_count
FROM sales
GROUP BY transaction_id
HAVING COUNT(*) > 1;


-- Check for missing revenue values

SELECT
    COUNT(*) AS missing_revenue
FROM sales
WHERE revenue IS NULL;