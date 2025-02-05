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
