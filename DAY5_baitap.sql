--EX1
SELECT DISTINCT CITY
FROM STATION 
WHERE ID%2 = 0;

--EX2
SELECT 
COUNT(*) - COUNT(DISTINCT CITY) AS DIFFERENCE
FROM STATION;

--EX3


--EX4
SELECT 
ROUND(CAST(SUM(order_occurrences*item_count)/SUM(order_occurrences) AS DECIMAL),1)
FROM items_per_order;

--EX5
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(*) = 3;

--EX6
SELECT user_id,
MAX(DATE(post_date)) - MIN(DATE(post_date)) AS DATE_DIFF
FROM posts
WHERE post_date BETWEEN '2021-01-01 0:0:0' AND '2021-12-31 23:59:59'
GROUP BY user_id
HAVING COUNT(*) >= 2;

--EX7
SELECT card_name,
MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

--EX8
SELECT manufacturer,
COUNT(*) AS drug_count,
ABS(SUM(total_sales - cogs)) AS total_loss
FROM pharmacy_sales
WHERE total_sales - cogs <0
GROUP BY manufacturer
ORDER BY drug_count DESC, total_loss DESC;

--EX9
SELECT *
FROM Cinema
WHERE id%2 = 1 
AND description != 'boring'
ORDER BY rating DESC;

--EX10
SELECT teacher_id,
COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id;

--EX11
SELECT user_id,
COUNT(*) AS followers_count
FROM Followers
GROUP BY user_id;

--EX12
SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(*) >= 5




