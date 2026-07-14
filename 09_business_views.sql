/*
Coffee Shop Analytics

Script: 09_business_views.sql

Purpose:
Create reusable reporting views for dashboards
and business analysis.
*/


-- Remove existing views

DROP VIEW IF EXISTS vw_kpi_summary;
DROP VIEW IF EXISTS vw_store_performance;
DROP VIEW IF EXISTS vw_product_performance;
DROP VIEW IF EXISTS vw_category_performance;
DROP VIEW IF EXISTS vw_hourly_sales;
DROP VIEW IF EXISTS vw_daily_sales;
DROP VIEW IF EXISTS vw_monthly_sales;


-- Executive KPI summary

CREATE VIEW vw_kpi_summary AS

SELECT

    ROUND(SUM(revenue), 2) AS total_revenue,

    COUNT(*) AS total_transactions,

    SUM(transaction_qty) AS total_units_sold,

    ROUND(AVG(revenue), 2) AS average_order_value,

    ROUND(
        SUM(revenue) /
        NULLIF(SUM(transaction_qty), 0),
        2
    ) AS revenue_per_item

FROM sales;



-- Store performance

CREATE VIEW vw_store_performance AS

SELECT

    store_location,

    ROUND(SUM(revenue), 2) AS total_revenue,

    COUNT(*) AS total_transactions,

    SUM(transaction_qty) AS total_units_sold,

    ROUND(AVG(revenue), 2) AS average_order_value,

    ROUND(
        SUM(revenue) * 100.0 /
        SUM(SUM(revenue)) OVER(),
        2
    ) AS revenue_share,

    RANK() OVER(
        ORDER BY SUM(revenue) DESC
    ) AS revenue_rank

FROM sales

GROUP BY store_location;



-- Product performance

CREATE VIEW vw_product_performance AS

SELECT

    product_detail,

    product_category,

    product_type,

    ROUND(SUM(revenue), 2) AS total_revenue,

    SUM(transaction_qty) AS units_sold,

    ROUND(AVG(revenue), 2) AS average_sale,

    RANK() OVER(
        ORDER BY SUM(revenue) DESC
    ) AS revenue_rank

FROM sales

GROUP BY
    product_detail,
    product_category,
    product_type;



-- Category performance

CREATE VIEW vw_category_performance AS

SELECT

    product_category,

    ROUND(SUM(revenue), 2) AS total_revenue,

    SUM(transaction_qty) AS units_sold,

    ROUND(AVG(revenue), 2) AS average_sale,

    ROUND(
        SUM(revenue) * 100.0 /
        SUM(SUM(revenue)) OVER(),
        2
    ) AS revenue_share

FROM sales

GROUP BY product_category;



-- Hourly sales trends

CREATE VIEW vw_hourly_sales AS

SELECT

    hour,

    ROUND(SUM(revenue), 2) AS total_revenue,

    COUNT(*) AS total_transactions,

    SUM(transaction_qty) AS total_units

FROM sales

GROUP BY hour;



-- Daily sales trends

CREATE VIEW vw_daily_sales AS

SELECT

    transaction_date,

    ROUND(SUM(revenue), 2) AS total_revenue,

    COUNT(*) AS total_transactions,

    SUM(transaction_qty) AS total_units

FROM sales

GROUP BY transaction_date;



-- Monthly sales trends

CREATE VIEW vw_monthly_sales AS

SELECT

    month,

    ROUND(SUM(revenue), 2) AS total_revenue,

    COUNT(*) AS total_transactions,

    SUM(transaction_qty) AS total_units

FROM sales

GROUP BY month;



-- Test views after creation

SELECT *
FROM vw_kpi_summary;


SELECT *
FROM vw_store_performance;


SELECT *
FROM vw_product_performance
LIMIT 10;


SELECT *
FROM vw_category_performance;


SELECT *
FROM vw_hourly_sales;


SELECT *
FROM vw_daily_sales
LIMIT 10;


SELECT *
FROM vw_monthly_sales;