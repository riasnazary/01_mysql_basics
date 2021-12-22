USE magist;

-- In relation to the products:

-- q1: What categories of tech products does Magist have?
SELECT *
FROM product_category_name_translation
WHERE product_category_name_english IN ('audio', 'home_appliances', 'computers', 'cool_stuff', 'computers_accessories', 'telephony')
;

-- q2: How many products of these tech categories have been sold 
-- (within the time window of the database snapshot)? 
-- What percentage does that represent from the overall number of products sold?
SELECT 
	t.product_category_name_english, 
    COUNT(p.product_id) AS sales_qty
FROM product_category_name_translation AS t
INNER JOIN products AS p ON p.product_category_name = t.product_category_name
INNER JOIN order_items AS i ON i.product_id = p.product_id  
WHERE t.product_category_name_english IN ('audio', 'home_appliances', 'computers', 'cool_stuff', 'computers_accessories', 'telephony')
GROUP BY t.product_category_name_english
;
# sum of tech products: 17,506

select count(product_id)
from order_items
;
# sum of total products: 112,650
# 0.1554016866 or 15.54% are presented by tech products.

-- q3: What’s the average price of the products being sold?
SELECT AVG(price)
FROM order_items
;
# 120.65 

-- q4: Are expensive tech products popular? 
-- * TIP: Look at the function CASE WHEN to accomplish this task.

# Donalds approach
select pcnt.product_category_name_english, oi.product_id, oi.price, count(oi.product_id) as num_orders
from order_items as oi
inner join products as p on oi.product_id = p.product_id
inner join product_category_name_translation as pcnt on pcnt.product_category_name = p.product_category_name 
where pcnt.product_category_name_english in ('audio', 'cds_dvds_musicals', 'cine_photo', 'consoles_games', 'dvds_blu_ray', 'electronics', 'computers_accessories', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony')
group by oi.product_id
having count(oi.product_id)> 1
order by oi.price desc;

# my apporach
SElECT t.product_category_name_english, i.product_id, i.price,
	CASE 
		WHEN price <= 120.65 THEN 'below avg'
        ELSE 'above avg'
	END AS price_category,
    AVG(i.price) AS 'avg_price'
FROM product_category_name_translation AS t
INNER JOIN products AS p ON p.product_category_name = t.product_category_name
INNER JOIN order_items AS i ON i.product_id = p.product_id  
WHERE t.product_category_name_english IN ('audio', 'home_appliances', 'computers', 'cool_stuff', 'computers_accessories', 'telephony')
GROUP BY t.product_category_name_english
ORDER BY price_category
;
# 2 of 6 tech products are above the overall product price


-- In relation to the sellers:
-- q5: How many sellers are there?
SELECT COUNT(seller_id)
FROM sellers
;
# 3,095 

-- q6: What’s the average monthly revenue of Magist’s sellers?
SELECT seller_id, AVG(revenue_ym)
FROM (
    SELECT 
		YEAR(shipping_limit_date), 
        MONTH(shipping_limit_date), 
        seller_id, SUM(price) AS revenue_ym  
    FROM order_items
    GROUP BY YEAR(shipping_limit_date), MONTH(shipping_limit_date), seller_id
    ) temp
GROUP BY temp.seller_id;

-- q7: What’s the average revenue of sellers that sell tech products?
SELECT rym.seller_id, AVG(rym.revenue_ym) AS avg_revenue
FROM (
    SELECT 
		YEAR(oi.shipping_limit_date), 
        MONTH(oi.shipping_limit_date), 
        oi.seller_id, SUM(oi.price) AS revenue_ym  
    FROM order_items oi
    LEFT JOIN products p ON oi.product_id = p.product_id
    WHERE p.product_category_name IN ('audio', 'home_appliances', 'computers', 'cool_stuff', 'computers_accessories', 'telephony')
    ### how can the query grab here the products with engl designation, when designations are in this table (products) in portuguese?
    GROUP BY YEAR(oi.shipping_limit_date), MONTH(oi.shipping_limit_date), oi.seller_id
    ) rym
GROUP BY rym.seller_id
ORDER BY AVG(rym.revenue_ym) DESC;

-- In relation to the delivery time:
-- q8: What’s the average time between the order being placed and the product being delivered?
SELECT AVG(timestampdiff(minute, order_purchase_timestamp, order_delivered_customer_date))
FROM orders
;
# Avg time between order being placed and product being delivered is 18,084.0378 minutes.

-- q9: How many orders are delivered on time vs orders delivered with a delay?
SELECT *#COUNT(*)
FROM orders
;
# 99,441 orders in total

SELECT COUNT(*)
FROM orders
WHERE TIMESTAMPDIFF(day, order_estimated_delivery_date, order_delivered_customer_date) > 1;
;
# Difference in days are 5710. 0,0574209833 or 5.74% of 99,441 orders had a delay of +1 day.

-- q10: Is there any pattern for delayed orders, e.g. big products being delayed more often?
SELECT avg(product_weight_g)
FROM products;
# avg weight of products is 2276.75 g

SELECT COUNT(*),
	CASE 
		WHEN p.product_weight_g <= 2276.75 THEN 'below avg'
        ELSE 'above avg'
	END AS weight_category 
FROM orders o
INNER JOIN order_items oi ON oi.order_id = o.order_id
INNER JOIN products p ON p.product_id = oi.product_id
WHERE TIMESTAMPDIFF(day, o.order_estimated_delivery_date, o.order_delivered_customer_date) > 1
GROUP BY weight_category
; 
# 4845 delayed deliveries are above the avg weight and 1482 delayed deliveries are below the avg weight.
