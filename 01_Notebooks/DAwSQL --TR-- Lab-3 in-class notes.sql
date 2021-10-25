


-----------------DAwSQL Lab 3 2021-08-10------------


-- 1. Find the weekly order count for the city of Baldwin for the last 8 weeks earlier from '2016-08-18', and also the cumulative total.
-- Desired output: [week, order_count, cuml_order_count]



SELECT	Customer_id, Order_Date, B.product_id, A.order_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate,
		RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date),
		ROW_NUMBER() OVER (PARTITION BY Customer_id ORDER BY Order_Date)
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id





--2. Write a query that returns customers who ordered the same product on two consecutive orders.
--expected output: customer_id, product_id, previous order date, next order date





WITH T1 AS
(
SELECT	Customer_id, Order_Date, B.product_id, A.order_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id
), T2 AS
(
SELECT	Customer_id, Order_Date, B.product_id, A.order_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id
)
SELECT	T2.customer_id,
		T2.product_id,
		T1.order_date,
		T1.order_id,
		T1.historical_numerate PREV_ORD,
		T2.order_date,
		T2.historical_numerate NEXT_ORD
FROM	T1, T2
WHERE	T1.customer_id = T2.customer_id
AND		T1.product_id = T2.product_id
AND		T1.historical_numerate + 1 = T2.historical_numerate



--CONTROL

SELECT	Customer_id, Order_Date, B.product_id, A.order_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id
AND		customer_id = 24



--


SELECT	Customer_id, B.product_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) +1 historical_numerate
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id

INTERSECT

SELECT	Customer_id, B.product_id,
		DENSE_RANK() OVER (PARTITION BY Customer_id ORDER BY Order_Date) historical_numerate
FROM	sales.orders A, 
		sales.order_items B
WHERE	A.order_id=B.order_id
