-- SQL Subquery
-- Top 10 customers by highest payment made in Top 10 countries

SELECT A.customer_id,
	A.first_name,
	A.last_name,
       C.city,
       D.country,
       SUM(amount) AS total_amount_paid
FROM customer A
INNER JOIN address B on A.address_id = B.address_id
INNER JOIN city C on B.city_id = C.city_id
INNER JOIN country D on C.country_id = D.country_id
INNER JOIN payment E on A.customer_id = E.customer_id
WHERE D.country IN                               -- Top 10 countries
	(SELECT D.country
	FROM customer A
	INNER JOIN address B ON A.address_id = B.address_id
	INNER JOIN city C ON B.city_id = C.city_id
	INNER JOIN country D on C.country_id = D.country_id
	GROUP BY D.country
	ORDER BY COUNT(customer_id) DESC
	LIMIT 10)
GROUP BY A.customer_id, C.city, d.country	
ORDER BY SUM(amount) DESC	
LIMIT 10
