/*
Coffee Shop Analytics
Database Setup
*/

/*
sales

Stores one row per transaction sold.

Source: 
Coffee_shop_sales.csv

CSV imported using pgAdmin Import Wizard.
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

-- Verify that table exists
SELECT *
FROM sales;

-- Verify row count

SELECT COUNT(*) AS total_rows
FROM sales;

-- Preview the data

SELECT *
FROM sales
LIMIT 10;

-- Inspect the table structure

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'sales';

-- Check for duplicate transaction IDs

SELECT
    transaction_id,
    COUNT(*)
FROM sales
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- Check for null values

SELECT COUNT(*)
FROM sales
WHERE revenue IS NULL;

/*
Deliverable Complete

✓ Table created
✓ CSV imported
✓ Row count verified
✓ Preview completed
✓ Schema verified

Database is ready for analysis.
*/