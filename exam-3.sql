--Question 1

SELECT * FROM dishes WHERE price<20;

--Question 2

SELECT dishes.name FROM dishes
JOIN chefs ON dishes.chef_id=chefs.id
JOIN restaurants ON chefs.restaurant_id=restaurants.id
WHERE cuisine_type IN ('Française', 'Italienne');

--Question 3

SELECT ingredients.name FROM ingredients
JOIN dishes ON dishes.id=ingredients.dish_id
WHERE dishes.name="Bœuf Bourguignon";

--ou

SELECT ingredients.name FROM ingredients
WHERE dish_id=1;

--Question 4

SELECT chefs.name, restaurants.name FROM chefs
JOIN restaurants ON chefs.restaurant_id=restaurants.id;

--Question 5

SELECT chefs.name, COUNT(dishes.chef_id) FROM chefs
JOIN dishes ON dishes.chef_id=chefs.id
GROUP BY chefs.name;

--Question 6

SELECT chefs.name, COUNT(dishes.chef_id) FROM chefs
JOIN dishes ON dishes.chef_id=chefs.id
GROUP BY chefs.name
HAVING COUNT(dishes.chef_id)>1;


--Question 7

SELECT COUNT(chefs.name) FROM chefs
JOIN dishes ON dishes.chef_id=chefs.id
GROUP BY chefs.name
HAVING COUNT(dishes.chef_id)=1;

--Question 8

SELECT COUNT(dishes.id), restaurants.cuisine_type FROM dishes
JOIN chefs ON dishes.chef_id=chefs.id
JOIN restaurants ON chefs.restaurant_id=restaurants.id
GROUP BY restaurants.cuisine_type;

--Question 9

SELECT AVG(dishes.price), restaurants.cuisine_type FROM dishes
JOIN chefs ON dishes.chef_id=chefs.id
JOIN restaurants ON chefs.restaurant_id=restaurants.id
GROUP BY restaurants.cuisine_type;

--Question 10

SELECT AVG(dishes.price), chefs.name, COUNT(dishes.chef_id) AS 'plats_créés' FROM dishes
JOIN chefs ON dishes.chef_id=chefs.id
GROUP BY chefs.id
HAVING plats_créés>1;