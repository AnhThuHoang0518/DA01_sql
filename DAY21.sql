--1.
WITH A AS
(SELECT FORMAT_DATE('%Y-%m', created_at) AS month_year,
COUNT(*) AS total_user
FROM `bigquery-public-data.thelook_ecommerce.orders` 
GROUP BY FORMAT_DATE('%Y-%m', created_at))
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
*/

--2.

WITH A AS
(SELECT FORMAT_DATE('%Y-%m', created_at) AS month_year,
SUM(sale_price) AS REV
FROM bigquery-public-data.thelook_ecommerce.order_items
GROUP BY FORMAT_DATE('%Y-%m', created_at))
,
B AS 
(SELECT FORMAT_DATE('%Y-%m', created_at) AS month_year,
COUNT(DISTINCT user_id) AS distinct_users,
COUNT(*) AS ORDERS
FROM `bigquery-public-data.thelook_ecommerce.orders` 
GROUP BY FORMAT_DATE('%Y-%m', created_at))

SELECT A.month_year, distinct_users, 
ROUND(REV/ORDERS,2) AS average_order_value
FROM A
JOIN B ON A.month_year = B.month_year
ORDER BY A.month_year

/*INSIGHT:
- Tổng số người dùng khác nhau mỗi tháng tăng theo thời gian nhưng AOV không thay đổi nhiều
*/

--3.

