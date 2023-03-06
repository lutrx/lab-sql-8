-- Lab 2.8
USE sakila;
-- 1. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, ci.city, co.country
FROM sakila.store s 
JOIN sakila.address a 
USING (address_id)
JOIN sakila.city ci 
USING (city_id) 
JOIN sakila.country co 
USING (country_id);

-- 2. Write a query to display how much business, in dollars, each store brought in.
-- assumption: each store has just one staff, so business for each store can be calculated via the staff_id

SELECT sto.store_id, sta.staff_id, SUM(p.amount) AS sum_per_store
FROM sakila.store sto 
JOIN sakila.staff sta 
USING (store_id)
JOIN sakila.payment p 
USING (staff_id)
GROUP BY sta.staff_id;


-- 3. Which film categories are longest?
SELECT ca.name, SEC_TO_TIME(ROUND(AVG(fi.length*60), 0)) AS avg_length_of_films
FROM sakila.category ca 
JOIN sakila.film_category fica 
USING (category_id)
JOIN sakila.film fi 
USING (film_id)
GROUP BY ca.name
ORDER BY avg_length_of_films DESC;


-- 4. Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(r.inventory_id) AS freq_rented
FROM sakila.rental r 
JOIN sakila.inventory i 
USING (inventory_id)
JOIN sakila.film f 
USING (film_id)
GROUP BY f.title
ORDER BY freq_rented DESC;


-- 5. List the top five genres in gross revenue in descending order.
SELECT ca.name, SUM(p.amount) AS gross_revenue
FROM sakila.payment p 
JOIN sakila.rental r 
USING (rental_id)
JOIN sakila.inventory i 
USING (inventory_id)
JOIN sakila.film_category fica 
USING (film_id)
JOIN sakila.category ca 
USING (category_id)
GROUP BY ca.name
ORDER BY gross_revenue DESC;


-- 6. Is "Academy Dinosaur" available for rent from Store 1?
SELECT f.title, i.store_id
FROM sakila.film f 
JOIN sakila.inventory i 
USING (film_id)
WHERE f.title = 'Academy Dinosaur' AND i.store_id = '1';


-- 7. Get all pairs of actors that worked together.
SELECT fifa1.actor_id AS actor_1, fifa2.actor_id AS actor_2, fifa1.film_id AS film_id
FROM sakila.film_actor fifa1
JOIN sakila.film_actor fifa2
ON (fifa1.actor_id > fifa2.actor_id) AND (fifa1.film_id = fifa2.film_id)
ORDER BY fifa1.film_id;


-- 8. Get all pairs of customers that have rented the same film more than 3 times.
-- First step: get a table of customer pairs that rented the same film
SELECT r1.inventory_id, r1.customer_id AS c1, r2.customer_id AS c2
FROM sakila.rental r1
JOIN sakila.rental r2
ON (r1.customer_id > r2.customer_id) AND (r1.inventory_id = r2.inventory_id)
ORDER BY r1.inventory_id ASC;


-- 9. For each film, list actor that has acted in more films.