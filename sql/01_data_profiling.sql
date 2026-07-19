-- DATABASE PROFILING

-- 1: Database Overview

-- Number of unique customers
SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;

-- Number of orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Total number of products sold
SELECT SUM(order_item_id) AS total_products_sold
FROM order_items;

-- Number of different products
SELECT COUNT(*) AS number_of_products
FROM products;

SELECT COUNT(DISTINCT product_id)
FROM products;

-- Number of sellers
SELECT COUNT(*) AS number_of_sellers
FROM sellers;

SELECT COUNT(DISTINCT seller_id)
from sellers;

-- Number of reviews
SELECT COUNT(*) AS number_of_reviews
FROM reviews;

SELECT COUNT(DISTINCT review_id)
FROM reviews;

-- Number of payments
SELECT COUNT(*)
FROM payments;

SELECT COUNT(DISTINCT order_id)
FROM payments;


-- 2: Data Quality Checks

-- Orders without a customer
SELECT COUNT(*)
FROM orders
WHERE customer_id IS NULL;

-- Products without a category
SELECT COUNT (*)
FROM products 
WHERE product_category_name IS NULL;

-- Reviews without a score
SELECT COUNT (*)
FROM reviews
WHERE review_score IS NULL;

-- Payments without a value
SELECT COUNT (*)
FROM payments 
WHERE payment_value IS NULL;


-- 3: Categorical Variables

-- Order status
SELECT order_status,
       COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Payment methods
SELECT payment_type,
		COUNT (*) AS total
FROM payments
GROUP BY payment_type 
ORDER BY total DESC;

-- Review score distribution
SELECT review_score,
		COUNT(*) AS total
FROM reviews 
GROUP BY review_score 
ORDER BY review_score DESC;

-- Number of products category
SELECT COUNT(DISTINCT product_category_name)
FROM products;

SELECT product_category_name,
		COUNT(*) AS products
FROM products 
GROUP BY product_category_name 
ORDER BY products DESC;


-- 4: Relationships

-- Max products per order
SELECT MAX(products_per_order)
FROM (
SELECT order_id,
       COUNT(*) AS products_per_order
FROM order_items
GROUP BY order_id
);

-- Duplicated reviews
SELECT review_id,
       COUNT(*) AS occurrences
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

SELECT COUNT(*) AS duplicated_review_ids
FROM (
    SELECT review_id
    FROM reviews
    GROUP BY review_id
    HAVING COUNT(*) > 1
) AS duplicated_reviews;

-- Missing order in the payments table
SELECT o.order_id,
	   o.order_status
FROM orders o
LEFT JOIN payments p
ON o.order_id = p.order_id
WHERE p.order_id IS NULL;


-- 5: Temporal Coverage

-- Dataset time coverage
SELECT MIN(order_purchase_timestamp),
		MAX(order_purchase_timestamp)
FROM orders;


-- 6: Key Findings
/*

1. The database contains approximately 99k unique customers
   and 99k orders, indicating a large transactional dataset.

2. Every product and seller appears to have a unique identifier,
   making product_id and seller_id strong candidate primary keys.

3. review_id is not unique:
   several review IDs appear more than once, therefore it cannot
   be considered a candidate primary key for the reviews table.

4. The payments table contains more records than orders,
   showing that a single order can be associated with multiple
   payment transactions.

5. One order has no corresponding payment record.
   Further inspection shows that this order is not linked to
   any payment in the payments table.

6. Some products have missing product category information,
   suggesting the presence of incomplete data.

7. Customer reviews are highly concentrated on high ratings,
   with 5-star reviews representing the most frequent score.

8. The database includes multiple order statuses
   (e.g. delivered, shipped, canceled, unavailable),
   which should be considered during business analysis.


*/


















