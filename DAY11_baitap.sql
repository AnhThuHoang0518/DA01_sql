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
