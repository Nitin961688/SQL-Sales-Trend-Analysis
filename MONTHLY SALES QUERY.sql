

DROP TABLE IF EXISTS ORDERS; 

CREATE TABLE ORDERS(
	order_id VARCHAR(20) PRIMARY KEY,
	order_date DATE NOT NULL,
	customer_id VARCHAR(20) NOT NULL,
	product_id VARCHAR(20) NOT NULL,
	category VARCHAR(20) NOT NULL,
	quantity INT NOT NULL CHECK (quantity >0),
	price NUMERIC(10,2) NOT NULL CHECK (price >=0),
	amount NUMERIC(12,2) NOT NULL CHECK (amount >=0),
	payment_method VARCHAR(20) NOT NULL,
	region VARCHAR(10) NOT NULL
)

SELECT * FROM ORDERS;

--GROUP BY QUERIES
--Total sales (amount) by Region
SELECT 
	region, SUM(amount) as total_sales
FROM ORDERS
GROUP BY region 
ORDER BY total_sales DESC;

--Count of orders by payment method
SELECT 
	payment_method, COUNT(*) AS total_orders
FROM ORDERS 
GROUP BY payment_method
ORDER BY total_orders DESC;


--Top 3 customers by total purchase
SELECT 
	customer_id, SUM(amount) as total_spent
FROM ORDERS
GROUP BY customer_iD
ORDER BY total_spent DESC
LIMIT 3;

--Average order amount by category
SELECT 
	 category, ROUND(AVG(amount),2) AS avg_total_sales
FROM ORDERS
GROUP BY category 
ORDER BY avg_total_aless


--Sales trend by order_date
SELECT 
	 order_date, ROUND(sum(amount),2) AS daliy_sales
FROM ORDERS
GROUP BY  order_date
ORDER BY  order_date;


--Running total of sales (cumulative revenue by date)
SELECT 
	order_date,
	SUM(amount) AS daliy_sale,
	SUM(SUM(amount)) OVER (ORDER BY order_date) AS running_total
FROM ORDERS
GROUP BY order_date
ORDER BY order_date
LIMIT 5;

--Percentage contribution of each category to total sales
SELECT 
	category,
	round(100.0*sum(amount)/sum(sum(amount)) over (),2) AS per_of_total
FROM ORDERS
GROUP BY category

--Find the most popular payment method in each region
SELECT DISTINCT ON (region)
	region, payment_method, count(*)
FROM ORDERS
GROUP BY region, payment_method
ORDER BY region, COUNT(*) DESC;

--Highest order amount vs average in that category
SELECT
	order_id,
	category,
	amount,
	round(AVG(amount) over (partition by category),2) as avg_category_amount,
	case when amount > avg(amount) over (partition by category)
	then 'Above Average'
	Else 'Below Average'
	end as performance
FROM ORDERS;

--Detect customers with more than 1 order
SELECT 
	 customer_id,
	 count(order_id) AS count_order,
	 sum(amount) as total_spent
FROM ORDERS
GROUP BY customer_id
HAVING count(order_id)>1;

---- Sales Trend Analysis: Monthly Revenue and Order Volume

SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
	SUM(amount) AS monthly_revenue,
    COUNT(DISTINCT order_id) AS order_volume
FROM ORDERS
GROUP BY year, month
ORDER BY year, month

--To get Top 3 months by revenue:

SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(amount) AS monthly_revenue,
    COUNT(DISTINCT order_id) AS order_volume
FROM ORDERS
GROUP BY year, month
ORDER BY monthly_revenue DESC
LIMIT 3;
