/* 
 */

/* EJERCICIO FINAL MÓDULO 2 - 
	RAQUEL CASTELLANOS  */
    
    
-- 1 Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT title
FROM film;

-- 2 Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT DISTINCT title
FROM film
WHERE rating = "PG-13";

-- 3 Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT DISTINCT title, description
FROM film
WHERE description REGEXP "amazin.";

-- 4 Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT DISTINCT title, length
FROM film
WHERE length > 120;

-- 5. Recupera los nombres de todos los actores
SELECT CONCAT(first_name, " ",last_name) AS ActorsNames
FROM actor;


-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT CONCAT(first_name, " ",last_name) AS ActorsNames
FROM actor
WHERE last_name IN ("Gibson");

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT CONCAT(first_name, " ",last_name) AS ActorsNames, actor_id
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT title, rating
FROM film
WHERE rating NOT IN ("R", "PG-13");

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT COUNT(film_id) AS TotalMoviesNumber , rating
FROM film
GROUP BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.customer_id) AS TotalRentedMovies
FROM customer
INNER JOIN rental
ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT count(rental.customer_id) AS TotalRentedmovies, category.name
FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT AVG(length) AS AverageLength, rating
FROM film
GROUP BY rating;

-- 13 Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT actor.first_name, actor.last_name, film.title
FROM actor
INNER JOIN film_actor ON film_actor.actor_id = actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
WHERE film.title = "Indian Love";

-- 14	Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title, description
FROM film
WHERE description LIKE ("%dog%") OR ("cat%");

-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
SELECT actor.first_name, actor.last_name
FROM actor
LEFT JOIN film_actor
ON actor.actor_id = film_actor.actor_id
WHERE film_actor.actor_id IS NULL;

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title,release_year
FROM film
WHERE release_year BETWEEN 2005 and 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT film.title, category.name 
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON category.category_id = film_category.category_id
WHERE category.name = "Family";

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas DIFERENTES.
SELECT actor.actor_id, actor.first_name, actor.last_name, COUNT(DISTINCT film_actor.film_id) AS TotalNumberFilms
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id
HAVING COUNT(DISTINCT film_actor.film_id)> 10 ;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT title
FROM film
WHERE rating = "R" AND (length> 60*2);

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT AVG(film.length) AS AverageMovieLength, category.name
FROM film
INNER JOIN film_category 
ON film.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
GROUP BY category.name
having AVG(film.length) > 120; 

-- 21. Encuentra los actores que han actuado en al menos 5 películas DIFERENTES y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
SELECT CONCAT(actor.first_name, " ", actor.last_name) AS FullName, COUNT(DISTINCT film_actor.film_id) AS TotalNumberFilms
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id
HAVING COUNT(DISTINCT film_actor.film_id) >= 5; 

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
SELECT film.title
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN (SELECT inventory_id
	FROM rental
	WHERE DATEDIFF(rental.return_date, rental.rental_date) > 5) AS RentedPlus5
    ON inventory.inventory_id = RentedPlus5.inventory_id
    GROUP BY film.title;

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
SELECT DISTINCT CONCAT(actor.first_name," ", actor.last_name) AS FullName
FROM actor
WHERE actor.actor_id NOT IN (
SELECT actor.actor_id
FROM actor AS a
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film_category ON film_actor.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE category.name = "Horror");

-- First, i just do the "horror" category subquery
SELECT actor.actor_id , category.name
FROM actor AS a
INNER JOIN film_actor ON a.actor_id = film_actor.actor_id
INNER JOIN film_category ON film_actor.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE category.name = "Horror";

-- I also check just actors+category 
SELECT distinct actor.first_name,actor.last_name, category.name
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film_category ON film_actor.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id;

-- 24 BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
-- First i check which titles are in the category "Comedy"
SELECT f.title, category.name
FROM film AS f
INNER JOIN film_category ON f.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE category.name = "Comedy";

-- And i check which movies are longer than 180 minutes.
SELECT title, length
from film
WHERE length > 180;

-- now i put everything toguether
SELECT f.title,f.length, category.name 
FROM film AS f
INNER JOIN film_category ON f.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE category.name = "Comedy"
and length > 180;

-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.
SELECT distinct actor.first_name,actor.last_name, COUNT(film_actor.film_id) AS TotalActorsPerMovie
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.first_name,actor.last_name ;


-- Query just to know if actors are in the same movies
SELECT A.actor_id, A.film_id,
B.actor_id, B.film_id
FROM film_actor as A,  film_actor as B
WHERE A.actor_id = B.actor_id
AND A.film_id <> B.film_id
AND A.film_id IN (
    SELECT film_id
    FROM film_actor
    WHERE actor_id = A.actor_id);




