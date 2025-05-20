-- 1: Simple Stored Procedure for Action Movie Rentals
DELIMITER $$

CREATE PROCEDURE GetActionMovieCustomers()
BEGIN
    SELECT first_name, last_name, email
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON film.film_id = inventory.film_id
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON category.category_id = film_category.category_id
    WHERE category.name = 'Action'
    GROUP BY first_name, last_name, email;
END $$

DELIMITER ;

-- Example
CALL GetActionMovieCustomers();


-- 2: Dynamic Stored Procedure for Any Category
DELIMITER $$

CREATE PROCEDURE GetCustomersByCategory(IN category_name VARCHAR(50))
BEGIN
    SELECT first_name, last_name, email
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON film.film_id = inventory.film_id
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON category.category_id = film_category.category_id
    WHERE category.name = category_name
    GROUP BY first_name, last_name, email;
END $$

DELIMITER ;

-- Example
CALL GetCustomersByCategory('Animation');


-- 3: Movies Per Category Over a Threshold
-- Base Query
SELECT category.name AS category, COUNT(film.film_id) AS movie_count
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON category.category_id = film_category.category_id
GROUP BY category.name
HAVING COUNT(film.film_id) > 50;

-- Stored Procedure
DELIMITER $$

CREATE PROCEDURE GetPopularCategories(IN min_movie_count INT)
BEGIN
    SELECT category.name AS category, COUNT(film.film_id) AS movie_count
    FROM film
    JOIN film_category ON film.film_id = film_category.film_id
    JOIN category ON category.category_id = film_category.category_id
    GROUP BY category.name
    HAVING COUNT(film.film_id) > min_movie_count;
END $$

DELIMITER ;

-- Example
CALL GetPopularCategories(30);