--1.
WITH A AS
(SELECT FORMAT_DATE('%Y-%m', created_at) AS month_year,
COUNT(DISTINCT user_id) AS total_user
FROM `bigquery-public-data.thelook_ecommerce.orders` 
GROUP BY FORMAT_DATE('%Y-%m', created_at)
ORDER BY month_year)
,
B AS 
(SELECT FORMAT_DATE('%Y-%m', delivered_at) AS month_year,
COUNT(*) AS total_order
FROM `bigquery-public-data.thelook_ecommerce.orders` 
WHERE status = 'Complete'
GROUP BY FORMAT_DATE('%Y-%m', delivered_at))

SELECT A.month_year, total_user, total_order
FROM  A
JOIN B ON A.month_year = B.month_year
ORDER BY A.month_year

/*INSIGHT:
- Số lượng khách mua hàng và đơn hàng đều tăng theo thời gian
- Tỉ lệ đơn hàng hoàn thành trên số lượng khách mua hàng chưa cao chỉ ~25%
*/

--2.
