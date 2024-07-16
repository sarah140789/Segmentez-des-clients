---Q1 :---

SELECT o.order_id, o.order_status, o.order_estimated_delivery_date, o.order_delivered_customer_date , o.order_purchase_timestamp
FROM orders o
JOIN customers c ON o.customer_id= c.customer_id
WHERE o.order_status= 'delivered' 
and o.order_delivered_customer_date>=date(o.order_purchase_timestamp,'-3 months')
and DATE(o.order_delivered_customer_date) >DATE (o.order_estimated_delivery_date,'+3 days');

---Q2---

SELECT s.seller_id,s.seller_city,s.seller_state,s.seller_zip_code_prefix,SUM(op.payment_value) AS sell_total
FROM sellers AS s
LEFT JOIN order_items AS oi ON s.seller_id=oi.seller_id
LEFT JOIN orders AS o ON oi.order_id=o.order_id
LEFT JOIN order_pymts AS op ON o.order_id=op.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id 
HAVING SUM(op.payment_value)>100000;

---Q3---

SELECT s.seller_id,s.seller_city,s.seller_state,s.seller_zip_code_prefix,count(o.order_id) AS engagement FROM sellers AS s
LEFT JOIN order_items AS oi ON s.seller_id=oi.seller_id
LEFT JOIN orders AS o ON oi.order_id=o.order_id
WHERE s.seller_id IN (SELECT s.seller_id FROM sellers AS s
LEFT JOIN order_items AS oi ON s.seller_id=oi.seller_id
LEFT JOIN orders AS o ON oi.order_id=o.order_id WHERE o.order_delivered_customer_date>datetime('2018-10-17 13:22:46','-3 months'))
AND s.seller_id NOT IN (SELECT s.seller_id FROM sellers AS s
LEFT JOIN order_items AS oi ON s.seller_id=oi.seller_id
LEFT JOIN orders AS o ON oi.order_id=o.order_id WHERE o.order_delivered_customer_date<datetime('2018-10-17 13:22:46','-3 months'))
AND o.order_status='delivered'
GROUP BY s.seller_id HAVING count(o.order_id)>30

---Q4---
LEFT JOIN order_reviews orv ON o.order_id=orv.order_id
WHERE o.order_purchase_timestamp>=(
    SELECT DATE(MAX (order_purchase_timestamp),'-12 months')
    FROM orders
)
GROUP BY c.customer_zip_code_prefix
HAVING total_orders >30
ORDER BY avg_review_score ASC
LIMIT 5;


