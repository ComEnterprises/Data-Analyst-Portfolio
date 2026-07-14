/*
Coffee Shop Analytics

Script: 03_kpi_analysis.sql

Purpose:
Calculate overall business performance metrics
for executive reporting and dashboard creation.
*/


-- Overall revenue

SELECT
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales;


-- Total transactions

SELECT
    COUNT(*) AS total_transactions
FROM sales;


-- Total items sold

SELECT
    SUM(transaction_qty) AS total_units_sold
FROM sales;


-- Average customer spend

SELECT
    ROUND(AVG(revenue), 2) AS average_order_value
FROM sales;


-- Average items per transaction

SELECT
    ROUND(AVG(transaction_qty), 2) AS average_items_per_order
FROM sales;


-- Smallest and largest transactions

SELECT
    MIN(revenue) AS minimum_transaction,
    MAX(revenue) AS maximum_transaction
FROM sales;


-- Average revenue generated per item

SELECT
    ROUND(
        SUM(revenue) / NULLIF(SUM(transaction_qty), 0),
        2
    ) AS average_revenue_per_item
FROM sales;


-- Executive KPI summary

SELECT
    ROUND(SUM(revenue), 2) AS total_revenue,

    COUNT(*) AS total_transactions,

    SUM(transaction_qty) AS total_units_sold,

    ROUND(AVG(revenue), 2) AS average_order_value,

    ROUND(AVG(transaction_qty), 2) AS average_items_per_order,

    MIN(revenue) AS minimum_transaction,

    MAX(revenue) AS maximum_transaction,

    ROUND(
        SUM(revenue) / NULLIF(SUM(transaction_qty), 0),
        2
    ) AS average_revenue_per_item

FROM sales;