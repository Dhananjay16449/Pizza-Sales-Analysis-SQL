create database Pizzahut;

create table orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id)
);


create table order_details(
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key (order_details_id)
);


-- Q1 Retrieve the total number of orders placed.

select count(order_id) from orders;

-- Q2 Calculated the total revenue generated from pizza sales

SELECT 
    ROUND(SUM(p.price * od.quantity), 2) AS Total_revenue
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id;

-- Q3 Identify the highest priced pizza

SELECT 
    *
FROM
    pizzas
ORDER BY price DESC
LIMIT 1;

-- Q4 Identify the most common pizza size ordered.

SELECT 
    size, COUNT(size) AS count
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY size
ORDER BY count DESC
LIMIT 1;

-- Q5 List the top 5 most ordered pizza type along with their quantities.

SELECT 
    pt.name, COUNT(od.quantity) AS count
FROM
    pizzas AS p
        JOIN
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY count DESC
LIMIT 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pt.category, SUM(quantity) AS total_quantity
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;

-- Q7 Determine the distribution of orders by hour of the day.

select hour(order_time) as hours , count(order_id) as count from orders
group by hours;


-- Q8 Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;


-- Q9 Group the orders by date and calculate the average number of pizzas. 
SELECT 
    AVG(Sales_per_day) AS Avg_order_per_day
FROM
    (SELECT 
        order_date, SUM(quantity) AS Sales_per_day
    FROM
        orders AS o
    JOIN order_details AS od ON od.order_id = o.order_id
    GROUP BY order_date) AS order_quantity;



-- Q10 Determine the top 3 most ordered pizza type based on revenue.

SELECT 
    pt.name, SUM(quantity * price) AS revenue
FROM
    pizzas AS p
        JOIN
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;


-- Q11 Calculate the percentage contribution of each pizza type to total revenue. 

SELECT 
    category,
    ROUND((SUM(price * quantity) / (SELECT 
                    ROUND(SUM(p.price * od.quantity), 2)
                FROM
                    pizzas AS p
                        JOIN
                    order_details AS od ON p.pizza_id = od.pizza_id)) * 100,
            2) AS revenue_percent
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY category;


-- Q12 Analyze the cumulative revenue generated over time.
select order_date, revenue , sum(revenue) over(order by order_date) as cum_revenue from
(select order_date,sum(quantity*price) as revenue from orders as o
join order_details as od
on od.order_id = o.order_id
join pizzas as p
on p.pizza_id = od.pizza_id
group by order_date) as sales
;


-- Q13 Determine the top 3 most ordered pizza types based on revenue for each pizza category. 
select ranks , category,name from
(select category,name ,rank() over(partition by category order by revenue desc) as ranks from
(select category, name,sum(price*quantity) as revenue  from pizza_types as pt
join pizzas as p
on p.pizza_type_id = pt.pizza_type_id
join order_details as od
on od.pizza_id = p.pizza_id
group by category,name) as sales) as a
where ranks <=3
;



