/*
Coffee Shop Analytics

Script: 06_time_analysis.sql

Purpose:
Analyze sales trends across hours, days, and months to
identify customer purchasing patterns and peak demand.
*/


-- Revenue by hour

SELECT
    hour,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
GROUP BY hour
ORDER BY hour;


-- Peak revenue hour

SELECT
    hour,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
GROUP BY hour
ORDER BY total_revenue DESC
LIMIT 1;


-- Transactions by hour

SELECT
    hour,
    COUNT(*) AS total_transactions
FROM sales
GROUP BY hour
ORDER BY hour;


-- Units sold by hour

SELECT
    hour,
    SUM(transaction_qty) AS total_units_sold
FROM sales
GROUP BY hour
ORDER BY hour;


-- Average order value by hour

SELECT
    hour,
    ROUND(AVG(revenue), 2) AS average_order_value
FROM sales
GROUP BY hour
ORDER BY hour;


-- Revenue by weekday

SELECT
    day_name,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
GROUP BY day_name
ORDER BY total_revenue DESC;


-- Revenue by weekday (calendar order)

SELECT
    day_name,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
GROUP BY day_name
ORDER BY
    CASE
        WHEN day_name = 'Monday' THEN 1
        WHEN day_name = 'Tuesday' THEN 2
        WHEN day_name = 'Wednesday' THEN 3
        WHEN day_name = 'Thursday' THEN 4
        WHEN day_name = 'Friday' THEN 5
        WHEN day_name = 'Saturday' THEN 6
        WHEN day_name = 'Sunday' THEN 7
    END;


-- Revenue by month

SELECT
    month,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue DESC;


-- Daily revenue

SELECT
    transaction_date,
    ROUND(SUM(revenue), 2) AS daily_revenue
FROM sales
GROUP BY transaction_date
ORDER BY transaction_date;


-- Running revenue over time

SELECT
    transaction_date,

    ROUND(SUM(revenue), 2) AS daily_revenue,

    ROUND(
        SUM(SUM(revenue)) OVER (
            ORDER BY transaction_date
        ),
        2
    ) AS running_revenue

FROM sales

GROUP BY transaction_date

ORDER BY transaction_date;


-- Day-over-day revenue comparison

WITH daily_sales AS
(
    SELECT
        transaction_date,
        SUM(revenue) AS daily_revenue
    FROM sales
    GROUP BY transaction_date
)

SELECT

    transaction_date,

    ROUND(daily_revenue, 2) AS daily_revenue,

    ROUND(
        LAG(daily_revenue) OVER (
            ORDER BY transaction_date
        ),
        2
    ) AS previous_day_revenue,

    ROUND(
        daily_revenue -
        LAG(daily_revenue) OVER (
            ORDER BY transaction_date
        ),
        2
    ) AS revenue_change

FROM daily_sales

ORDER BY transaction_date;


-- Weekday vs. weekend performance

SELECT

    day_type,

    COUNT(*) AS total_transactions,

    SUM(transaction_qty) AS total_units_sold,

    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(AVG(revenue), 2) AS average_order_value

FROM sales

GROUP BY day_type

ORDER BY total_revenue DESC;


-- Morning rush (7 AM - 10 AM)

SELECT

    hour,

    ROUND(SUM(revenue), 2) AS total_revenue,

    COUNT(*) AS total_transactions

FROM sales

WHERE hour BETWEEN 7 AND 10

GROUP BY hour

ORDER BY hour;


-- Top 10 revenue days

SELECT

    transaction_date,

    COUNT(*) AS total_transactions,

    ROUND(SUM(revenue), 2) AS total_revenue

FROM sales

GROUP BY transaction_date

ORDER BY total_revenue DESC

LIMIT 10;


-- Bottom 10 revenue days

SELECT

    transaction_date,

    COUNT(*) AS total_transactions,

    ROUND(SUM(revenue), 2) AS total_revenue

FROM sales

GROUP BY transaction_date

ORDER BY total_revenue

LIMIT 10;


-- Time performance summary

SELECT

    day_type,

    COUNT(*) AS total_transactions,

    SUM(transaction_qty) AS total_units_sold,

    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(AVG(revenue), 2) AS average_order_value

FROM sales

GROUP BY day_type

ORDER BY total_revenue DESC;