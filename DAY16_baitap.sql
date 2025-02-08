--EX1
# Write your MySQL query statement below
WITH 
FIRST_ORDER_TABLE AS
(SELECT *
FROM
(SELECT *,
(CASE
WHEN order_date = customer_pref_delivery_date THEN 'immediate'
ELSE 'scheduled'
END) AS TYPE,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS FIRST_ORDER
FROM Delivery) AS A
WHERE FIRST_ORDER = 1)

SELECT 
ROUND((SELECT COUNT(*) FROM FIRST_ORDER_TABLE WHERE TYPE = 'immediate')*100.0/
COUNT(*),2) AS immediate_percentage
FROM FIRST_ORDER_TABLE;

--EX2
