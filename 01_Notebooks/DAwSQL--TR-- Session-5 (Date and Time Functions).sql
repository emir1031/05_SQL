

------------- 2021-7-31 DAwSQL Session 5 (Data Functions) -------------


-- List customers who bought both 'Electric Bikes' and 'Comfort Bicycles' and 'Children Bicycles' in the same order.


--SET OPERATORS


SELECT	A.customer_id, A.first_name, A.last_name
FROM	sales.customers A, sales.orders B
WHERE	A.customer_id = B.customer_id
AND		B.order_id IN (
					SELECT	B.order_id
					FROM	production.products A, sales.order_items B
					WHERE	A.product_id = B.product_id
					AND		A.category_id = (
												SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Electric Bikes'
											)
					INTERSECT
					SELECT	B.order_id
					FROM	production.products A, sales.order_items B
					WHERE	A.product_id = B.product_id
					AND		A.category_id = (
												SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Comfort Bicycles'
											)
					INTERSECT
					SELECT	B.order_id
					FROM	production.products A, sales.order_items B
					WHERE	A.product_id = B.product_id
					AND		A.category_id = (
												SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Children Bicycles'
											)
					)


--------------------////////////////////

--Date Functions




CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)


--https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/ 


SELECT *
FROM	t_date_time


INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES 
('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' )


-----



INSERT t_date_time (A_time) VALUES (TIMEFROMPARTS(12,00,00,0,0));

INSERT INTO t_date_time (A_date) VALUES (DATEFROMPARTS(2021,05,17));



select convert(varchar, getdate(), 6)


INSERT INTO t_date_time (A_datetime) VALUES (DATETIMEFROMPARTS(2021,05,17, 20,0,0,0));


INSERT INTO t_date_time (A_datetimeoffset) VALUES (DATETIMEOFFSETFROMPARTS(2021,05,17, 20,0,0,0, 2,0,0));


SELECT	A_date,
		DATENAME(DW, A_date) [DAY],
		DAY (A_date) [DAY2],
		MONTH(A_date),
		YEAR (A_date),
		A_time,
		DATEPART (NANOSECOND, A_time),
		DATEPART (MONTH, A_date)
FROM	t_date_time



-------------


SELECT	A_date,	
		A_datetime,
		DATEDIFF (DAY, A_date, A_datetime)
FROM	t_date_time



select	DATEDIFF (DAY, order_date, shipped_date), order_date, shipped_date, DATEDIFF (DAY, shipped_date, order_date)
from	sales.orders
where	order_id = 1


--------------

SELECT	DATEADD (YEAR, 5, order_date), 
		DATEADD (DAY, 5, order_date),
		DATEADD (DAY, -5, order_date),
		order_date
FROM	sales.orders
where	order_id = 1




SELECT	EOMONTH( order_date), order_date
FROM	sales.orders




SELECT	ISDATE( CAST (order_date AS nvarchar)), order_date
FROM	sales.orders


SELECT ISDATE ('1234568779')

SELECT ISDATE ('WHERE')

SELECT ISDATE ('2021-12-02')

SELECT ISDATE ('2021.12.02')


----------------------------

SELECT GETDATE()


SELECT CURRENT_TIMESTAMP


SELECT GETUTCDATE()


-------------------------



SELECT *
FROM	t_date_time


INSERT t_date_time 
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())


----------------------


/*
Question: Create a new column that contains labels of the shipping speed of products.

If the product has not been shipped yet, it will be marked as "Not Shipped",
If the product was shipped on the day of order, it will be labeled as "Fast".
If the product is shipped no later than two days after the order day, it will be labeled as "Normal"
If the product was shipped three or more days after the day of order, it will be labeled as "Slow".
*/


SELECT	*,
		CASE WHEN order_status <> 4 THEN 'Not Shipped'
			 WHEN order_date = shipped_date THEN 'Fast' -- DATEDIFF (DAY, ORDER_DATE, SHIPPED_DATE) = 0
			 WHEN DATEDIFF (DAY, ORDER_DATE, shipped_date) BETWEEN 1 AND 2 THEN 'Normal'
			 ELSE 'Slow'
		END AS ORDER_LABEL,
		DATEDIFF (DAY, ORDER_DATE, shipped_date) datedif
FROM	sales.orders
order by datedif




SELECT	*,
		CASE WHEN order_status <> 4 THEN 'Not Shipped'
			 WHEN DATEDIFF (DAY, ORDER_DATE, shipped_date) = 0 THEN 'Fast'
			 WHEN DATEDIFF (DAY, ORDER_DATE, shipped_date) BETWEEN 1 AND 2 THEN 'Normal'
			 ELSE 'Slow'
		END AS ORDER_LABEL,
		DATEDIFF (DAY, ORDER_DATE, shipped_date) datedif
FROM	sales.orders
order by datedif



-------------------


--Write a query returning orders that are shipped more than two days after the ordered date. 

SELECT *, DATEDIFF(DAY, order_date, shipped_date) DATE_DIFF
FROM	sales.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) >2


----Write a query that returns the number distributions of the orders in the previous query result, according to the days of the week.


SELECT	SUM(CASE WHEN DATENAME (DW, order_date) = 'Monday' THEN 1 ELSE 0 END) AS MONDAY,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Tuesday' THEN 1 ELSE 0 END) AS Tuesday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Wednesday' THEN 1 ELSE 0 END) AS Wednesday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Thursday' THEN 1 ELSE 0 END) AS Thursday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Friday' THEN 1 ELSE 0 END) AS Friday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Saturday' THEN 1 ELSE 0 END) AS Saturday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Sunday' THEN 1 ELSE 0 END) AS Sunday
FROM	sales.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2




--Write a query that returns the order numbers of the states by months.


SELECT	A.state , YEAR(B.order_date) YEARS, MONTH(B.order_date) months, COUNT (DISTINCT order_id) NUM_OF_ORDERS
FROM	SALES.customers A, sales.orders B
WHERE	A.customer_id = B.customer_id
GROUP BY	A.state, YEAR(B.order_date), MONTH(B.order_date) 
ORDER BY	state, YEARS, months













