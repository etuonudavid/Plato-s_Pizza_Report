#EXPLORATORY ANALYSIS
				
-- What months of the year had the most orders?
Select month, count(*) as Count
From orders
Group By month 
ORDER BY count DESC
Limit 5;

-- Which months had the least orders
Select month, count(*) as Count
From orders
Group By month 
ORDER BY count ASC
Limit 5;

-- INSIGHT seems the last quarter months had the least orders and 2nd and third quarter months had more sales
-- Let's confirm this by checking the orders by quarter of the year
Select quarter(date), count(*) as Count
From orders
Group By quarter(date) 
ORDER BY count DESC;

-- Just as guessed, the last quarter of the year had the least orders for pizza while the 2nd and 3rd had the highest

-- What hour of the day were more orders made
Select hour, Count(*) as Count
From orders
Group By hour 
ORDER BY count DESC
LIMIT 6;

-- INSIGHT more orders are made at 12noon to 1pm and then at evening periods from 5pm to 7pm in the evenings
-- This probably coincides with launch breaks and closing hours.

-- Confirm this by checking the spread of orders by weekdays and weekend

Select hour, Count(*) as Count
From orders
Where WEEKDAY = 'weekday'
Group By hour
ORDER BY count DESC;

Select hour, Count(*) as Count
From orders
Where WEEKDAY = 'weekday'
Group By hour
ORDER BY count DESC;

-- INSIGHTS-- As expected, on weekdays, more orders are from 12noon to 1pm and then later on in the evening by 5-7pm
-- On weekends more orders are made in the evenings from 5pm - 7pm


-- WHAT CATEGORY OF PIZZA IS ORDERED THE MOST
Select p.category, count(*) as Count 
From order_details
JOIN pizzas
	ON order_details.pizza_id = pizzas.pizza_id
JOIN pizza_types as p
	ON pizzas.pizza_type_id = p.pizza_type_id
Group by p.category
ORDER BY Count DESC;

-- INSIGHTS -- The classic category is ordered the most while the chicken category is ordered the least

-- Which category of pizza generates more revenue?
Select p.category, SUM(pizzas.price) as Revenue
From order_details
JOIN pizzas
	ON order_details.pizza_id = pizzas.pizza_id
JOIN pizza_types as p
	ON pizzas.pizza_type_id = p.pizza_type_id
Group by p.category
ORDER BY Revenue DESC;

-- INSIGHTS THe classic generates more Revenue and the veggie generates least

-- What is the most ordered pizza (The people's favourite)
Select p.name, p.category, Count(*) as Count
From order_details
JOIN pizzas
	ON order_details.pizza_id = pizzas.pizza_id
JOIN pizza_types as p
	ON pizzas.pizza_type_id = p.pizza_type_id
Group by p.name
ORDER BY Count DESC
LIMIT 10;

-- INSIGHT The Classic Deluxe Pizza is the most ordered pizza

-- What is the least favourite pizza
Select p.name, p.category, Count(*) as Count
From order_details
JOIN pizzas
	ON order_details.pizza_id = pizzas.pizza_id
JOIN pizza_types as p
	ON pizzas.pizza_type_id = p.pizza_type_id
Group by p.name
ORDER BY Count ASC
LIMIT 10;

-- INSIGHTS The Brie Carre Pizza is the least. 480 in a whole year.

-- What size of pizza is ordered the most
Select p.size, Count(*) as Count
From order_details
JOIN pizzas as p
	ON order_details.pizza_id = p.pizza_id
Group by p.size
ORDER BY Count DESC
LIMIT 10;

-- INSIGHT The Large size is mostly ordered. 

-- ON weekdays are large sizes ordered most? what of weekends?
Select p.size, o.WEEKDAY, count(*) as Count
From order_details
JOIN orders as o
	ON order_details.order_id = o.order_id
JOIN pizzas as p
	ON order_details.pizza_id = p.pizza_id
Where o.WEEKDAY = 'weekday'
Group by p.size
ORDER BY Count DESC;

-- ON weekdays are large sizes ordered most? what of weekends?
Select p.size, o.WEEKDAY, count(*) as Count
From order_details
JOIN orders as o
	ON order_details.order_id = o.order_id
JOIN pizzas as p
	ON order_details.pizza_id = p.pizza_id
Where o.WEEKDAY = 'weekend'
Group by p.size
ORDER BY Count DESC;

-- INSIGHTS The Large order is consistent on weekdays and weekends

-- How much pizza is being made during peak periods (Months first)
Select O.month, Sum(d.quantity) as 'Quantity of Pizzas', count( distinct (O.order_id)) as Orders
From order_details as d
JOIN orders as O
	ON d.order_id = O.order_id
Group By O.month
Order By Quantity DESC;

-- INSIGHTS -- About 4,392 pizzas are made from 1,935 orders in the month of July

-- How much pizza is being made during peak periods (time of day)
Select O.hour, Sum(d.quantity) as 'Quantity of Pizzas', count( distinct (O.order_id)) as Orders
From order_details as d
JOIN orders as O
	ON d.order_id = O.order_id
Group By O.month
Order By Quantity DESC;


-- On average how much orders are being placed per day
CREATE TEMPORARY TABLE avg_orders
	Select date, count(*) as Orders
	From orders
	Group By date
	Order by 1 ASC;
    
Select ROUND(Avg(Orders), 0)
From avg_orders;

-- INSIGHTS-- On average, 60 orders are placed per day