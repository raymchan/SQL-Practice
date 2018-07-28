use sakila;

-- 1a. You need a list of all the actors who have Display the first and last names of all actors from the table `actor`. 
SELECT first_name, last_name
FROM actor;


-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 
SELECT concat(UPPER(first_name),' ' ,UPPER(last_name)) as 'Actor Name'
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name='Joe';
  	
-- 2b. Find all actors whose last name contain the letters `GEN`:
SELECT first_name, last_name 
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT first_name, last_name 
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
where country IN ('Afghanistan', 'Bangladesh', 'China')

-- 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
ALTER Table actor
	add middle_name VARCHAR(50) after first_name;

  	
-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
ALTER Table actor
	Modify COLUMN middle_name BLOB(50);


-- 3c. Now delete the `middle_name` column.
ALTER Table actor
	Drop middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
Select last_name, Count(last_name)
FROM actor
GROUP BY last_name;

  	
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
Select last_name, Count(last_name)
FROM actor
GROUP BY last_name
HAVING Count(last_name)>1;

-- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
Update actor
SET first_name = 'HARPO'
WHERE last_name = 'WILLIAMS' AND first_name = 'GROUCHO';

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)
Update actor
SET first_name = 'GROUCHO'
WHERE last_name = 'WILLIAMS' AND first_name = 'HARPO';

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
CREATE SCHEMA ADDRESS if not exists ADDRESS;


-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
staff.address_id=address.address_id;
 

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 
SELECT staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff
INNER JOIN payment ON
staff.staff_id=payment.staff_id
GROUP BY first_name, last_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT film.title, count(film_actor.actor_id)
FROM film
INNER JOIN film_actor ON
film.film_id=film_actor.film_id
GROUP BY film.title;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT COUNT(inventory.film_id)
FROM inventory
INNER JOIN film ON
inventory.film_id=film.film_id
WHERE film.title="Hunchback Impossible";

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT customer.first_name, customer.last_name, SUM(payment.amount)
FROM customer
INNER JOIN payment ON
customer.customer_id=payment.customer_id
GROUP BY  customer.first_name, customer.last_name
order by customer.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 
SELECT film.title
from film
WHERE (film.title LIKE 'k%' or film.title LIKE 'q%') AND film.language_id=
(SELECT language_id
FROM language
WHERE language.name='English');

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT actor.first_name, actor.last_name
FROM actor
WHERE film_actor.actor_id=actor.actor_id AND film_actor.film_id=
(SELECT film_id
FROM film
WHERE title ='Alone Trip');
   
-- * 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT customer.first_name, customer.last_name, customer.email, address.address_id, city.city_id, country.country
FROM customer
INNER JOIN address ON customer.address_id = address.address_id 
LEFT JOIN city ON address.city_id = city.city_id
LEFT JOIN country ON city.country_id=country.country_id
WHERE country.country = 'Canada';


-- * 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT film.title, film_category.film_id, category.name
FROM film
INNER JOIN film_category ON film.film_id=film_category.film_id
INNER JOIN category ON film_category.category_id= category.category_id
WHERE category.name='Family';


-- 7e. Display the most frequently rented movies in descending order.
SELECT film.title, COUNT(rental.inventory_id)
FROM film
INNER JOIN inventory ON film.film_id=inventory.film_id
INNER JOIN rental ON inventory.inventory_id=rental.inventory_id
GROUP BY film.title
ORDER BY COUNT(rental.inventory_id) DESC;

  	
-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, SUM(payment.amount)
from store
INNER JOIN staff ON store.store_id = staff.store_id
INNER JOIN payment ON staff.staff_id=payment.staff_id
GROUP by store.store_id;


-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address ON store.address_id=address.address_id
INNER JOIN city ON address.city_id=city.city_id
INNER JOIN country ON city.country_id=country.country_id;

  	
-- 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
 SELECT category.name, SUM(payment.amount)
 FROM category
 INNER JOIN film_category ON category.category_id=film_category.category_id
 INNER JOIN inventory ON film_category.film_id=inventory.film_id
 INNER JOIN rental ON inventory.inventory_id =rental.inventory_id
 INNER JOIN payment ON rental.rental_id=payment.rental_id
 GROUP BY category.name
 ORDER BY SUM(payment.amount) DESC
 LIMIT 5;
 
 
    
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
 CREATE VIEW TOP_Revenue_MovieCategories
 AS SELECT category.name, SUM(payment.amount)
 FROM category
 INNER JOIN film_category ON category.category_id=film_category.category_id
 INNER JOIN inventory ON film_category.film_id=inventory.film_id
 INNER JOIN rental ON inventory.inventory_id =rental.inventory_id
 INNER JOIN payment ON rental.rental_id=payment.rental_id
 GROUP BY category.name
 ORDER BY SUM(payment.amount) DESC
 LIMIT 5;top_revenue_moviecategories

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM sakila.top_revenue_moviecategories;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW IF EXISTS sakila.top_revenue_moviecategories;