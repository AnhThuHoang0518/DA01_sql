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
WHERE A.month_year BETWEEN '2019-01' AND '2022-04'
ORDER BY A.month_year


/*INSIGHT:
- Tổng số người dùng khác nhau mỗi tháng tăng theo thời gian nhưng AOV không thay đổi nhiều
*/

--3.
CREATE TEMP TABLE young AS
(SELECT first_name, last_name, gender, age,
'youngest' AS tag
FROM
(SELECT first_name, last_name, gender, age,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY age) AS AGE_RANK
FROM bigquery-public-data.thelook_ecommerce.users) AS A
WHERE AGE_RANK = 1);

CREATE TEMP TABLE old AS
(SELECT first_name, last_name, gender, age,
'oldest' AS tag
FROM
(SELECT first_name, last_name, gender, age,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY age DESC) AS AGE_RANK
FROM bigquery-public-data.thelook_ecommerce.users) AS A
WHERE AGE_RANK = 1);

SELECT * FROM young
UNION DISTINCT
SELECT * FROM old;

SELECT COUNT(*) FROM young;

SELECT COUNT(*) FROM old;


/*INSIGHT:
- Trẻ nhất là 12 tuổi, số lượng 1629 người
- Lớn nhất là 70 tuổi, số lượng 1713 người
*/

--4.

/*INSIGHT:
- 
*/

