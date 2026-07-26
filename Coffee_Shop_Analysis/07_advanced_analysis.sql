/*
Coffee Shop Analytics

Script: 07_advanced_analysis.sql

Purpose:
Perform deeper analysis using CTEs and window functions
to compare performance, rankings, trends, and revenue
contribution.
*/


-- Compare store revenue against company average

WITH store_summary AS
(
    SELECT
        store_location,
        SUM(revenue) AS total_revenue
    FROM sales
    GROUP BY store_location
)

SELECT
    store_location,

    ROUND(total_revenue, 2) AS total_revenue,

    ROUND(
        AVG(total_revenue) OVER (),
        2
    ) AS company_average_revenue,

    ROUND(
        total_revenue -
        AVG(total_revenue) OVER (),
        2
    ) AS difference_from_average

FROM store_summary

ORDER BY total_revenue DESC;


-- Rank stores by revenue

WITH store_summary AS
(
    SELECT
        store_location,
        SUM(revenue) AS total_revenue
    FROM sales
    GROUP BY store_location
)

SELECT

    store_location,

    ROUND(total_revenue, 2) AS total_revenue,

    ROW_NUMBER() OVER(
        ORDER BY total_revenue DESC
    ) AS row_number,

    RANK() OVER(
        ORDER BY total_revenue DESC
    ) AS revenue_rank,

    DENSE_RANK() OVER(
        ORDER BY total_revenue DESC
    ) AS dense_rank

FROM store_summary

ORDER BY total_revenue DESC;


-- Rank products by revenue

WITH product_summary AS
(
    SELECT
        product_detail,
        SUM(revenue) AS total_revenue
    FROM sales
    GROUP BY product_detail
)

SELECT

    product_detail,

    ROUND(total_revenue, 2) AS total_revenue,

    RANK() OVER(
        ORDER BY total_revenue DESC
    ) AS revenue_rank

FROM product_summary

ORDER BY revenue_rank;


-- Find the top product within each category

WITH product_summary AS
(
    SELECT
        product_category,
        product_detail,
        SUM(revenue) AS total_revenue
    FROM sales
    GROUP BY
        product_category,
        product_detail
)

SELECT *

FROM
(
    SELECT

        product_category,

        product_detail,

        ROUND(total_revenue, 2) AS total_revenue,

        ROW_NUMBER() OVER(
            PARTITION BY product_category
            ORDER BY total_revenue DESC
        ) AS category_rank

    FROM product_summary

) ranked_products

WHERE category_rank = 1

ORDER BY total_revenue DESC;


-- Revenue contribution by product

WITH product_summary AS
(
    SELECT
        product_detail,
        SUM(revenue) AS total_revenue
    FROM sales
    GROUP BY product_detail
)

SELECT

    product_detail,

    ROUND(total_revenue, 2) AS total_revenue,

    ROUND(
        total_revenue * 100.0 /
        SUM(total_revenue) OVER(),
        2
    ) AS revenue_percent

FROM product_summary

ORDER BY total_revenue DESC;


-- Category performance comparison

WITH category_summary AS
(
    SELECT

        product_category,

        SUM(revenue) AS revenue,

        SUM(transaction_qty) AS units

    FROM sales

    GROUP BY product_category
)

SELECT

    product_category,

    ROUND(revenue, 2) AS total_revenue,

    units,

    ROUND(
        revenue * 100.0 /
        SUM(revenue) OVER(),
        2
    ) AS revenue_share

FROM category_summary

ORDER BY revenue DESC;


-- Divide products into revenue quartiles

WITH product_summary AS
(
    SELECT

        product_detail,

        SUM(revenue) AS total_revenue

    FROM sales

    GROUP BY product_detail
)

SELECT

    product_detail,

    ROUND(total_revenue, 2) AS total_revenue,

    NTILE(4) OVER(
        ORDER BY total_revenue DESC
    ) AS revenue_quartile

FROM product_summary

ORDER BY total_revenue DESC;


-- Compare category averages against company average

SELECT

    product_category,

    ROUND(AVG(revenue), 2) AS average_sale,

    ROUND(
        AVG(AVG(revenue)) OVER(),
        2
    ) AS company_average_sale

FROM sales

GROUP BY product_category

ORDER BY average_sale DESC;


-- Highest revenue transaction by store

WITH ranked_sales AS
(
    SELECT

        transaction_id,

        store_location,

        revenue,

        ROW_NUMBER() OVER(
            PARTITION BY store_location
            ORDER BY revenue DESC
        ) AS row_num

    FROM sales
)

SELECT

    transaction_id,

    store_location,

    revenue

FROM ranked_sales

WHERE row_num = 1

ORDER BY revenue DESC;


-- Daily revenue trend with running total

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
        SUM(daily_revenue) OVER(
            ORDER BY transaction_date
        ),
        2
    ) AS running_total

FROM daily_sales

ORDER BY transaction_date;


-- Compare revenue with previous day

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
        LAG(daily_revenue) OVER(
            ORDER BY transaction_date
        ),
        2
    ) AS previous_day,

    ROUND(
        daily_revenue -
        LAG(daily_revenue) OVER(
            ORDER BY transaction_date
        ),
        2
    ) AS revenue_change

FROM daily_sales

ORDER BY transaction_date;


-- Reference next day's revenue

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
        LEAD(daily_revenue) OVER(
            ORDER BY transaction_date
        ),
        2
    ) AS next_day_revenue

FROM daily_sales

ORDER BY transaction_date;


-- Seven-day moving average

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
        AVG(daily_revenue) OVER(
            ORDER BY transaction_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS seven_day_average

FROM daily_sales

ORDER BY transaction_date;


-- Product Pareto analysis

WITH product_sales AS
(
    SELECT
        product_detail,
        SUM(revenue) AS total_revenue
    FROM sales
    GROUP BY product_detail
)

SELECT

    product_detail,

    ROUND(total_revenue, 2) AS total_revenue,

    ROUND(
        SUM(total_revenue) OVER(
            ORDER BY total_revenue DESC
        ),
        2
    ) AS cumulative_revenue,

    ROUND(
        SUM(total_revenue) OVER(
            ORDER BY total_revenue DESC
        ) * 100.0 /
        SUM(total_revenue) OVER(),
        2
    ) AS cumulative_percent

FROM product_sales

ORDER BY total_revenue DESC;


-- Classify stores relative to company average

WITH store_summary AS
(
    SELECT
        store_location,
        SUM(revenue) AS total_revenue
    FROM sales
    GROUP BY store_location
)

SELECT

    store_location,

    ROUND(total_revenue, 2) AS total_revenue,

    CASE
        WHEN total_revenue >= AVG(total_revenue) OVER()
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS performance

FROM store_summary

ORDER BY total_revenue DESC;