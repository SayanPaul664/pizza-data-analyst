create database pizza;
use pizza;
select * from order_details;
select * from orders;
select * from pizzas;
select * from pizza_types;

#Retrieve the total number of orders placed.
select sum(quantity) as "Total oder" from order_details;

#Calculate the total revenue generated from pizza sales.
select sum(quantity*price)AS "revenue" from order_details o join pizzas p on o.pizza_id = p.pizza_id;

#Identify the highest-priced pizza
select max(size),max(price) from pizzas group by size; 
select size,max(price) from pizzas group by size order by max(price) DESC limit 1;

#Identify the most common pizza size ordered.
select size, sum(quantity) from pizzas p join order_details o on p.pizza_id = o.pizza_id group by size order by sum(quantity) DESC;

#List the top 5 most ordered pizza types along with their quantities.
select pizza_type_id, sum(quantity) from pizzas p join order_details o on o.pizza_id = p.pizza_id group by pizza_type_id order by sum(quantity) desc limit 5  ;




#Calculate the percentage contribution of each pizza type to total revenue.
WITH PizzaTypeRevenue AS (
    SELECT
        pt.name AS pizza_type_name,
        SUM(od.quantity * p.price) AS revenue_per_pizza_type
    FROM
        order_details od
    JOIN
        pizzas p ON od.pizza_id = p.pizza_id
    JOIN
        pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY
        pt.name
),
TotalRevenue AS (
    SELECT
        SUM(od.quantity * p.price) AS overall_total_revenue
    FROM
        order_details od
    JOIN
        pizzas p ON od.pizza_id = p.pizza_id
)
SELECT
    ptr.pizza_type_name,
    ptr.revenue_per_pizza_type,
    (ptr.revenue_per_pizza_type * 100.0 / tr.overall_total_revenue) AS percentage_contribution
FROM
    PizzaTypeRevenue ptr, TotalRevenue tr
ORDER BY
    percentage_contribution DESC;



##Determine the top 3 most ordered pizza types based on revenue.
select price, category,size from pizzas a join pizza_types t on a.pizza_type_id = t.pizza_type_id  order by price DESC limit 3;



#Determine the distribution of orders by hour of the day.
select  COUNT(date),sum(quantity) ,time from orders s join order_details a on s.order_id = a.order_id group by time; 

select sum(quantity) ,time from orders s join order_details a on s.order_id = a.order_id group by time; 

select date, hour(o.time) AS order_hour, sum(Quantity)AS Number_of_oders from orders o join order_details od on o.order_id = od.order_id Group by date,order_hour ORDER BY order_hour;



##Group the orders by date and calculate the average number of pizzas ordered per day
select date,sum(quantity) from orders s join order_details a on s.order_id = a.order_id group by date; 


#Determine the top 3 most ordered pizza types based on revenue for each pizza category.
WITH PizzaCategoryRevenue AS (SELECT
        pt.category,
        pt.name AS pizza_type_name,
        SUM(od.quantity * p.price) AS total_revenue
    FROM
        order_details od
    JOIN
        pizzas p ON od.pizza_id = p.pizza_id
    JOIN
        pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY
        pt.category, pt.name
),
RankedPizzaCategoryRevenue AS (
    SELECT
        category,
        pizza_type_name,
        total_revenue,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS rn
    FROM
        PizzaCategoryRevenue
)
SELECT
    category,
    pizza_type_name,
    total_revenue
FROM
    RankedPizzaCategoryRevenue
WHERE
    rn <= 3
ORDER BY
    category, total_revenue DESC;




#paktices  how to join 2 table code:
select * from pizza_types o join pizzas p on o.pizza_type_id = p.pizza_type_id;

