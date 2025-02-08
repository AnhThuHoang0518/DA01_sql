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
# Write your MySQL query statement below
WITH A AS
(SELECT *,
ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date) AS LOGIN_RANK,
LEAD(event_date) OVER(PARTITION BY player_id ORDER BY event_date) - event_date AS DATE_DIFF
FROM Activity)

SELECT 
ROUND((SELECT COUNT(*) FROM A WHERE DATE_DIFF = 1)
/COUNT(*),2) AS fraction
FROM A
WHERE LOGIN_RANK = 1;

--EX3
# Write your MySQL query statement below
WITH CONSECUTIVE_STUDENTS AS
(SELECT *,
CEILING(id*1.0/2) AS consecutive_id
FROM Seat)

SELECT 
ROW_NUMBER() OVER() AS id,
student
FROM (SELECT *,
ROW_NUMBER() OVER(PARTITION BY consecutive_id ORDER BY id DESC) AS SWITCH1
FROM CONSECUTIVE_STUDENTS) AS SWITCH_SEAT
ORDER BY consecutive_id, SWITCH1;

--EX4
