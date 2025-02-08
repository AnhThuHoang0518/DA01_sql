--EX1
WITH TWT_curr_year_spend AS
(SELECT EXTRACT(YEAR FROM transaction_date) AS year,
product_id,
SUM(spend) AS curr_year_spend
FROM user_transactions
GROUP BY EXTRACT(YEAR FROM transaction_date),
product_id)
SELECT *,
LAG(curr_year_spend) OVER(PARTITION BY product_id ORDER BY year) AS prev_year_spend,
ROUND((curr_year_spend/LAG(curr_year_spend) OVER(PARTITION BY product_id ORDER BY year) - 1)*100.0,2) AS yoy_rate
FROM TWT_curr_year_spend;

--EX2
WITH MONTH_ORDER AS
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) AS M_ORDER
FROM monthly_cards_issued)
SELECT card_name, issued_amount
FROM MONTH_ORDER
WHERE M_ORDER = 1
ORDER BY issued_amount DESC;

--EX3
SELECT user_id, spend, transaction_date
FROM(SELECT *,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS TRANS_ORDER
FROM transactions) AS T_ORDER
WHERE TRANS_ORDER = 3;

--EX4
SELECT transaction_date, user_id,
COUNT(*) AS purchase_count
FROM (SELECT *,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS TRANS_RANK
FROM user_transactions) AS T_RANK
WHERE TRANS_RANK = 1
GROUP BY transaction_date, user_id
ORDER BY transaction_date;

--EX5
SELECT 
user_id, tweet_date, ROUND(rolling_avg_3d,2)
FROM (SELECT *,
AVG(tweet_count) OVER(PARTITION BY user_id
                      ORDER BY tweet_date
                      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg_3d
FROM tweets) AS ROLLING_AVG;

--EX6








