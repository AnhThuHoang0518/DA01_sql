--EX1
SELECT B.Continent,
FLOOR(AVG(A.Population))
FROM CITY AS A
INNER JOIN COUNTRY AS B
ON A.CountryCode = B.Code
GROUP BY B.Continent;

--EX2
SELECT 
ROUND(AVG(CASE
WHEN A.signup_action = 'Confirmed' THEN 1
ELSE 0
END), 2) AS confirm_rate
FROM texts AS A
LEFT JOIN emails AS B ON A.email_id = B.email_id;

--EX3
