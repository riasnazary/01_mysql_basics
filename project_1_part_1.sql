USE magist;

#wbs-platform_section1_ch7
#1. HOW MANY ORDERS ARE THERE IN THE DATASET?
SELECT COUNT(*)
FROM orders;

#2. ARE ORDERS ACTUALLY DELIVERED? 
SELECT order_status, COUNT(order_status)
FROM orders
GROUP BY order_status;

#3. IS MAGIST HAVING USER GROWTH?
SELECT YEAR(order_purchase_timestamp) YYYY, MONTH(order_purchase_timestamp) MM, COUNT(*) qty
FROM orders
GROUP BY YYYY, MM
ORDER BY YYYY, MM;

#4. IS MAGIST HAVING USER GROWTH?
SELECT COUNT(DISTINCT product_id) AS products_count
FROM products;

#5. WHICH ARE THE CATEGORIES WITH MOST PRODUCTS?
SELECT product_category_name, COUNT(*) qty
FROM products
GROUP BY product_category_name
ORDER BY qty DESC;

#6. HOW MANY OF THOSE PRODUCTS WERE PRESENT IN ACTUAL TRANSACTIONS?
SELECT count(DISTINCT product_id) n_products
FROM order_items;

#7. WHAT’S THE PRICE FOR THE MOST EXPENSIVE AND CHEAPEST PRODUCTS?
SELECT MIN(price) cheapest, MAX(price) most_expensive
FROM order_items;

#8. WHAT ARE THE HIGHEST AND LOWEST PAYMENT VALUES?
SELECT MIN(payment_value) low, MAX(payment_value) high
FROM order_payments;
