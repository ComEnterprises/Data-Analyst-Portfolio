
/*
Coffee Shop Analytics

Script: 05_product_analysis.sql

Purpose:
Analyze product performance by category, product type,
and individual product to identify revenue drivers.
*/


-- Revenue by product category

SELECT
    product_category,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
GROUP BY product_category
ORDER BY total_revenue DESC;


-- Revenue by product type

SELECT
    product_type,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
GROUP BY product_type
ORDER BY total_revenue DESC;


-- Revenue by individual product

SELECT
    product_detail,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
GROUP BY product_detail
ORDER BY total_revenue DESC;


-- Units sold by category

SELECT
    product_category,
    SUM(transaction_qty) AS total_units_sold
FROM sales
GROUP BY product_category
ORDER BY total_units_sold DESC;


-- Units sold by product type

SELECT
    product_type,
    SUM(transaction_qty) AS total_units_sold
FROM sales
GROUP BY product_type
ORDER BY total_units_sold DESC;


-- Average sale by category

SELECT
    product_category,
    ROUND(AVG(revenue), 2) AS average_sale
FROM sales
GROUP BY product_category
ORDER BY average_sale DESC;


-- Top 10 products by revenue

SELECT
    product_detail,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
GROUP BY product_detail
ORDER BY total_revenue DESC
LIMIT 10;


-- Bottom 10 products by revenue

SELECT
    product_detail,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
GROUP BY product_detail
ORDER BY total_revenue
LIMIT 10;


-- Revenue contribution by category

SELECT
    product_category,

    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(SUM(revenue) * 100.0 /
        SUM(SUM(revenue)) OVER (),
        2) AS revenue_share_percent
FROM sales
GROUP BY product_category
ORDER BY total_revenue DESC;


-- Product-level revenue summary

WITH product_sales AS
(
    SELECT
        product_category,
        product_type,
        product_detail,
        SUM(revenue) AS total_revenue,
        SUM(transaction_qty) AS total_units
    FROM sales
    GROUP BY
        product_category,
        product_type,
        product_detail
)

SELECT *
FROM product_sales
ORDER BY total_revenue DESC;


-- Rank products by revenue

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

    ROW_NUMBER() OVER(
        ORDER BY total_revenue DESC
    ) AS row_number,

    RANK() OVER(
        ORDER BY total_revenue DESC
    ) AS revenue_rank,

    DENSE_RANK() OVER(
        ORDER BY total_revenue DESC
    ) AS dense_rank

FROM product_sales

ORDER BY total_revenue DESC;


-- Top product within each category

WITH product_sales AS
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

        RANK() OVER(
            PARTITION BY product_category
            ORDER BY total_revenue DESC
        ) AS category_rank

    FROM product_sales

) ranked_products

WHERE category_rank = 1

ORDER BY total_revenue DESC;


-- Pareto analysis: cumulative revenue contribution

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
        )
        /
        SUM(total_revenue) OVER(),
        4
    ) AS cumulative_revenue_percent

FROM product_sales

ORDER BY total_revenue DESC;


-- Product category performance summary

SELECT

    product_category,

    ROUND(SUM(revenue), 2) AS total_revenue,

    SUM(transaction_qty) AS total_units_sold,

    ROUND(AVG(revenue), 2) AS average_sale,

    ROUND(
        SUM(revenue) * 100.0 /
        SUM(SUM(revenue)) OVER(),
        2
    ) AS revenue_share_percent

FROM sales

GROUP BY product_category

ORDER BY total_revenue DESC;