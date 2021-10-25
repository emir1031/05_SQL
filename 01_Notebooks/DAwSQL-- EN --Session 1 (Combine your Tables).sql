/* 12 July  2021 -- Data Analysis with SQL */


------ Inner Join ------
-- List the products with their category names. 
-- Select product ID, product name, category name, and categoryID

SELECT A.product_id, A.product_name, B.category_name, B.category_id
FROM production.products A
INNER JOIN production.categories B
ON A.category_id = B.category_id;

--2. WAY
SELECT A.product_id, A.product_name, B.category_name, B.category_id
FROM production.products A, production.categories B
WHERE A.category_id = B.category_id;



-- List store employees with their store information
-- Select employee name, surname, store names

SELECT B.first_name, B.last_name, A.store_name
FROM sales.stores A
INNER JOIN sales.staffs B
ON A.store_id = B.store_id;


--- LEFT JOIN

-- List the products with their category names. 
-- Select product ID, product name, category name, and categoryID

SELECT A.product_id, A.product_name, B.category_name, B.category_id 
FROM production.products A
LEFT JOIN production.categories B
ON A.category_id = B.category_id;


​
--Report the stock status of the products that product id 
--greater than 310 in the stores.
--Expected columns: Product_id, Product_name, Store_id, quantity

SELECT A.product_id, A.product_name, B.store_id, B.quantity
FROM production.products A
LEFT JOIN production.stocks B
ON A.product_id = B.product_id
WHERE B.quantity < 50;

----- RIGHT JOIN
--Report the stock status of the products that product id 
--greater than 310 in the stores.
--Expected columns: Product_id, Product_name, Store_id, quantity

SELECT B.product_id, B.product_name, A.store_id, A.quantity
FROM production.stocks A
RIGHT JOIN production.products B
ON A.product_id = B.product_id
WHERE B.product_id > 310;

---Report the orders information made by all staffs.
--Expected columns: Staff_id, first_name, last_name, 
-- all the information about orders

SELECT *
FROM sales.staffs; --- 10

SELECT  COUNT (DISTINCT staff_id)
FROM sales.orders; --- 6 

SELECT B.staff_id, B.first_name, B.last_name, A.*
FROM sales.orders A
RIGHT JOIN sales.staffs B
ON A.staff_id = B.staff_id;


--- FULL OUTER JOIN
--Write a query that returns stock and order information together for all products .
​-- Expected columns: Product_id, store_id, quantity, order_id, list_price

SELECT A.product_id, B.store_id, B.quantity, A.order_id, A.list_price, B.product_id
FROM sales.order_items A
FULL OUTER JOIN production.stocks B
ON A.product_id = B.product_id
ORDER BY A.product_id;


--- CROSS JOIN
--- --Write a query that returns all brand x category possibilities.
​-- Expected columns: brand_id, brand_name, category_id, category_name

SELECT *
FROM production.brands

SELECT *
FROM production.categories

SELECT *
FROM production.brands A
CROSS JOIN production.categories B; 

--Write a query that returns the table to be used to add 
-- products that are in the Products table but not in the stocks 
--table to the stocks table with quantity = 0. 
--(Do not forget to add products to all stores.)
--Expected columns: store_id, product_id, quantity

SELECT *
FROM production.stocks;

SELECT * 
FROM production.products;

SELECT *
FROM production.products A
WHERE A.product_id NOT IN (SELECT product_id FROM production.stocks);

SELECT B.store_id, A.product_id, A.product_name, 0 quantity
FROM production.products A
CROSS JOIN sales.stores B
WHERE A.product_id NOT IN (SELECT product_id FROM production.stocks)
ORDER BY A.product_id, B.store_id


--- SELF JOIN 
-- Write a query that returns the staffs with their managers.
--Expected columns: staff first name, staff last name, manager name

SELECT * 
FROM sales.staffs A
JOIN sales.staffs B
ON A.manager_id = B.staff_id
;