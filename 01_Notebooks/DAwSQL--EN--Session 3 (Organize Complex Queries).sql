/*
SELECT *
FROM sales.staffs
WHERE store_id =
	-- Kali Vargas works in Store # 3
	(SELECT store_id 
	FROM sales.staffs 
	WHERE first_name= 'Kali'
			and last_name='Vargas')
*/
/*
SELECT *
FROM sales.staffs
WHERE manager_id=
		--Subquery will return 7 as a staff id but we will use as a manager id in outer query
		(SELECT staff_id
		FROM sales.staffs
		WHERE first_name= 'Venita'
					and last_name='Daniel')
*/
/*
SELECT *
FROM sales.customers
WHERE city =
	(SELECT city
	FROM sales.stores
	WHERE store_name='Rowlett Bikes')
*/
/*
SELECT *
FROM production.products
WHERE list_price > 
		(SELECT list_price
		FROM production.products
		WHERE product_name='Trek CrossRip+ - 2018')
		*/
/*
SELECT * 
FROM sales.customers c
INNER JOIN sales.orders o on
		c.customer_id=o.customer_id
WHERE order_date <
		-- 2016-01-03
		(SELECT order_date 
		FROM sales.customers c
		INNER JOIN sales.orders o on
				c.customer_id=o.customer_id
		WHERE first_name='Arla' and last_name='Ellis')
*/
/*
SELECT order_date
FROM sales.orders
WHERE customer_id IN(
					SELECT customer_id
					FROM sales.customers
					WHERE city='Holbrook')
*/
/*
SELECT *
FROM sales.customers c
INNER JOIN sales.orders o on
			c.customer_id=o.customer_id
WHERE order_date IN(
				SELECT order_date
				FROM sales.customers c
				INNER JOIN sales.orders o on
							c.customer_id=o.customer_id
				WHERE first_name='Kasha' and Last_name='Todd')
*/

/*
SELECT *
FROM production.products p
WHERE list_price > ANY (
					SELECT list_price 
					FROM production.products p
					INNER JOIN production.categories c on c.category_id=p.category_id
					WHERE category_name='Electric Bikes')
		*/
/*
CREATE VIEW product_available AS

	SELECT	p.product_id
			,b.brand_name
			,c.category_name
			,s.quantity
	FROM production.products p
	JOIN production.brands b on p.brand_id=b.brand_id
	JOIN production.categories c on c.category_id=p.category_id
	JOIN production.stocks s on s.product_id=p.product_id
	WHERE p.product_id IN(
						SELECT product_id
						FROM production.stocks
						WHERE quantity > 0)
						*/
/*
SELECT *
FROM product_available
*/
CREATE TABLE order_details AS
	SELECT o.customer_id
			,oi.order_id
			--,oi.product_id	
			,oi.quantity	
			,oi.list_price	
			,oi.discount
			,p.product_name
			,p.model_year

	FROM sales.orders o
	INNER JOIN sales.order_items oi on oi.order_id=o.order_id
	INNER JOIN production.products p on p.product_id=oi.product_id


select * from order_details