/*
1) Doanh thu theo từng ProductLine, Year  và DealSize?
Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE
*/
--
SELECT PRODUCTLINE, DEALSIZE, YEAR_ID,
SUM(sales) AS REVENUE
FROM public.sales_dataset_rfm_prj_clean
GROUP BY PRODUCTLINE, DEALSIZE, YEAR_ID
ORDER BY PRODUCTLINE, DEALSIZE, YEAR_ID;


/*
2) Đâu là tháng có bán tốt nhất mỗi năm?
Output: MONTH_ID, REVENUE, ORDER_NUMBER
*/
WITH REVENUE_RANK AS
(SELECT *,
DENSE_RANK() OVER(PARTITION BY year_id ORDER BY REVENUE DESC) AS REV_RANK
FROM
(SELECT ordernumber, year_id, month_id, 
SUM(sales) OVER(PARTITION BY year_id, month_id) AS REVENUE
FROM public.sales_dataset_rfm_prj_clean) AS A)

SELECT ordernumber, MONTH_ID, year_id, REVENUE
FROM REVENUE_RANK
WHERE REV_RANK = 1;


/*
3) Product line nào được bán nhiều ở tháng 11?
Output: MONTH_ID, REVENUE, ORDER_NUMBER
*/
WITH REVENUE_RANK AS
(SELECT *,
DENSE_RANK() OVER(ORDER BY REVENUE) AS REV_RANK
FROM
(SELECT ordernumber, month_id, productline, 
SUM(sales) OVER(PARTITION BY productline) AS REVENUE
FROM public.sales_dataset_rfm_prj_clean
WHERE month_id = 11) AS A)

SELECT ordernumber, month_id, REVENUE
FROM REVENUE_RANK
WHERE REV_RANK <= 3; --TOP 3 PRODUCT LINE BAN CHAY NHAT T11


/*
4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
Xếp hạng các các doanh thu đó theo từng năm.
Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK
*/
WITH REV_RANK_BY_YEAR AS
(SELECT *, 
DENSE_RANK() OVER(PARTITION BY year_id ORDER BY REVENUE DESC) AS REV_RANK
FROM
(SELECT productcode, year_id, 
SUM(sales) AS REVENUE
FROM public.sales_dataset_rfm_prj_clean
WHERE country = 'UK'
GROUP BY productcode, year_id) AS A)

SELECT productcode, year_id, REVENUE,
DENSE_RANK() OVER(ORDER BY REVENUE DESC) AS RANK
FROM REV_RANK_BY_YEAR
WHERE REV_RANK = 1;

/*
5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
(sử dụng lại bảng customer_segment ở buổi học 23)
*/

WITH R_F_M AS
(SELECT customername,
CURRENT_DATE - MAX(orderdate) AS R,
COUNT(*) AS F,
SUM(sales) AS M
FROM public.sales_dataset_rfm_prj_clean
GROUP BY customername)
,
R_F_M_SCORE AS
(SELECT customername, 
NTILE(5) OVER(ORDER BY R DESC) AS R_SCORE,
NTILE(5) OVER(ORDER BY F) AS F_SCORE,
NTILE(5) OVER(ORDER BY M) AS M_SCORE
FROM R_F_M)
,
RFM_SCORE AS
(SELECT customername,
R_SCORE::VARCHAR || F_SCORE::VARCHAR || M_SCORE::VARCHAR AS RFM_SCORE
FROM R_F_M_SCORE)

SELECT customername, RFM_SCORE, segment
FROM
(SELECT *
FROM RFM_SCORE A
JOIN public.segment_score B 
ON A.RFM_SCORE = B.scores) C
WHERE segment = 'Champions'

