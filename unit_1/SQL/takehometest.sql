-- Create a query that returns the name of the most popular item in every state and the state. *
WITH
	customer_tx
AS (
	SELECT
		transactions.product_id,
		customers.state,
		COUNT(transactions.product_id) as prod_ct
	FROM 
		transactions
	LEFT JOIN
		customers
	ON transactions.customer_id = customers.customer_id
	GROUP BY customers.state, transactions.product_id
)
SELECT
	cpt.product_name,
	cpt.state,
	cpt.prod_ct
FROM(
	SELECT
		products.product_name,
		customer_tx.state,
		customer_tx.prod_ct, 
		RANK() OVER(PARTITION BY customer_tx.state ORDER BY customer_tx.prod_ct DESC) as rk
	FROM 
		products
	JOIN
		customer_tx
	ON customer_tx.product_id = products.product_id) as cpt
WHERE rk = 1;

-- Create a query that returns the name and purchase amount of the five customers in each state who have spent the most money. *

WITH 
	customer_tx
AS(
	SELECT
		customer_id,
		SUM(transact_amt) as total_spent,
		payment_success
	FROM transactions
	WHERE payment_success = 1
	GROUP BY customer_id, payment_success
)
SELECT
	cpt.name,
	cpt.state,
	cpt.total_spent
FROM(
	SELECT
		customers.name,
		customers.state,
		customer_tx.total_spent, 
		RANK() OVER(PARTITION BY customers.state ORDER BY customer_tx.total_spent DESC) as rk
	FROM 
		customers
	JOIN
		customer_tx
	ON customer_tx.customer_id = customers.customer_id) as cpt
WHERE rk < 6;

-- Create a query that returns the five most popular items for users with a ‘gmail’ email in the past 30 days, based on number of sales. *

-- Assuming no future dates for transactions, else use AND transact_at < 2019-07-20
WITH
	gmailers
AS(
	SELECT 
		customers.customer_id,
		email
	FROM
		customers
	WHERE email ~ '@gmail.com'
	)
SELECT 
	transactions.product_id,
	COUNT(transactions.transact_at) AS total
FROM
	transactions
JOIN
	gmailers
ON 
	gmailers.customer_id = transactions.customer_id
WHERE 
	transact_at >= '2019-06-19'
GROUP BY product_id
ORDER BY total DESC
LIMIT 5;
