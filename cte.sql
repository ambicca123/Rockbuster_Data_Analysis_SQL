-- SQL CTE query 
-- Used to find the average amount paid by the top 5 customers in the top 10 cities in Top 10 countries having highest number of customers.

WITH full_info_cte (customer_id, first_name, last_name, city, country, total_amt_paid) 
AS ( SELECT customer.customer_id, customer.first_name, customer.last_name, city.city, country.country, SUM(payment.amount) AS total_amt_paid 
FROM customer 
JOIN address ON customer.address_id = address.address_id 
JOIN city ON address.city_id = city.city_id 
JOIN country ON city.country_id = country.country_id 
JOIN payment ON payment.customer_id = customer.customer_id 
GROUP BY 1,2,3,4,5),

Top_countries (country) AS --Top 10 countries 
( SELECT country 
FROM full_info_cte 
GROUP BY country 
ORDER BY COUNT(customer_id) DESC 
LIMIT 10 ),

Top_city(city) AS --Top 10 cities 
( SELECT city, COUNT(customer_id) AS number_of_customer 
FROM full_info_cte 
WHERE country IN (SELECT country FROM Top_countries) 
GROUP BY city 
ORDER BY number_of_customer DESC 
LIMIT 10 ),

Top_customer (customer_id, first_name, last_name, city, country, total_amt_paid) AS --Top 5 Customers 
( SELECT customer_id, first_name, last_name, city, country, total_amt_paid 
FROM full_info_cte 
WHERE city IN (SELECT city FROM Top_city)
      AND country IN (SELECT country FROM Top_countries)
GROUP BY 1,2,3,4,5,6 
ORDER BY total_amt_paid DESC 
LIMIT 5 ) 

SELECT AVG(total_amt_paid) 
FROM Top_customer
