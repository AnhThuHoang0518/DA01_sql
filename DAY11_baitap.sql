--EX1
SELECT B.Continent,
FLOOR(AVG(A.Population))
FROM CITY AS A
INNER JOIN COUNTRY AS B
ON A.CountryCode = B.Code
GROUP BY B.Continent;

--EX2
SELECT 
ROUND(CAST(COUNT(B.email_id) AS DECIMAL)
/COUNT(A.email_id), 2)
FROM emails AS A
LEFT JOIN texts AS B ON A.email_id = B.email_id AND signup_action = 'Confirmed';

--EX3
SELECT age_bucket,
ROUND(SUM(CASE 
WHEN activity_type = 'send' THEN time_spent
ELSE 0
END) * 100.0/
SUM(CASE 
WHEN activity_type = 'open' THEN time_spent
WHEN activity_type = 'send' THEN time_spent
ELSE 0
END),2) 
AS send_perc,
ROUND(SUM(CASE 
WHEN activity_type = 'open' THEN time_spent
ELSE 0
END) * 100.0/
SUM(CASE 
WHEN activity_type = 'open' THEN time_spent
WHEN activity_type = 'send' THEN time_spent
ELSE 0
END),2)
AS open_perc
FROM activities AS A
LEFT JOIN age_breakdown AS B ON A.user_id = B.user_id
GROUP BY age_bucket;

--EX4
SELECT 
customer_id
FROM customer_contracts AS A
LEFT JOIN products AS B ON A.product_id = B.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT product_category) = 3;

--EX5
-- Write your PostgreSQL query statement below
SELECT MNG.employee_id, MNG.name, 
COUNT(*) AS reports_count,
ROUND(AVG(EMP.age),0) AS average_age
FROM Employees AS EMP
INNER JOIN Employees AS MNG ON EMP.reports_to = MNG.employee_id
GROUP BY MNG.employee_id, MNG.name
ORDER BY MNG.employee_id;

--EX6
-- Write your PostgreSQL query statement below
SELECT product_name, SUM(unit) AS unit
FROM Orders AS A
LEFT JOIN Products AS B ON A.product_id = B.product_id
WHERE EXTRACT(MONTH FROM order_date) = 2 AND EXTRACT(YEAR FROM order_date) = 2020
GROUP BY product_name
HAVING SUM(unit) >= 100;


--EX7
SELECT A.page_id
FROM pages AS A
FULL JOIN page_likes AS B ON A.page_id = B.page_id
WHERE B.page_id IS NULL
ORDER BY A.page_id;








