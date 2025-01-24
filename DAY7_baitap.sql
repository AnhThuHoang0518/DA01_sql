--EX1
SELECT NAME FROM STUDENTS
WHERE MARKS > 75
ORDER BY RIGHT(NAME,3), ID;

--EX2
SELECT user_id,
UPPER(LEFT(NAME,1)) || SUBSTRING(LOWER(NAME), 2) AS NAME
FROM Users
ORDER BY user_id;

--EX3
SELECT manufacturer, 
'$' ||
ROUND(SUM(total_sales)/1000000)
|| ' million' AS sales_mil
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer;

--EX4
SELECT EXTRACT (MONTH FROM submit_date) AS mth,
product_id AS product,
ROUND(AVG(stars), 2) AS avg_stars
FROM reviews
GROUP BY product_id, EXTRACT (MONTH FROM submit_date)
ORDER BY EXTRACT (MONTH FROM submit_date), product_id;

--EX5
SELECT sender_id,
COUNT (*) AS message_count
FROM messages
WHERE TO_CHAR(sent_date, 'MM-YYYY') = '08-2022'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

--EX6
SELECT tweet_id
FROM Tweets
WHERE LENGTH(content) > 15;

--EX7
SELECT
activity_date AS DAY,
COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE (EXTRACT(DOY FROM activity_date) BETWEEN EXTRACT(DOY FROM DATE '2019-07-27') - 30 AND EXTRACT(DOY FROM DATE '2019-07-27')) AND EXTRACT(YEAR FROM activity_date) = 2019 
GROUP BY activity_date;

--EX8
select COUNT(*)
from employees
WHERE EXTRACT(YEAR FROM joining_date) = 2022 AND 
EXTRACT(MONTH FROM joining_date) BETWEEN 1 AND 7;

--EX9
select POSITION('a' IN first_name),
from worker
WHERE first_name = 'Amitah';

--EX10
select *, 
CAST(SUBSTRING(TITLE FROM LENGTH(winery) + 2 FOR (POSITION(designation IN title) - LENGTH(winery) - 2)) AS INT) AS YEAR,
SUBSTRING(TITLE FROM POSITION('(' IN TITLE) + 1 FOR POSITION(')' IN TITLE) - POSITION('(' IN TITLE) - 1) 
AS TITLE
from winemag_p2
WHERE (POSITION(designation IN title) - LENGTH(winery) - 2) > 0 AND country = 'Macedonia';




