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
# Write your MySQL query statement below
WITH GROUP_BY_DAY AS
(SELECT visited_on,
SUM(amount) AS ALL_DAY_REV
FROM Customer
GROUP BY visited_on)

SELECT *,
ROUND(amount*1.0/7,2) AS average_amount
FROM (SELECT visited_on,
SUM(ALL_DAY_REV) OVER(ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount
FROM GROUP_BY_DAY) AS A
WHERE visited_on >= '2019-01-07'
ORDER BY visited_on;

--EX5
# Write your MySQL query statement below
WITH
SAME_2015TIV AS
(SELECT *
FROM(
SELECT *,
COUNT(*) OVER(PARTITION BY FINDING_SAME_2015TIV) AS SAME_2015TIV_COUNT
FROM (
SELECT *,
RANK() OVER (ORDER BY tiv_2015) AS FINDING_SAME_2015TIV
FROM Insurance) AS A) 
AS B
WHERE SAME_2015TIV_COUNT > 1)
,
NOT_SAME_LOCATION AS
(SELECT *
FROM(
SELECT *,
COUNT(*) OVER(PARTITION BY FINDING_SAME_LOCATION) AS SAME_LOCATION_COUNT
FROM 
(SELECT *,
RANK() OVER (ORDER BY lat,lon) AS FINDING_SAME_LOCATION
FROM Insurance) AS A
) AS B
WHERE SAME_LOCATION_COUNT = 1)

SELECT SUM(A.tiv_2016) AS tiv_2016
FROM SAME_2015TIV A
JOIN NOT_SAME_LOCATION B
ON A.pid = B.pid;
 
--EX6
# Write your MySQL query statement below
SELECT Department, Employee, Salary
FROM
(SELECT B.name AS Department, A.name AS Employee, A.salary AS Salary, 
DENSE_RANK() OVER(PARTITION BY B.id ORDER BY A.salary DESC) AS SALARY_RANK
FROM Employee A
JOIN Department B ON A.departmentId = B.id) AS SALARY_RANK_TABLE   
WHERE SALARY_RANK <= 3; 

--EX7
# Write your MySQL query statement below
SELECT person_name
FROM
(SELECT *,
SUM(weight) OVER(ORDER BY turn) AS CUMULATIVE_WEIGHT
FROM Queue) AS CUMULATIVE_WEIGHT_TABLE
WHERE CUMULATIVE_WEIGHT <= 1000
ORDER BY CUMULATIVE_WEIGHT DESC
LIMIT 1;

--EX8
# Write your MySQL query statement below
/*SELECT *,
(CASE
WHEN change_date = '2019-08-16' THEN '2019-08-16'
)
FROM
(SELECT *,
RANK() OVER(PARTITION BY product_id ORDER BY change_date) AS DATE_ORDER
FROM Products) AS A*/
WITH UP_TO_DATE_TABLE AS
(SELECT *,
(CASE
WHEN MAX(change_date) OVER(PARTITION BY product_id) <= '2019-08-16' THEN MAX(change_date) OVER(PARTITION BY product_id)
WHEN MIN(change_date) OVER(PARTITION BY product_id) <= '2019-08-16' AND MAX(change_date) OVER(PARTITION BY product_id) >= '2019-08-16' THEN 
(SELECT MAX(change_date) FROM Products B WHERE A.product_id = B.product_id AND change_date <= '2019-08-16')
WHEN MIN(change_date) OVER(PARTITION BY product_id) >= '2019-08-16' THEN ''
END) AS UP_TO_DATE
FROM Products A)
,
PRODUCT_DATE AS
(SELECT product_id, UP_TO_DATE
FROM UP_TO_DATE_TABLE 
GROUP BY product_id, UP_TO_DATE)

SELECT A.product_id,
(CASE
WHEN new_price IS NOT NULL THEN new_price
ELSE 10
END) AS price
FROM PRODUCT_DATE A
LEFT JOIN Products B ON A.product_id = B.product_id AND A.UP_TO_DATE = B.change_date;



