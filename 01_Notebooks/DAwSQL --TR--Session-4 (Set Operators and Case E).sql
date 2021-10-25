



/*        28.07.2021 DAwSQL Session 4 -- Set Operators and Case Expression     */



--CTE's


--Ordinary CTE's

--List customers who have an order prior to the last order of a customer named Sharyn Hopkins 
--and are residents of the city of San Diego.




WITH T1 AS
(
	SELECT	MAX(B.order_date) LAST_ORDER
	FROM	sales.customers A, sales.orders B
	WHERE	A.customer_id = B.customer_id
	AND		A.first_name = 'Sharyn'
	AND		A.last_name = 'Hopkins'
)
SELECT	A.customer_id, A.first_name, last_name, city, order_date
FROM	sales.customers A, sales.orders B, T1 C
WHERE	A.customer_id = B.customer_id
AND		B.order_date < C.LAST_ORDER
AND		A.city = 'San Diego'




----------------

--Recursive CTE's

-- 0'dan 9'a kadar herbir rakam bir satýrda olacak þekide bir tablo oluþturun.

WITH T1 AS
(
SELECT 0 number
UNION ALL
SELECT number +1
FROM	T1
WHERE	number<9
)
SELECT * FROM T1



--CTE with new table Values

WITH Users As
(
SELECT * 
FROM (
		VALUES 
				(1,'start', CAST('01-01-20' AS date)),
				(1,'cancel', CAST('01-02-20' AS date)), 
				(2,'start', CAST('01-03-20' AS date)), 
				(2,'publish', CAST('01-04-20' AS date)), 
				(3,'start', CAST('01-05-20' AS date)), 
				(3,'cancel', CAST('01-06-20' AS date)), 
				(1,'start', CAST('01-07-20' AS date)), 
				(1,'publish', CAST('01-08-20' AS date))
		) as table_1 ([user_id], [action], [date])
)
SELECT * FROM Users



--------------------------///////////////////////////////////////

--UNION / UNION ALL


--List Customer's last names in Sacramento and Monroe

SELECT	last_name
FROM	sales.customers
WHERE	city = 'Sacramento'

UNION ALL

SELECT	last_name
FROM	sales.customers
WHERE	city = 'Monroe'




SELECT	last_name
FROM	sales.customers
WHERE	city IN ('Sacramento', 'Monroe')



--UNION

SELECT	last_name
FROM	sales.customers
WHERE	city = 'Sacramento'

UNION

SELECT	last_name
FROM	sales.customers
WHERE	city = 'Monroe'

----


SELECT	first_name, last_name
FROM	sales.customers
WHERE	city = 'Sacramento'

UNION

SELECT	first_name, last_name
FROM	sales.customers
WHERE	city = 'Monroe'



--

SELECT	city, 'STATE' AS STATE
FROM	sales.stores

UNION ALL

SELECT	state, 'BALDWIN' as city
FROM	sales.stores

----------

SELECT	city, 'STATE' AS STATE
FROM	sales.stores

UNION ALL

SELECT	state, 1 as city
FROM	sales.stores


-------------------///////////////////////////////////////


--INTERSECT

-- Write a query that returns brands that have products for both 2016 and 2017.



SELECT	brand_id 
FROM	production.products
WHERE	model_year= 2016

INTERSECT

SELECT	brand_id
FROM	production.products
WHERE	model_year= 2017
ORDER BY brand_id DESC



---------------

SELECT *
FROM	production.brands
WHERE	brand_id IN (
					SELECT	brand_id 
					FROM	production.products
					WHERE	model_year= 2016

					INTERSECT

					SELECT	brand_id
					FROM	production.products
					WHERE	model_year= 2017
					) 


--Write a query that returns customers who have orders for both 2016, 2017, and 2018

SELECT	first_name, last_name
FROM	sales.customers
WHERE	customer_id IN (
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2016-01-01' AND '2016-12-31'

						INTERSECT

						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2017-01-01' AND '2017-12-31'

						INTERSECT

						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31'
						)



--///////////////////////////////////////


--EXCEPT

--Write a query that returns brands that have a 2016 model product but not a 2017 model product.


SELECT *
FROM	production.brands
WHERE brand_id IN (
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year= 2016

					EXCEPT

					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2017
				)



-- Write a query that returns only products ordered in 2017 (not ordered in other years).

SELECT	product_id, product_name
FROM	production.products
WHERE	product_id IN (
					SELECT	DISTINCT B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		A.order_date BETWEEN '2017-01-01' AND '2017-12-31'

					EXCEPT

					SELECT	DISTINCT B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		A.order_date NOT BETWEEN '2017-01-01' AND '2017-12-31'
					)

---------///////////////////////////////////////


--Write a query that returns State where 'Trek Remedy 9.8 - 2017' product is not ordered


SELECT	E.[state], COUNT (D.product_id) count_of_products
FROM
		(
		SELECT	C.order_id, C.customer_id, B.product_id
		FROM	production.products A, sales.order_items B, sales.orders C
		WHERE	A.product_id = B.product_id
		AND		B.order_id = C.order_id
		AND		A.product_name = 'Trek Remedy 9.8 - 2017'
		) D
RIGHT JOIN sales.customers E ON E.customer_id = D.customer_id
GROUP BY
		E.[state]
HAVING
		COUNT (D.product_id) = 0


----



SELECT distinct state
FROM
SALES.customers X
WHERE NOT EXISTS
(
SELECT	D.STATE
FROM	production.products A, sales.order_items B, sales.orders C, sales.customers D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Trek Remedy 9.8 - 2017'
AND		D.STATE = X.STATE
) 



---

SELECT STATE
FROM	sales.customers

EXCEPT

SELECT	D.STATE
FROM	production.products A, sales.order_items B, sales.orders C, sales.customers D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Trek Remedy 9.8 - 2017'



--------------------------------------


---------///////////////////////////////////////


--CASE EXPRESSION

-- Generate a new column containing what the mean of the values in the Order_Status column.

-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed


SELECT  order_status,
		CASE order_status WHEN 1 THEN 'Pending'
						  WHEN 2 THEN 'Processing'
						  WHEN 3 THEN 'Rejected'
						  WHEN 4 THEN 'Completed'
		END AS MEANOFSTATUS
FROM	sales.orders


-- Create a new column containing the labels of the customers' email service providers ( "Gmail", "Hotmail", "Yahoo" or "Other" )

SELECT	first_name, last_name, email, CASE
				WHEN email LIKE '%@gmail.%' THEN 'Gmail' 
				WHEN email LIKE '%@hotmail.%' THEN 'Hotmail'
				WHEN email LIKE '%@yahoo.%' THEN 'Yahoo'
				WHEN email IS NOT NULL THEN 'Other'
			ELSE NULL END email_service_provider
FROM	sales.customers;








