

-----2021-08-03 DAwSQL Lab 2------------



--Select customers who have purchase both Children Bicycle and Comfort Bicycle on a single order. 
--(expected columns: Customer id, first name, last name, order id)

--1

SELECT	E.Customer_id, first_name, last_name, D.order_id,
		SUM(CASE WHEN A.category_name = 'Children Bicycles' THEN 1 ELSE 0 END) AS IS_CHILD,
		SUM(CASE WHEN A.category_name = 'Comfort Bicycles' THEN 1 ELSE 0 END) AS IS_COMFORT
FROM	production.categories A,
		production.products B,
		sales.order_items C,
		sales.orders D,
		sales.customers E
WHERE	A.category_id = B.category_id AND
		B.product_id = C.product_id AND
		C.order_id = D.order_id AND
		D.customer_id = E.customer_id
AND		A.category_name IN ('Children Bicycles', 'Comfort Bicycles')
GROUP BY
		E.Customer_id, first_name, last_name, D.order_id
HAVING
		SUM(CASE WHEN A.category_name = 'Children Bicycles' THEN 1 ELSE 0 END) >= 1 AND
		SUM(CASE WHEN A.category_name = 'Comfort Bicycles' THEN 1 ELSE 0 END) >= 1
ORDER BY D.order_id


--control

SELECT	A.category_name, E.first_name,E.last_name, D.order_id
FROM	production.categories A,
		production.products B,
		sales.order_items C,
		sales.orders D,
		sales.customers E
WHERE	A.category_id = B.category_id AND
		B.product_id = C.product_id AND
		C.order_id = D.order_id AND
		D.customer_id = E.customer_id
AND		A.category_name IN ('Children Bicycles', 'Comfort Bicycles')
and		E.customer_id = 1185


--2

SELECT	E.customer_id, E.first_name,E.last_name, D.order_id
FROM	production.categories A,
		production.products B,
		sales.order_items C,
		sales.orders D,
		sales.customers E
WHERE	A.category_id = B.category_id AND
		B.product_id = C.product_id AND
		C.order_id = D.order_id AND
		D.customer_id = E.customer_id
AND		A.category_name = 'Children Bicycles'

INTERSECT

SELECT	E.customer_id, E.first_name,E.last_name, D.order_id
FROM	production.categories A,
		production.products B,
		sales.order_items C,
		sales.orders D,
		sales.customers E
WHERE	A.category_id = B.category_id AND
		B.product_id = C.product_id AND
		C.order_id = D.order_id AND
		D.customer_id = E.customer_id
AND		A.category_name = 'Comfort Bicycles'


---3

WITH CTE AS(SELECT E.customer_id, E.first_name, E.last_name, D.order_id, A.category_name,	   CASE WHEN A.category_name = 'Children Bicycles' THEN 1 ELSE 0 END AS is_children,	   CASE WHEN A.category_name = 'Comfort Bicycles' THEN 1 ELSE 0 END AS is_comfort,	   	   CASE WHEN A.category_name IN ('Children Bicycles', 'Comfort Bicycles') THEN 1 ELSE 0 END AS is_bothFROM production.categories AS A,	 production.products AS B,	 sales.order_items AS C,	 sales.orders AS D,	 sales.customers AS EWHERE A.category_id = B.category_id AND	  B.product_id = C.product_id AND	  C.order_id = D.order_id AND	  D.customer_id = E.customer_idAND   A.category_name IN ('Children Bicycles', 'Comfort Bicycles'))SELECT CTE.customer_id, CTE.first_name, CTE.last_name, CTE.order_idFROM CTEWHERE is_both = 1






select street, right(left(street, CHARINDEX(' ',street)-1), 1), 
		isnumeric(right(left(street, CHARINDEX(' ',street)-1), 1)),
			(
			case when isnumeric(right(left(street, CHARINDEX(' ',street)-1), 1)) = 0
			then replace(street,right(left(street, CHARINDEX(' ',street)-1), 1), '')
			else street end) as modified_street
from sales.customers



SELECT	street, 
		LEFT(street,CHARINDEX(' ',street)-1),
		RIGHT(street,LEN(street)-CHARINDEX(' ',street)+1),
		LEFT(street,CHARINDEX(' ',street)-2)+ ' '+ RIGHT(street,LEN(street)-CHARINDEX(' ',street)+1) as new_street
FROM	sales.customers
WHERE	ISNUMERIC(LEFT(street,CHARINDEX(' ',street)-1))=0






select
	street,
	replace(street,
	substring(left(street,
	charindex(' ', street)-1), 1,
	charindex(' ', street)-1),
	substring(left(street,
	charindex(' ', street)-1), 1,
	charindex(' ', street)-2))
from sales.customers
where ISNUMERIC(LEFT(street,CHARINDEX(' ',street)-1))=0






