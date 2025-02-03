--EX1
SELECT DISTINCT replacement_cost
FROM public.film
ORDER BY replacement_cost;

--EX2
SELECT 
CASE
WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'LOW'
WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'MEDIUM'
ELSE 'HIGH'
END AS CATEGORY
FROM public.film; --TONG QUAN

SELECT 
COUNT(*) AS SO_LUONG
FROM public.film
WHERE (CASE
WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'LOW'
WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'MEDIUM'
ELSE 'HIGH'
END) = 'LOW';

--EX3
SELECT A.title, A.length, C.name
FROM public.film AS A
JOIN public.film_category AS B ON A.film_id = B.film_id
LEFT JOIN public.category AS C ON B.category_id = C.category_id
WHERE C.name = 'Sports' OR C.name = 'Drama'
ORDER BY A.length DESC;

--EX4
SELECT C.name, COUNT(*) AS SO_LUONG
FROM public.film AS A
JOIN public.film_category AS B ON A.film_id = B.film_id
LEFT JOIN public.category AS C ON B.category_id = C.category_id
GROUP BY C.name
ORDER BY COUNT(*) DESC;

--EX5
SELECT 
A.first_name, A.last_name, COUNT(*) AS SO_LUONG
FROM public.actor AS A
LEFT JOIN public.film_actor AS B ON A.actor_id = B.actor_id
GROUP BY A.first_name, A.last_name
ORDER BY SO_LUONG DESC;

--EX6
SELECT COUNT(*)
FROM public.address AS A
LEFT JOIN public.customer AS B ON A.address_id = B.address_id
WHERE B.address_id IS NULL;

--EX7
--public.payment,public.customer,public.address,public.city
SELECT D.city_id, D.city,
SUM(A.amount) AS REVENUE
FROM public.payment AS A
JOIN public.customer AS B ON A.customer_id = B.customer_id
JOIN public.address AS C ON B.address_id = C.address_id
JOIN public.city AS D ON C.city_id = D.city_id
GROUP BY D.city_id, D.city
ORDER BY REVENUE DESC;

--EX8
SELECT 
D.city || ' ' || E.country AS CITY_COUNTRY,
SUM(A.amount) AS REVENUE
FROM public.payment AS A
JOIN public.customer AS B ON A.customer_id = B.customer_id
JOIN public.address AS C ON B.address_id = C.address_id
JOIN public.city AS D ON C.city_id = D.city_id
JOIN public.country AS E ON D.country_id = E.country_id
GROUP BY CITY_COUNTRY
ORDER BY REVENUE;









