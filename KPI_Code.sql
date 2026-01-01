/*
====================================================
File: kpi_analysis.sql
Author: Muhammad Arslan Arshad
Description:
SQL queries for business KPIs related to profit analysis
across regions, markets, products, and time.
Database: PostgreSQL
Table: sales_profit
====================================================
*/


/* ==================================================
Business Problem 1
Which regions generate the highest average profit per order?
================================================== */
-- Top 5 regions by highest average profit per order

SELECT
    order_region,
    ROUND(AVG(profit_per_order), 2) AS avg_profit_per_order
FROM sales_profit
GROUP BY order_region
ORDER BY avg_profit_per_order DESC
LIMIT 5;


/* ==================================================
Business Problem 2
Which markets generate the highest average profit per order?
================================================== */

SELECT
    market,
    ROUND(AVG(profit_per_order), 2) AS avg_profit_per_order
FROM sales_profit
GROUP BY market
ORDER BY avg_profit_per_order DESC;


/* ==================================================
Business Problem 3
Which regions show the most stability in profit per order?
(Lower standard deviation = more stable)
================================================== */
-- Top 5 most stable regions

SELECT
    order_region,
    ROUND(STDDEV(profit_per_order), 2) AS profit_volatility
FROM sales_profit
GROUP BY order_region
ORDER BY profit_volatility ASC
LIMIT 5;


/* ==================================================
Business Problem 4
Year-over-year change in regional profitability
================================================== */

WITH yearly_profit AS (
    SELECT
        order_region,
        EXTRACT(YEAR FROM order_date) AS year,
        AVG(profit_per_order) AS avg_profit
    FROM sales_profit
    GROUP BY order_region, year
)
SELECT
    order_region,
    year,
    ROUND(
        avg_profit
        - LAG(avg_profit) OVER (
            PARTITION BY order_region
            ORDER BY year
        ),
        2
    ) AS yoy_profit_change
FROM yearly_profit
ORDER BY order_region, year;


/* ==================================================
Business Problem 5
Region Performance Index (Relative Profitability)
How does each region perform relative to the global average?
================================================== */

WITH global_avg AS (
    SELECT AVG(profit_per_order) AS global_avg_profit
    FROM sales_profit
)
SELECT
    order_region,
    ROUND(AVG(profit_per_order), 2) AS region_avg_profit,
    ROUND(
        AVG(profit_per_order) / (SELECT global_avg_profit FROM global_avg),
        2
    ) AS region_performance_index
FROM sales_profit
GROUP BY order_region
ORDER BY region_performance_index DESC;


/* ==================================================
Business Problem 6
Market Profit Trend Index
How do markets improve or decline over time?
================================================== */

WITH market_year_profit AS (
    SELECT
        market,
        EXTRACT(YEAR FROM order_date) AS year,
        AVG(profit_per_order) AS avg_profit
    FROM sales_profit
    GROUP BY market, year
)
SELECT
    market,
    year,
    ROUND(
        avg_profit
        / FIRST_VALUE(avg_profit) OVER (
            PARTITION BY market
            ORDER BY year
        ),
        2
    ) AS profit_trend_index
FROM market_year_profit
ORDER BY market, year;


/* ==================================================
Business Problem 7
Top-Performing Product per Region per Year
================================================== */

WITH product_region_year AS (
    SELECT
        order_region,
        EXTRACT(YEAR FROM order_date) AS year,
        product_name,
        AVG(profit_per_order) AS avg_profit
    FROM sales_profit
    GROUP BY order_region, year, product_name
),
ranked_products AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY order_region, year
            ORDER BY avg_profit DESC
        ) AS rnk
    FROM product_region_year
)
SELECT
    order_region,
    year,
    product_name,
    ROUND(avg_profit, 2) AS avg_profit_per_order
FROM ranked_products
WHERE rnk = 1
ORDER BY order_region, year;


/* ==================================================
Business Problem 8
Product Profit Consistency Across Markets
Criteria:
- Appears in at least 3 markets
- At least 50 total orders
================================================== */

SELECT
    product_name,
    COUNT(*) AS total_orders,
    COUNT(DISTINCT market) AS market_coverage,
    ROUND(AVG(profit_per_order), 2) AS avg_profit,
    ROUND(STDDEV(profit_per_order), 2) AS profit_volatility
FROM sales_profit
GROUP BY product_name
HAVING
    COUNT(*) >= 50
    AND COUNT(DISTINCT market) >= 3
ORDER BY profit_volatility ASC, avg_profit DESC;


/* ==================================================
Business Problem 9
Market-Driven Least Profit Product Leader (2018)
================================================== */

WITH region_product_profit AS (
    SELECT
        market,
        order_region,
        product_name,
        AVG(profit_per_order) AS avg_product_profit
    FROM sales_profit
    WHERE EXTRACT(YEAR FROM order_date) = 2018
    GROUP BY market, order_region, product_name
),
worst_product_per_region AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY market, order_region
            ORDER BY avg_product_profit ASC
        ) AS product_rank
    FROM region_product_profit
)
SELECT
    market,
    order_region AS region,
    product_name AS worst_product,
    ROUND(avg_product_profit, 2) AS avg_profit_per_order_2018
FROM worst_product_per_region
WHERE product_rank = 1
ORDER BY market, avg_profit_per_order_2018 ASC;


/* ==================================================
Business Problem 10
Market-Driven Profit Leader (2018)
Top market → top region → top product
================================================== */

WITH region_profit AS (
    SELECT
        market,
        order_region,
        AVG(profit_per_order) AS avg_region_profit
    FROM sales_profit
    WHERE EXTRACT(YEAR FROM order_date) = 2018
    GROUP BY market, order_region
),
product_profit AS (
    SELECT
        market,
        order_region,
        product_name,
        AVG(profit_per_order) AS avg_product_profit
    FROM sales_profit
    WHERE EXTRACT(YEAR FROM order_date) = 2018
    GROUP BY market, order_region, product_name
),
top_product_per_region AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY market, order_region
            ORDER BY avg_product_profit DESC
        ) AS product_rank
    FROM product_profit
)
SELECT
    rp.market,
    rp.order_region,
    ROUND(rp.avg_region_profit, 2) AS avg_region_profit,
    tp.product_name AS top_product,
    ROUND(tp.avg_product_profit, 2) AS top_product_profit
FROM region_profit rp
JOIN top_product_per_region tp
    ON rp.market = tp.market
   AND rp.order_region = tp.order_region
WHERE tp.product_rank = 1
ORDER BY rp.market, rp.avg_region_profit DESC;
