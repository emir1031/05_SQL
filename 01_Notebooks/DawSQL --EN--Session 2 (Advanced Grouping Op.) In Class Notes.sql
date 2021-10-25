/* JULY 15, 2021 -- Data Analysis with SQL

ADVANCED GROUP OPERATIONS */

---- Having Clause -----

--Write a query that checks if any product id 
--is repeated in more than one row in the products table.

SELECT * 
FROM production.products;

SELECT product_id, COUNT(product_id)
FROM production.products
GROUP BY product_id;

SELECT product_id, COUNT(product_id) as unique_product_id
FROM production.products
GROUP BY product_id
HAVING COUNT(product_id) > 1;

--Write a query that returns category ids with
--a maximum list price above 4000 or a minimum list price below 500.

SELECT category_id, MAX(list_price) as max_price, MIN(list_price) as min_price
FROM production.products
GROUP BY category_id
HAVING MAX(list_price) > 4000 OR MIN(list_price) < 500;

--Find the average product prices of the brands.
--As a result of the query, the average prices should be displayed in descending order.

SELECT B.brand_name, AVG(list_price) as avg_list_price
FROM production.products A, production.brands B
WHERE A.brand_id = B.brand_id
GROUP BY B.brand_name
ORDER BY avg_list_price DESC 


--Write a query that returns BRANDS with an average product price of more than 1000.

SELECT B.brand_name, AVG(list_price) AS avg_list_price
FROM production.products A
JOIN production.brands B
ON A.brand_id = B.brand_id
GROUP BY B.brand_name
HAVING AVG(list_price) > 1000
ORDER BY avg_list_price ASC;

--Write a query that returns the net price paid by the customer for each order. 
--(Don't neglect discounts)

SELECT *
FROM sales.order_items


SELECT order_id, SUM(quantity * list_price * (1-discount)) AS NET_VALUE 
FROM sales.order_items
GROUP BY order_id
ORDER BY order_id


----- GROUPING SETS -----


SELECT b.brand_name AS brand, c.category_name AS category, p.model_year,

     ROUND (SUM (quantity * i.list_price * (1 - discount)) , 0 ) total_sales_price

INTO sales.sales_summary1
FROM
sales.order_items i
INNER JOIN production.products p ON p.product_id = i.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year


SELECT brand,category,   model_year, total_sales_price
FROM sales.sales_summary1
ORDER BY 1,2,3



-- 1. Find the total sales price 
SELECT SUM (total_sales_price)
FROM sales.sales_summary1 

--2. Calculate the total sales price of the brands
SELECT brand, SUM(total_sales_price) as total_price
FROM sales.sales_summary1
GROUP BY brand

--3. Calculate the total sales price of the categories

SELECT category, SUM(total_sales_price) as total_price
FROM sales.sales_summary1
GROUP BY category


--4. Calculate the total price of sales by brand and category.

SELECT category, brand, SUM(total_sales_price) as total_price
FROM sales.sales_summary1
GROUP BY category, brand


SELECT brand, category, SUM(total_sales_price)
FROM sales.sales_summary1
GROUP BY
	GROUPING SETS( 

					(brand, category),
					(brand),
					(category),
					()
	)
ORDER BY brand, category

----- ROLL UP -----
--- calculate the total sales by brand, category, model_year with roll up
--- three columns makes 4 different grouping combinations

SELECT brand, category, model_year, SUM(total_sales_price)
FROM sales.sales_summary1
GROUP BY
	ROLLUP (brand,category,model_year)
ORDER BY model_year, category

---- CUBE-----
--- calculate the total sales by brand, category, model_year with cube 
--- three columns makes 8 different grouping combinations

SELECT brand, category, model_year, SUM(total_sales_price)
FROM sales.sales_summary1
GROUP BY 
		CUBE (brand, category, model_year)
ORDER BY 1,2








