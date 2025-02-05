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

