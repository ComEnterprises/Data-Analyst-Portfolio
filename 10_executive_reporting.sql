/*
Coffee Shop Analytics

Script: 10_reporting_outputs.sql

Purpose:
Generate reporting outputs from analytical views
for dashboards and management reporting.
*/


-- Executive KPI summary

SELECT *
FROM vw_kpi_summary;



-- Store performance report

SELECT

    revenue_rank,

    store_location,

    total_revenue,

    revenue_share,

    total_transactions,

    total_units_sold,

    average_order_value

FROM vw_store_performance

ORDER BY revenue_rank;



-- Product category performance

SELECT

    product_category,

    total_revenue,

    units_sold,

    average_sale,

    revenue_share

FROM vw_category_performance

ORDER BY total_revenue DESC;



-- Top performing products

SELECT

    revenue_rank,

    product_detail,

    product_category,

    total_revenue,

    units_sold

FROM vw_product_performance

ORDER BY revenue_rank

LIMIT 15;



-- Lowest performing products

SELECT

    revenue_rank,

    product_detail,

    product_category,

    total_revenue,

    units_sold

FROM vw_product_performance

ORDER BY revenue_rank DESC

LIMIT 15;



-- Hourly sales trends

SELECT *

FROM vw_hourly_sales

ORDER BY hour;



-- Daily revenue trends

SELECT *

FROM vw_daily_sales

ORDER BY transaction_date;



-- Monthly revenue trends

SELECT *

FROM vw_monthly_sales

ORDER BY total_revenue DESC;



-- Executive scorecard

WITH executive_scorecard AS
(
    SELECT

        total_revenue,

        total_transactions,

        total_units_sold,

        average_order_value

    FROM vw_kpi_summary
)

SELECT *

FROM executive_scorecard;



-- Store revenue contribution

SELECT

    revenue_rank,

    store_location,

    revenue_share,

    total_revenue

FROM vw_store_performance

ORDER BY revenue_rank;