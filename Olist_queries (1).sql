-- Order Analysis
SELECT
    YEAR(order_purchase_timestamp) AS year,
    COUNT(*) AS orders
FROM olist_orders_dataset
GROUP BY year
ORDER BY year;


-- Customers by city 
SELECT
    customer_city,
    COUNT(*) AS customers
FROM olist_customers_dataset
GROUP BY customer_city
ORDER BY customers DESC
LIMIT 10;

-- Total revenue 
 SELECT ROUND(SUM(payment_value), 2) AS total_revenue
FROM olist_order_payments_dataset;

-- Top Product Categories by Revenue
SELECT
    pt.product_category_name_english,
    ROUND(SUM(oi.price), 0) AS total_revenue
FROM olist_order_items_dataset AS oi
JOIN olist_products_dataset AS p
    ON oi.product_id = p.product_id 
    join product_category_name_translation as pt
    on pt.product_category_name = p.product_category_name
GROUP BY pt.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;

-- Stored Procedure 
CALL CityRevenue('sao paulo');