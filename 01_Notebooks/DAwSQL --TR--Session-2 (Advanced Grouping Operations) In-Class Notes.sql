



---------15.07.2021 DAwSQL Session 2 (Advanced Grouping Operations)----------



------ CROSS JOIN ------
-- Write a query that returns all brand x category possibilities.

--Expected columns: brand_id, brand_name, category_id, category_name




SELECT *
FROM		production.brands
CROSS JOIN	production.categories
ORDER BY	brand_id



------////////////////---------

--SELF JOIN
-- Write a query that returns the staffs with their managers.
--Expected columns: staff first name, staff last name, manager name



SELECT	A.first_name AS staff_name, A.last_name AS Staff_LastName, B.first_name as Manager
FROM	SALES.staffs A, sales.staffs B
WHERE	A.manager_id = B.staff_id


select  * from sales.staffs


-----------///////////-----------


--GROUPING OPERATIONS



--HAVING


--Write a query that checks if any product id is repeated in more than one row in the products table.

SELECT	product_id, COUNT (*) AS CNT_PRODUCT
FROM	production.products
GROUP BY
		product_id
HAVING
		COUNT (*) > 1





SELECT	product_id, product_name, COUNT (product_id) AS CNT_PRODUCT
FROM	production.products
GROUP BY
		product_id, product_name
HAVING
		COUNT (product_id) > 1




---Write a query that returns category ids with a maximum list price above 4000 or a minimum list price below 500.


SELECT	category_id, MIN(list_price) AS min_price, MAX(list_price) AS max_price
FROM	production.products
GROUP BY
		category_id
HAVING
		MIN(list_price) < 500  OR MAX(list_price) > 4000 



---Find the average product prices of the brands.
--As a result of the query, the average prices should be displayed in descending order.


SELECT	A.brand_name, AVG(B.list_price) AS Avg_price
FROM	production.brands A , production.products B
WHERE	A.brand_id = B.brand_id
GROUP BY
		A.brand_name
ORDER BY
		2 DESC



--Write a query that returns BRANDS with an average product price of more than 1000.


SELECT	A.brand_name, AVG(B.list_price) AS Avg_price
FROM	production.brands A , production.products B
WHERE	A.brand_id = B.brand_id
GROUP BY
		A.brand_name
HAVING	AVG(B.list_price) > 1000
ORDER BY
		2 ASC



--Write a query that returns the net price paid by the customer for each order. (Don't neglect discounts and quantities)

SELECT	*, quantity * list_price * (1-discount) as net_value
FROM	sales.order_items


SELECT	order_id, SUM(quantity * list_price * (1-discount)) as net_value
FROM	sales.order_items
GROUP BY
		order_id


---------/////////////////////////////-----------
		
--SUMMARY TABLE

--Copy an existing table to a new table.
--Don't need to create a new table before this process.

SELECT * 
INTO	NEW_TABLE
FROM	SOURCE_TABLE
WHERE ...




SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
FROM	sales.order_items A, production.products B, production.brands C, production.categories D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year


--We will use the table we obtained as a result of the above query again and again in all future queries. 
--For this, we are copying this query result to a new table as below.


SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sales.sales_summary

FROM	sales.order_items A, production.products B, production.brands C, production.categories D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year


----


SELECT *
FROM	sales.sales_summary
ORDER BY 1,2,3


---GROUPING SETS

--1. Calculate the total sales price.


SELECT	SUM(total_sales_price)
FROM	sales.sales_summary


--2. Calculate the total sales price of the brands


SELECT	Brand, SUM(total_sales_price)
FROM	sales.sales_summary
GROUP BY
		Brand


--3. Calculate the total sales price of the categories


SELECT	Category, SUM(total_sales_price)
FROM	sales.sales_summary
GROUP BY
		Category



--4. Calculate the total sales price by brands and categories.

SELECT	BRAND, Category, SUM(total_sales_price)
FROM	sales.sales_summary
GROUP BY
		BRAND, Category



--Perform the above four variations in a single query using 'Grouping Sets'.

SELECT	brand, category, SUM(total_sales_price)
FROM	sales.sales_summary
GROUP BY
		GROUPING SETS (
						(Brand),
						(Category),
						(Brand,Category),
						()
						)
ORDER BY
		1,2
;



---------------- ROLLUP ----------------------

--Generate different grouping variations that can be produced with the brand and category columns using 'ROLLUP'.
-- Calculate sum total_sales_price


SELECT	brand, category, SUM(total_sales_price)
FROM	sales.sales_summary
GROUP BY
	ROLLUP (Brand, Category)
ORDER BY
		1,2
;


--------------- CUBE -------------------


--Generate different grouping variations that can be produced with the brand and category columns using 'CUBE'.
-- Calculate sum total_sales_price


SELECT	brand, category, SUM(total_sales_price)
FROM	sales.sales_summary
GROUP BY
	CUBE (Brand, Category)
ORDER BY
		1,2
;








