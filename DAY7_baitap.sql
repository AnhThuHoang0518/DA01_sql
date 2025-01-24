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

