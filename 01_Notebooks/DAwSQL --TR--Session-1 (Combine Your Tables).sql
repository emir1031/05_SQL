


---------------12-07-21 DAwSQL Session 1------------


--INNER JOIN

-- List products with category names
-- Select product ID, product name, category ID and category names


SELECT	*
FROM	production.products AS A
INNER JOIN	production.categories AS B
ON		A.category_id = B.category_id



--List employees of stores with their store information
--Select employee name, surname, store names


SELECT	TOP 20 B.first_name,B.last_name, A.store_name
FROM	sales.stores A , sales.staffs B
WHERE	A.store_id = B.store_id



----------/////////////////-----------

--LEFT JOIN

--List products with category names
--Select product ID, product name, category ID and category names (Use Left Join)



SELECT	*
FROM	production.products A
LEFT JOIN production.categories B
ON		A.category_id = B.category_id




--Report the stock status of the products that product id greater than 310 in the stores.
--Expected columns: Product_id, Product_name, Store_id, quantity


SELECT *
FROM	production.products A
LEFT JOIN production.stocks B
ON		A.product_id = B.product_id
WHERE	A.product_id > 310


--------------//////////////----------------

--RIGHT JOIN

--Report the stock status of the products that product id greater than 310 in the stores.
--Expected columns: Product_id, Product_name, Store_id, quantity


SELECT *
FROM	production.stocks A
RIGHT JOIN production.products B
ON		A.product_id = B.product_id
WHERE	B.product_id > 310


---Report the orders information made by all staffs.
--Expected columns: Staff_id, first_name, last_name, all the information about orders


SELECT *
FROM	sales.staffs -- 10


SELECT COUNT (DISTINCT staff_id) -- 6
FROM	sales.orders


SELECT *
FROM	sales.orders A
RIGHT JOIN SALES.staffs B
ON		A.staff_id = B.staff_id


--------------//////////////----------------

--FULL OUTER JOIN
--Write a query that returns stock and order information together for all products .

Expected columns: Product_id, store_id, quantity, order_id, list_price


SELECT	B.product_id, B.store_id, B.quantity, A.product_id, A.list_price, A.order_id
FROM	sales.order_items A
FULL OUTER JOIN production.stocks B
ON		A.product_id = B.product_id
ORDER BY A.product_id


--------------//////////////----------------


-- CROSS JOIN

--Write a query that returns all brand x category possibilities.

--Expected columns: brand_id, brand_name, category_id, category_name



SELECT	*
FROM	production.brands A
CROSS JOIN production.categories B
ORDER BY A.brand_id, B.category_id


--EXTRA
--Write a query that returns the table to be used to add products that are in the Products table but not in the stocks table to the stocks table with quantity = 0. 
--(Do not forget to add products to all stores.)
--Expected columns: store_id, product_id, quantity



--------------//////////////----------------

--SELF JOIN
-- Write a query that returns the staffs with their managers.
--Expected columns: staff first name, staff last name, manager name



SELECT	A.first_name, B.first_name manager_name
FROM	sales.staffs A, sales.staffs B
WHERE	A.manager_id = B.staff_id
ORDER BY B.first_name
;


--EXTRA
-- Write a query that returns the 1st and 2nd degree managers of all staffs
--Expected columns: staff name,  first manager name, second manager name






















