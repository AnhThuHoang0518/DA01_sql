--1.
CREATE TEMP TABLE COST_VOL_PROFIT_REV AS 
(
WITH CTE AS
(SELECT category AS Product_category, cost, sale_price,
FORMAT_DATE('%Y-%m', delivered_at) AS month,
FORMAT_DATE('%Y', delivered_at) AS year,
sale_price - cost AS profit
FROM bigquery-public-data.thelook_ecommerce.order_items AS B
JOIN bigquery-public-data.thelook_ecommerce.products A ON B.product_id = A.id
WHERE status = 'Complete')
,
CTE2 AS
(SELECT Product_category AS Product_category1, month AS month1, year AS year1, --TPV, Total_cost, Total_profit
ROUND(SUM(sale_price),2) AS TPV, 
ROUND(SUM(cost),2) AS Total_cost,
ROUND(SUM(profit),2) AS Total_profit,
FROM CTE
GROUP BY Product_category, month, year)
,
CTE3 AS
(SELECT category AS Product_category, 
FORMAT_DATE('%Y-%m', created_at) AS month,
FORMAT_DATE('%Y', created_at) AS year,
FROM bigquery-public-data.thelook_ecommerce.order_items AS B
JOIN bigquery-public-data.thelook_ecommerce.products A ON B.product_id = A.id)
,
CTE4 AS 
(SELECT Product_category AS Product_category2, month AS month2, year AS year2,
COUNT(*) AS TPO --TPO
FROM CTE3
GROUP BY Product_category, month, year)

SELECT *,
Total_profit/Total_cost AS Profit_to_cost_ratio
FROM CTE2 AS A
FULL JOIN CTE4 AS B ON A.Product_category1 = B.Product_category2 AND A.month1 = B.month2
);


WITH CTE AS
(SELECT *,
LAG(TPV) OVER(PARTITION BY Product_category2 ORDER BY month2) AS PREVIOUS_REV,
LAG(TPO) OVER(PARTITION BY Product_category2 ORDER BY month2) AS PREVIOUS_ORDER,
FROM COST_VOL_PROFIT_REV)
,
CTE2 AS 
(
SELECT *,
ROUND((TPV - PREVIOUS_REV)*100.0/PREVIOUS_REV,2) AS Revenue_growth,
ROUND((TPO - PREVIOUS_ORDER)*100.0/PREVIOUS_ORDER,2) AS Order_growth
FROM CTE 
)
SELECT Product_category2, month2, year2, TPV, Revenue_growth, TPO, Order_growth, Total_cost, Total_profit, Profit_to_cost_ratio
FROM CTE2

--NOTE: DO CÓ THÁNG CÓ ORDER NHƯNG KO CÓ REVENUE NÊN E CHIA TPO RIÊNG NHƯNG OUTPUT CUỐI CÙNG HƠI KHÓ HIỂU. CÓ THỂ THÊM "WHERE status = 'Complete' ở hàng 37 
--để coi như tháng nào có REV mới tính lượt orders

--2.RETENTION_COHORT
WITH
MIN_DATE_TABLE AS
(SELECT user_id, created_at,
MIN(created_at) OVER(PARTITION BY user_id) AS MIN_DATE
FROM bigquery-public-data.thelook_ecommerce.orders)
,
COHORT_INDEX AS
(SELECT user_id,
FORMAT_DATE('%Y-%m', MIN_DATE) AS COHORT,
DATE_DIFF(DATE(created_at), DATE(MIN_DATE), YEAR)*12 + DATE_DIFF(DATE(created_at), DATE(MIN_DATE), MONTH) + 1 AS INDEX
FROM MIN_DATE_TABLE)
,
CNT_TABLE AS
(SELECT COHORT, INDEX,
COUNT(DISTINCT user_id) AS CNT
FROM COHORT_INDEX
WHERE INDEX < 5
GROUP BY COHORT, INDEX)
,
CUSTOMER_COHORT AS
(SELECT COHORT,
SUM(CASE
WHEN INDEX = 1 THEN CNT
ELSE 0
END) AS M1,
SUM(CASE
WHEN INDEX = 2 THEN CNT
ELSE 0
END) AS M2,
SUM(CASE
WHEN INDEX = 3 THEN CNT
ELSE 0
END) AS M3,
SUM(CASE
WHEN INDEX = 4 THEN CNT
ELSE 0
END) AS M4
FROM CNT_TABLE
GROUP BY COHORT)
,
RETENTION_COHORT AS
(SELECT COHORT,
M1*100.00/M1 || '%' AS M1,
ROUND(M2*100.00/M1,2) || '%' AS M2,
ROUND(M3*100.00/M1,2) || '%' AS M3,
ROUND(M4*100.00/M1,2) || '%' AS M4
FROM CUSTOMER_COHORT)

SELECT * FROM RETENTION_COHORT
ORDER BY COHORT
