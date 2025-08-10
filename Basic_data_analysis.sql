CREATE DATABASE pizza_hut;

USE pizza_hut;

SELECT @@autocommit;
SET autocommit = 0;

START TRANSACTION;
# Creating a orders table and importing the data from orders csv
CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);
# It will take time to import all the data from the orders csv. Total rows are 21,350
SELECT COUNT(*) FROM orders;

# Creating a orders_details table and importing the data from order_details csv
CREATE TABLE orders_details(
	order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity TIME NOT NULL,
    PRIMARY KEY(order_details_id)
);
# It will take time to import all the data from the order_details csv. Total rows are 48,620
SELECT * FROM orders_details;

#1. Retreive the total number of orders placed
SELECT COUNT(order_id) AS Total_Orders FROM orders;

#2. calculate the total revenue generated from pizza sales
SELECT 
    ROUND(SUM(orders_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    orders_details
        JOIN
    pizzas ON pizzas.pizza_id = orders_details.pizza_id;
    
#3. Identify the highest-priced pizza.
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

#4. Identify the most common pizza size ordered.
SELECT 
    quantity, COUNT(order_details_id)
FROM
    orders_details
GROUP BY quantity;

SELECT 
    pizzas.size,
    COUNT(orders_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;

# List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.name, SUM(orders_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;

-- After every query we will run commit
COMMIT;