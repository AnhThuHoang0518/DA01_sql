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








