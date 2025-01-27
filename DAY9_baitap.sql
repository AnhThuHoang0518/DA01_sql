--EX1
SELECT
sum(CASE
WHEN device_type = 'laptop' THEN 1
ELSE 0
END) as laptop_reviews,
sum(CASE
WHEN device_type = 'tablet' or device_type = 'phone' THEN 1
ELSE 0
END) as mobile_views
FROM viewership;

--EX2
SELECT *,
CASE
WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes'
ELSE 'No'
END triangle
FROM Triangle;

--EX3
SELECT 
ROUND(CAST(SUM(CASE
WHEN call_category = 'n/a' OR call_category IS NULL THEN 1
ELSE 0 
END) AS DECIMAL)
/CAST(COUNT(*) AS DECIMAL) * 100, 1)
FROM callers;

--EX4
SELECT 
NAME
FROM CUSTOMER
WHERE COALESCE(referee_id, 0) != 2;

--EX5
select pclass,
SUM(CASE
WHEN survived = 1 THEN 1
ELSE 0
END) AS SURVIVE,
SUM(CASE
WHEN survived = 0 THEN 1
ELSE 0
END) AS DIE
from titanic
GROUP BY pclass
