----------- 2021-08-05 DAwSQL Session 7 Window Functions------------
--- find the stock numbers --quantity of the products
SELECT *
FROM production.stocks
SELECT product_id, SUM(quantity)
FROM production.stocks
GROUP BY product_id
ORDER BY 1
SELECT  *, SUM(quantity) OVER(PARTITION BY product_id)
FROM production.stocks
SELECT DISTINCT product_id, SUM(quantity) OVER(PARTITION BY product_id)
FROM production.stocks
----
-- Calculate the average bike prices by brand with both Group By and Window Functions.
SELECT *
FROM production.products
SELECT brand_id, AVG(list_price) avg_price
FROM production.products
GROUP BY brand_id
SELECT  DISTINCT brand_id, AVG(list_price) OVER (PARTITION BY brand_id)
FROM production.products
-------
-- 1. ANALYTIC AGGREGATE FUNCTIONS --


--MIN() - MAX() - AVG() - SUM() - COUNT()

--- 1. The price of the cheapest bike

SELECT DISTINCT MIN(list_price) OVER()
FROM production.products


--- 2. The price of the cheapest bike in each category

SELECT DISTINCT category_id,MIN(list_price) OVER(PARTITION BY category_id)
FROM production.products


------3. How many different bikes are there?

SELECT DISTINCT COUNT(product_id) OVER() NUM_OF_BIKE
FROM production.products


-- How many different bikes at the order_items table?

SELECT DISTINCT COUNT(DISTINCT product_id) OVER() NUM_OF_BIKE
FROM sales.order_items



SELECT COUNT(DISTINCT product_id)
FROM sales.order_items


SELECT DISTINCT COUNT(product_id) OVER() NUM_OF_BIKE
FROM
	(
			SELECT DISTINCT product_id
			FROM sales.order_items
	) A



-- 4. How many different bikes are in each category?

SELECT  DISTINCT category_id,COUNT(product_id) OVER(PARTITION BY category_id)
FROM production.products

-- 5. How many different bikes are in each brand in each category?

SELECT DISTINCT brand_id, category_id, COUNT(product_id) OVER(PARTITION BY category_id, brand_id)
FROM production.products


--- Can we calculate how many different brands are in each category with only one select statement and wf?

SELECT brand_id, COUNT(DISTINCT brand_id)
FROM production.products
GROUP BY brand_id


SELECT category_id, COUNT(DISTINCT brand_id) OVER (PARTITION BY category_id)
FROM production.products


SELECT DISTINCT category_id, COUNT(brand_id) OVER(PARTITION BY category_id) num_of_brand
FROM
(
SELECT DISTINCT brand_id, category_id
FROM production.products

) A



---- 2. ANALYTIC NAVIGATION FUNCTIONS --


--first_value() - last_value() - lead() - lag()


--- In the Orders table, print the following values ​​next to each order, respectively:
--- 1. Print the order date of the previous sale of each staff (LAG FUNCTION)

SELECT *,
      LAG(order_date, 1) OVER (PARTITION BY staff_id ORDER BY order_date, order_id) prev_ord_date
FROM sales.orders


--- 2. Print the order date of the next sale of each staff member (lead function)

SELECT *,
      LEAD(order_date, 1) OVER (PARTITION BY staff_id ORDER BY order_date, order_id) NEXT_ord_date
FROM sales.orders

SELECT *,
      LEAD(order_date, 2) OVER (PARTITION BY staff_id ORDER BY order_date, order_id) NEXT_ord_date
FROM sales.orders


--- WINDOW FRAME

SELECT COUNT(*) OVER () TOTAL_ROW
FROM production.products


SELECT DISTINCT category_id,
		COUNT(*) OVER () TOTAL_ROW ,
		COUNT(*) OVER (PARTITION BY category_id) NUM_OF_ROW,
		COUNT(*) OVER (PARTITION BY category_id ORDER BY product_id) num_of_row_new
FROM production.products


--- 

SELECT  category_id,
COUNT(*) OVER (PARTiTION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) CURRENT_WITH_FOLLOWING
FROM production.products


SELECT  category_id,
COUNT(*) OVER (PARTiTION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) CURRENT_WITH_FOLLOWING
FROM production.products


SELECT  category_id,
COUNT(*) OVER (PARTiTION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) CURRENT_WITH_FOLLOWING
FROM production.products


-----
SELECT category_id, COUNT(*) OVER (PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) CURRENT_WITH_FOLLOWING
FROM production.products
ORDER BY category_id, product_id
---

SELECT category_id, COUNT(*) OVER (PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) CURRENT_WITH_FOLLOWING
FROM production.products
ORDER BY category_id, product_id

---- FIRST VALUE
-- 1. Name of the cheapest bike among all bikes

SELECT FIRST_VALUE(product_name) OVER(ORDER BY list_price)
FROM production.products

SELECT distinct FIRST_VALUE(product_name) OVER(ORDER BY list_price), min(list_price) over()
FROM production.products


SELECT list_price, product_name
FROM production.products
WHERE product_name = (	SELECT	DISTINCT
				                FIRST_VALUE(product_name) OVER(ORDER BY list_price ASC) cheapest_product
						FROM	production.products
						)


--- 2. Name of the cheapest bike in each category

SELECT DISTINCT category_id, FIRST_VALUE(product_name) OVER (PARTITION BY category_id order by list_price)
FROM production.products


-- 1. Name of the cheapest bike among all bikes (LAST VALUE)

SELECT DISTINCT
 FIRST_VALUE (product_name) OVER  (ORDER BY list_price),
  LAST_VALUE (product_name) OVER  (ORDER BY list_price DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
 FROM production.products


 -- 3. ANALYTIC NUMBERING FUNCTIONS --


--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()


--1. Rank the price of the bikes within each category (starting from 1 and increasing 
--one by one according to the increasing price)

SELECT category_id, list_price, ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) row_numb
FROM production.products

--2. Do the same question so that bikes with the same price get the same sequence number (use the RANK function)

SELECT category_id, list_price, 
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) row_numb,
	RANK() OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM
FROM production.products


--3. Do the same question so that bikes with the same price get the same sequence number 
---(use the DENSE_RANK function)

SELECT category_id, list_price, 
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) row_numb,
	RANK() OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
	DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM
FROM production.products


-- 4. Print the percentiles according to the prices of the bicycles in each category.

SELECT category_id, list_price, 
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) row_numb,
	RANK() OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
	DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
	ROUND(CUME_DIST() OVER(PARTITION BY category_id ORDER BY list_price),2) CUM_DIST,
	ROUND(PERCENT_RANK () OVER(PARTITION BY category_id ORDER BY list_price),2) PERCENT_RANK
FROM production.products



--6. Divide the bikes in each category into 4 groups according to the increasing price. 
-- If possible, there will be the same number of bikes in each group. (Use NTILE function)

SELECT category_id, list_price, 
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) row_numb,
	RANK() OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
	DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
	ROUND(CUME_DIST() OVER(PARTITION BY category_id ORDER BY list_price),2) CUM_DIST,
	ROUND(PERCENT_RANK () OVER(PARTITION BY category_id ORDER BY list_price),2) PERCENT_RANK,
	NTILE(4) OVER (PARTITION BY category_id ORDER BY list_price) NTILE_RESULT
FROM production.products

