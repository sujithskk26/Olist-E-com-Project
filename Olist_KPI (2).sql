create database  olist_Analysis;
use olist_analysis;
-- KPI'S-- 
#Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
#Number of Orders with review score 5 and payment type as credit card.
#Average number of days taken for order_delivered_customer_date for pet_shop
#Average price and payment values from customers of sao paulo city
#Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

 
#KPI 1: Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

SELECT
    day_type,
    total_payment,
    CONCAT(ROUND(total_payment * 100 / SUM(total_payment) OVER (),2),'%') AS payment_percentage
FROM (SELECT CASE WHEN DAYOFWEEK(o.order_purchase_timestamp) IN (1, 7)
                THEN 'Weekend'
            ELSE 'Weekday'
        END AS day_type,
        round(sum(p.payment_value),0) AS total_payment
    FROM olist_orders_dataset o
    JOIN olist_order_payments_dataset p
        ON o.order_id = p.order_id
    GROUP BY day_type
) AS x;

-------------
#KPI 2: Number of Orders with review score 5 and payment type as credit card.

SELECT 
    COUNT(order_id) AS Total_orders
FROM
    (SELECT 
        r.order_id, r.review_score, p.payment_type
    FROM
        olist_order_reviews_dataset AS r
    JOIN olist_order_payments_dataset AS p ON r.order_id = p.order_id) AS a
WHERE
    payment_type = 'credit_card'
        AND review_score = 5;
        
------------        
        
#KPI 3:Average number of days taken for order_delivered_customer_date for pet_shop

SELECT 
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date,
                    o.order_purchase_timestamp)),
            0) AS average_delivery_days
FROM
    olist_orders_dataset AS o
        JOIN
    olist_order_items_dataset AS oi ON o.order_id = oi.order_id
        JOIN
    olist_products_dataset AS p ON oi.product_id = p.product_id
WHERE
    p.product_category_name = 'pet_shop'
        AND o.order_delivered_customer_date IS NOT NULL;
  
 ---------- 
#KPI 4: Average price and payment values from customers of sao paulo city
    
    WITH orderItemsAvg AS (
Select round(AVG(item.price)) AS avg_order_item_price
from olist_order_items_dataset item
join olist_orders_dataset ord ON item.order_id = ord.order_id
join olist_customers_dataset cust ON ord.customer_id = cust.customer_id
where cust.customer_city = "Sao Paulo"
)
select
(select avg_order_item_price from orderItemsAvg) AS avg_order_item_price,
round(AVG(pmt.payment_value) )AS avg_payment_value
from olist_order_payments_dataset pmt
Join olist_orders_dataset ord ON pmt.order_id = ord.order_id
join olist_customers_dataset cust ON ord.customer_id = cust.customer_id
where cust.customer_city = "Sao Paulo";

--------------
#KPI 5: Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

SELECT 
    review.review_score,
    ROUND(AVG(DATEDIFF(order_delivered_customer_date,
                    order_purchase_timestamp)),
            0) AS Shipping_days
FROM
    olist_orders_dataset AS oi
        JOIN
    olist_order_reviews_dataset AS review ON oi.order_id = review.order_id
GROUP BY review_score
ORDER BY review_score;



