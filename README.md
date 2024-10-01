# Pizza-Sales-Analysis-SQL

## Project Overview

**Project Title**: Pizza Sale Analysis

**Software**: MySQL

**Database**: `Pizzahut`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore and analyze pizza sales data. The project involves setting up a pizzahut database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives

1. **Set up a Pizzahut database**: Create and populate a pizzahut database.
2. **Set up different tables**: Create and populate *order_details*, *orders*, *pizza_types* and *pizzas* table with the provided data.
3. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts with creating a database named `Pizzahut`.
- **Table Creation**:Tables named `order_details`, `orders`, `pizza_types` and `pizzas` is created to store respective data.

```sql
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


create table pizza_types(
pizza_type_id text not null,
name text,
category text,
ingredients text,
primary key(pizza_type_id)
);


create table pizzas(
pizza_id text not null,
pizza_type_id text not null,
size text,
price double,
primary key(pizza_id)
);
```

## 2. Business Analysis and Findings

The following SQL queries were developed to answer specific business questions:

1. **Retrieve the total number of orders placed.**
```sql
select count(order_id) from orders;
```

2. **Calculated the total revenue generated from pizza sales.**
```sql
SELECT 
    ROUND(SUM(p.price * od.quantity), 2) AS Total_revenue
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id;
```

3. **Identify the highest priced pizza.**
```sql
SELECT 
    *
FROM
    pizzas
ORDER BY price DESC
LIMIT 1;
```

4. **Identify the most common pizza size ordered.**
```sql
SELECT 
    size, COUNT(size) AS count
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY size
ORDER BY count DESC
LIMIT 1;
```

5. **List the top 5 most ordered pizza type along with their quantities.**
```sql
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
```

6. **Join the necessary tables to find the total quantity of each pizza category ordered.**
```sql
SELECT 
    pt.category, SUM(quantity) AS total_quantity
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;
```

7. **Determine the distribution of orders by hour of the day.**
```sql
select hour(order_time) as hours , count(order_id) as count from orders
group by hours;
```

8. **Join relevant tables to find the category-wise distribution of pizzas.**
```sql
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;
```

9. **Group the orders by date and calculate the average number of pizzas.**
```sql 
SELECT 
    AVG(Sales_per_day) AS Avg_order_per_day
FROM
    (SELECT 
        order_date, SUM(quantity) AS Sales_per_day
    FROM
        orders AS o
    JOIN order_details AS od ON od.order_id = o.order_id
    GROUP BY order_date) AS order_quantity;
```

10. **Determine the top 3 most ordered pizza type based on revenue.**
```sql
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
```

11. **Calculate the percentage contribution of each pizza type to total revenue.** 
```sql
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
```

12. **Analyze the cumulative revenue generated over time.**
```sql
select order_date, revenue , sum(revenue) over(order by order_date) as cum_revenue from
(select order_date,sum(quantity*price) as revenue from orders as o
join order_details as od
on od.order_id = o.order_id
join pizzas as p
on p.pizza_id = od.pizza_id
group by order_date) as sales
;
```

13. **Determine the top 3 most ordered pizza types based on revenue for each pizza category.**
```sql 
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
```

## Findings

- The highest-priced pizza on the menu is "The Greek Pizza."
- The most frequently ordered pizza size is large.
- "The Classic Deluxe Pizza" is the most popular pizza, with "classic" being the favored category.
- Sales peak during the hours of 17:00 to 19:00.
- The average daily order value is $138.47.
- "The Thai Chicken Pizza" generates the highest revenue among all pizzas.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.


Thank you....
  
