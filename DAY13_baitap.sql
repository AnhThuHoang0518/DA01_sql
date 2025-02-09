--EX1
WITH 
ALL_DUP_JL AS
(
SELECT company_id, title, description,
COUNT(*) AS TIMES_APPEARANCE
FROM job_listings
GROUP BY company_id, title, description
HAVING COUNT(*) >= 2
)
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM ALL_DUP_JL;


--EX2
WITH
PRODUCT_REVENUE AS
(SELECT product, SUM(spend) AS total_spend
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY product)
,
BEFORE_LIMIT AS
(SELECT DISTINCT B.category ,A.product, total_spend FROM PRODUCT_REVENUE A
JOIN product_spend B ON A.product = B.product)
,
TOP_2_IN_APPLIANCE AS
(SELECT * FROM BEFORE_LIMIT
WHERE category = 'appliance'
ORDER BY total_spend DESC
LIMIT 2)
,
TOP_2_IN_electronics AS
(SELECT * FROM BEFORE_LIMIT
WHERE category = 'electronics'
ORDER BY total_spend DESC
LIMIT 2)
SELECT * FROM TOP_2_IN_APPLIANCE
UNION
SELECT * FROM TOP_2_IN_electronics
ORDER BY category, total_spend DESC;

--EX3
WITH
MEMBER_QUALIFIED AS
(SELECT policy_holder_id,
COUNT(DISTINCT case_id) AS CALL_TIME
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(DISTINCT case_id) >= 3)
SELECT COUNT(*) AS policy_holder_count
FROM MEMBER_QUALIFIED;

--EX4
SELECT page_id FROM pages
WHERE page_id NOT IN (SELECT DISTINCT page_id FROM page_likes)
ORDER BY page_id;

--EX5
WITH
SIMPLIFY_DATA AS
(SELECT DISTINCT
user_id,
EXTRACT(MONTH FROM event_date) AS MONTH
FROM user_actions
WHERE EXTRACT(MONTH FROM event_date) IN (6,7) AND
EXTRACT(YEAR FROM event_date) = 2022)
,
JUNE_USER AS
(SELECT * FROM SIMPLIFY_DATA
WHERE MONTH = 6)
,
JULY_USER AS
(SELECT * FROM SIMPLIFY_DATA
WHERE MONTH = 7)
,
ACTIVE_USER AS
(SELECT user_id FROM JULY_USER
WHERE user_id IN (SELECT user_id FROM JUNE_USER))
SELECT 
7 AS MONTH,
COUNT(user_id) AS monthly_active_users
FROM ACTIVE_USER;

--EX6
-- Write your PostgreSQL query statement below
WITH
ALL_TRANS AS
(SELECT
TO_CHAR(trans_date, 'YYYY-MM') AS month,
country,
COUNT(*) AS trans_count,
SUM(amount) AS trans_total_amount
FROM Transactions
GROUP BY TO_CHAR(trans_date, 'YYYY-MM'), country)
,
APPROVE_TRANS AS
(SELECT
TO_CHAR(trans_date, 'YYYY-MM') AS month,
country,
COUNT(*) AS approved_count,
SUM(amount) AS approved_total_amount
FROM Transactions
WHERE state = 'approved'
GROUP BY TO_CHAR(trans_date, 'YYYY-MM'), country)
SELECT A.month, A.country, trans_count, approved_count, trans_total_amount, approved_total_amount   
FROM ALL_TRANS A 
JOIN APPROVE_TRANS B ON A.month = B.month AND A.country = B.country

--EX7
-- Write your PostgreSQL query statement below
WITH
FIRST_YEAR AS
(SELECT
product_id,
MIN(year) AS year
FROM Sales
GROUP BY product_id)
SELECT A.product_id, A.year AS first_year, A.quantity, A.price
FROM Sales A
RIGHT JOIN FIRST_YEAR B
ON A.year = B.year AND A.product_id = B.product_id;

--EX8
-- Write your PostgreSQL query statement below
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product);

--EX9
-- Write your PostgreSQL query statement below
WITH MNG_LEFT AS
(SELECT DISTINCT manager_id
FROM Employees
WHERE manager_id NOT IN (SELECT employee_id FROM Employees))

SELECT employee_id FROM Employees
WHERE manager_id IN (SELECT manager_id FROM MNG_LEFT)
AND salary < 30000;

--EX10: Giong cau 1

--EX11
-- Write your PostgreSQL query statement below
WITH
TOP_USER AS
(SELECT B.name
FROM MovieRating A
JOIN Users B ON A.user_id = B.user_id
GROUP BY A.user_id, B.name
ORDER BY COUNT(*) DESC, B.name 
LIMIT 1)
,
TOP_MOVIE AS
(SELECT B.title
FROM MovieRating A
JOIN Movies B ON A.movie_id = B.movie_id
WHERE TO_CHAR(created_at, 'YYYY-MM') = '2020-02'
GROUP BY A.movie_id, B.title
ORDER BY AVG(rating) DESC, B.title 
LIMIT 1)
SELECT name AS results
FROM TOP_USER
UNION
SELECT * FROM TOP_MOVIE;




--EX12
-- Write your PostgreSQL query statement below
WITH
REQUEST_SIDE AS
(SELECT requester_id AS id,
COUNT(*) AS SL
FROM RequestAccepted
GROUP BY requester_id)
,
ACCEPT_SIDE AS
(SELECT accepter_id AS id,
COUNT(*) AS SL
FROM RequestAccepted
GROUP BY accepter_id)
,
UNION_TABLE AS
(SELECT * FROM REQUEST_SIDE 
UNION ALL
SELECT * FROM ACCEPT_SIDE)

SELECT id,
SUM(SL) AS NUM
FROM UNION_TABLE
GROUP BY id
ORDER BY NUM DESC
LIMIT 1;










