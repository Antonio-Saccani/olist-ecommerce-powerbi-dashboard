-- BUSINESS ANALYSIS

-- 1. Executive KPIs

-- Total revenues
SELECT SUM(payment_value) AS total_revenue 
FROM payments; 

-- Total orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Total customers
SELECT COUNT(DISTINCT customer_unique_id) AS total_unique_customers
FROM customers;

-- Average revenues in time
SELECT
    strftime('%Y-%m', o.order_purchase_timestamp) AS year_month,
    ROUND(SUM(p.payment_value),2) AS monthly_revenue
FROM orders o
JOIN payments p ON o.order_id = p.order_id
WHERE order_status = 'delivered'
GROUP BY year_month
ORDER BY year_month;

-- Average order value
SELECT AVG(order_value) AS average_order_value
FROM (
    SELECT order_id,
           SUM(payment_value) AS order_value
    FROM payments
    GROUP BY order_id
) AS order_totals;

-- Average review score
SELECT AVG(review_score)
FROM reviews;


-- 2: Customer Analysis

-- Customers per state
SELECT customer_state,
		COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers 
GROUP BY customer_state 
ORDER BY total_customers DESC;

-- Total revenues per state
SELECT c.customer_state,
		SUM(p.payment_value) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY customer_state
ORDER BY total_revenue DESC;

-- Recurrent customers
SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) > 1
) AS customer_orders;

-- Average order value per state
SELECT customer_state,
    AVG(order_value) AS average_order_value
FROM(
    SELECT
        c.customer_state,
        o.order_id,
        SUM(p.payment_value) AS order_value
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN payments p ON o.order_id = p.order_id
    GROUP BY c.customer_state,
             o.order_id
) AS orders_summary
GROUP BY customer_state
ORDER BY average_order_value DESC;

-- N.of orders vs n. of customers
SELECT
    orders_count,
    COUNT(*) AS customers
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS orders_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
GROUP BY orders_count
ORDER BY orders_count;

-- 3: Product Analysis

-- Revenues by category
SELECT
    product_category_name_english,
    SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_translation pt ON p.product_category_name = pt.product_category_name
GROUP BY pt.product_category_name_english
ORDER BY total_revenue DESC;

-- Products sold by category
SELECT 
	product_category_name_english,
	COUNT(*) AS total_products
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id 
JOIN product_category_translation pt ON p.product_category_name = pt.product_category_name
GROUP BY product_category_name_english 
ORDER BY total_products DESC;

-- Average products price per category
SELECT 
	product_category_name_english,
	AVG(oi.price) AS average_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id 
JOIN product_category_translation pt ON p.product_category_name = pt.product_category_name
GROUP BY product_category_name_english 
ORDER BY average_price DESC;

-- Average review score per category
SELECT
    product_category_name_english,
    AVG(review_score) AS average_review_score
FROM reviews r
JOIN orders o
    ON r.order_id = o.order_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN product_category_translation pt
    ON p.product_category_name = pt.product_category_name
GROUP BY product_category_name_english
ORDER BY average_review_score DESC;

-- Top 10 most sold products
SELECT
    oi.product_id,
    pt.product_category_name_english,
    COUNT(*) AS total_units_sold
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN product_category_translation pt
    ON p.product_category_name = pt.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY
    oi.product_id,
    pt.product_category_name_english
ORDER BY total_units_sold DESC
LIMIT 10;


--4: Logistics Analysis

-- Average delivery time
SELECT
    ROUND(
        AVG(
            JULIANDAY(order_delivered_customer_date)
            -
            JULIANDAY(order_purchase_timestamp)
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL;

-- Delivery time per state
SELECT customer_state,
    ROUND(
        AVG(
            JULIANDAY(order_delivered_customer_date)
            -
            JULIANDAY(order_purchase_timestamp)
        ),
        2
    ) AS average_delivery_days
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY average_delivery_days ASC;

-- Average delivery delay
SELECT  ROUND(
			AVG(
			JULIANDAY(order_delivered_customer_date)
			- 
			JULIANDAY(order_estimated_delivery_date)))
FROM orders o 
WHERE order_delivered_customer_date > order_estimated_delivery_date
AND order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL;

-- Percentage of delayed deliveries
SELECT ROUND(
			AVG(
				CASE
					WHEN order_delivered_customer_date > order_estimated_delivery_date
					THEN 1.0
					ELSE 0.0
				END) * 100,
				2) AS late_delivery_percentage
FROM orders o
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL;

-- Average delivery time variation in time
SELECT
    strftime('%Y-%m', o.order_purchase_timestamp) AS year_month,
    ROUND(
        AVG(
            JULIANDAY(o.order_delivered_customer_date)
            -
            JULIANDAY(o.order_purchase_timestamp)
        ),
        2
    ) AS average_delivery_days
FROM orders o
WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY year_month
ORDER BY year_month;



-- 5: Customer Satisfaction Analysis

-- Review distribution
SELECT review_score,
		COUNT(*) AS number_of_reviews
FROM reviews r
WHERE review_score IN (1,2,3,4,5)
GROUP BY review_score 
ORDER BY review_score DESC;

-- Impact of delay on reviews: on time vs late deliveries
SELECT
    CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,
    COUNT(*) AS number_of_orders,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM orders o
JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
AND o.order_delivered_customer_date IS NOT NULL
AND r.review_score IN (1,2,3,4,5)
GROUP BY
    CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 'Late'
        ELSE 'On Time'
    END
ORDER BY average_review_score DESC;

-- Average review per state
SELECT 
		customer_state AS State,
		ROUND(AVG(review_score), 2) AS average_review_score,
		COUNT(*) AS number_of_reviews
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN reviews r ON o.order_id = r.order_id
WHERE review_score IN (1,2,3,4,5)
AND order_status = 'delivered'
GROUP BY State 
ORDER BY average_review_score DESC;

-- Average reviews variation in time
SELECT
    strftime('%Y-%m', r.review_creation_date) AS year_month,
    ROUND(AVG(r.review_score), 2)
FROM reviews r
WHERE year_month IS NOT NULL
GROUP BY year_month
ORDER BY year_month;		



-- BUSINESS INSIGHTS

/*

1. São Paulo (SP) generates the highest revenue and has the largest customer base.

2. The average order value is approximately 161 BRL.

3. Home & Furniture and Bed Bath & Table are among the best-selling product categories.

4. Orders delivered late receive significantly lower review scores than on-time deliveries.

5. Average delivery time is approximately 12.5 days.

6. Only a relatively small share of customers place more than one order, indicating low customer retention.

7. Credit card is by far the most frequently used payment method.

*/