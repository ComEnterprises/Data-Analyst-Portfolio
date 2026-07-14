/*
Coffee Shop Analytics

Script: 04_store_analysis.sql

Purpose:
Analyze store performance using revenue,
transactions, units sold, and store rankings.
*/


-- Revenue performance by store

SELECT
    store_location,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
GROUP BY store_location
ORDER BY total_revenue DESC;


-- Transaction volume by store

SELECT
    store_location,
    COUNT(*) AS total_transactions
FROM sales
GROUP BY store_location
ORDER BY total_transactions DESC;


-- Units sold by store

SELECT
    store_location,
    SUM(transaction_qty) AS total_units_sold
FROM sales
GROUP BY store_location
ORDER BY total_units_sold DESC;


-- Average order value by store

SELECT
    store_location,
    ROUND(AVG(revenue), 2) AS average_order_value
FROM sales
GROUP BY store_location
ORDER BY average_order_value DESC;


-- Transaction range by store

SELECT
    store_location,
    MIN(revenue) AS minimum_sale,
    MAX(revenue) AS maximum_sale,
    ROUND(AVG(revenue), 2) AS average_sale
FROM sales
GROUP BY store_location
ORDER BY average_sale DESC;


-- Revenue contribution by store

SELECT
    store_location,

    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(revenue) * 100.0 /
        SUM(SUM(revenue)) OVER (),
        2
    ) AS revenue_share_percent

FROM sales

GROUP BY store_location

ORDER BY total_revenue DESC;


-- Rank stores by revenue

SELECT
    store_location,

    ROUND(SUM(revenue), 2) AS total_revenue,

    RANK() OVER(
        ORDER BY SUM(revenue) DESC
    ) AS revenue_rank

FROM sales

GROUP BY store_location

ORDER BY revenue_rank;


-- Highest revenue store

SELECT
    store_location,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
GROUP BY store_location
ORDER BY total_revenue DESC
LIMIT 1;


-- Lowest revenue store

SELECT
    store_location,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
GROUP BY store_location
ORDER BY total_revenue
LIMIT 1;


-- Store performance summary for reporting

SELECT

    store_location,

    ROUND(SUM(revenue), 2) AS total_revenue,

    COUNT(*) AS total_transactions,

    SUM(transaction_qty) AS total_units_sold,

    ROUND(AVG(revenue), 2) AS average_order_value,

    ROUND(
        SUM(revenue) * 100.0 /
        SUM(SUM(revenue)) OVER (),
        2
    ) AS revenue_share_percent,

    RANK() OVER(
        ORDER BY SUM(revenue) DESC
    ) AS revenue_rank

FROM sales

GROUP BY store_location

ORDER BY revenue_rank;