--EX1
SELECT B.Continent,
FLOOR(AVG(A.Population))
FROM CITY AS A
INNER JOIN COUNTRY AS B
ON A.CountryCode = B.Code
GROUP BY B.Continent;

--EX2
