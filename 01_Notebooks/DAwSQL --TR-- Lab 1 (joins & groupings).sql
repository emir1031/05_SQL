

----------- 16.07.2021 DAwSQL Lab 1 ---------



--Write a query that returns the average prices according to brands and categories.


SELECT	A.brand_name, B.category_name, AVG (C.list_price) AVG_PRICE
FROM	production.brands A, production.categories B, production.products C
WHERE	A.brand_id = C.brand_id
AND		B.category_id = C.category_id
GROUP BY
		A.brand_name, B.category_name
ORDER BY
		1,2 DESC




-------------//////////////////


--Write a query that returns the store which has the most sales quantity in 2016.


SELECT TOP 20*
FROM	sales.orders

SELECT TOP 20 *
FROM sales.order_items



SELECT *
FROM	sales.stores




SELECT	TOP 1 C.store_id, C.store_name, SUM (B.quantity) TOTAL_PRODUCT
FROM	SALES.orders A, sales.order_items B, sales.stores C
WHERE	A.order_id = B.order_id
AND		A.store_id = C.store_id
AND		A.order_date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY
		C.store_id, C.store_name
ORDER BY
		TOTAL_PRODUCT DESC





SELECT	TOP 1 C.store_id, C.store_name, SUM  (B.quantity) TOTAL_PRODUCT
FROM	SALES.orders A, sales.order_items B, sales.stores C
WHERE	A.order_id = B.order_id
AND		A.store_id = C.store_id
AND		A.order_date LIKE '%2016%'
GROUP BY
		C.store_id, C.store_name
ORDER BY
		TOTAL_PRODUCT DESC


---------------////////////////////

--Write a query that returns State where 'Trek Remedy 9.8 - 2017' product is not ordered

--STATE -- CUSTOMER
--PRODUCT NAME -- PRODUCTS
-- ORDERS TABLE

SELECT *
FROM	SALES.customers
 


 SELECT E.STATE, COUNT (product_id) CNT_PRODUCT
 FROM
	 (
	 SELECT C.order_id, C.customer_id, A.product_id, product_name
	 FROM	production.products A, 
			sales.order_items B, 
			sales.orders C
	 WHERE	A.product_id = B.product_id
	 AND	B.order_id = C.order_id
	 AND	A.product_name = 'Trek Remedy 9.8 - 2017'
	 ) D
RIGHT JOIN
SALES.customers E ON D.customer_id = E.customer_id
GROUP BY
		E.state
HAVING
		COUNT (product_id) =0






