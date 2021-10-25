/*1. Join all the tables and create a new table with all of the columns, called combined_table. 
(market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen) 
*/

SELECT *
INTO combined_table
FROM (

	SELECT cd.Cust_id, cd.Customer_Name, cd.Province, cd.Region, cd.Customer_Segment, 
			mf.Ord_id, mf.Prod_id, mf.Sales, mf.Discount, mf.Order_Quantity, mf.Product_Base_Margin,
			od.Order_Date, od.Order_Priority,
			pd.Product_Category, pd.Product_Sub_Category,
			sd.Ship_id, sd.Ship_Mode, sd.Ship_Date
	FROM market_fact mf
	INNER JOIN cust_dimen cd on cd.Cust_id=mf.Cust_id
	INNER JOIN orders_dimen od on od.Ord_id=mf.Ord_id
	INNER JOIN prod_dimen pd on pd.Prod_id=mf.Prod_id
	INNER JOIN shipping_dimen sd on sd.Ship_id=mf.Ship_id
	) A


	
	
SELECT * 
FROM combined_table
ORDER BY Ord_id

--2. Find the top 3 customers who have the maximum count of orders.

SELECT  TOP 3 Cust_id, Customer_Name, COUNT(DISTINCT Ord_id) AS COUNT_ORDER
FROM combined_table
GROUP BY Cust_id, Customer_Name
ORDER BY 3 DESC

--3. Create a new column at combined_table as DaysTakenForDelivery 
--that contains the date difference of Order_Date and Ship_Date.

ALTER TABLE combined_table
ADD DaysTakenForDelivery INT

UPDATE combined_table
SET DaysTakenForDelivery=DATEDIFF(DAY,Order_Date,Ship_Date)

--4. Find the customer whose order took the maximum time to get delivered.

SELECT MAX(DaysTakenForDelivery)
FROM combined_table

SELECT TOP 1 Customer_name ,Ord_id, DaysTakenForDelivery
FROM combined_table
ORDER BY DaysTakenForDelivery DESC

--5. Count the total number of unique customers in January and how many of them 
--came back every month over the entire year in 2011

SELECT COUNT( DISTINCT Cust_id) AS Unique_Customer
FROM combined_table
WHERE YEAR(Order_Date)= 2011
and MONTH (Order_Date)=01

SELECT MONTH(Order_date)  [Month],
		COUNT(DISTINCT Cust_id)  COUNT_CUST
FROM combined_table A
WHERE
EXISTS (
		SELECT Cust_id
		FROM combined_table B
		Where a.Cust_id=B.Cust_id
			AND YEAR(Order_Date)= 2011
			and MONTH (Order_Date)=01
		)
and YEAR(Order_Date)= 2011
group by MONTH(oRDER_DATE)

--6. write a query to return for each user the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID

SELECT Cust_id, MIN(oRDER_DATE) first_purchase
FROM combined_table
GROUP BY cust_id



SELECT DISTINCT Cust_id,
		Order_date as ThirdPurchase,
		DENSE_DATE,
		first_purchase,
		DATEDIFF(DAY,first_purchase,ORDER_DATE) AS day_ELAPSED
FROM(
	SELECT	Cust_id,
		Order_Date,
		ord_id,
		MIN (Order_date) OVER (Partition BY Cust_id) first_purchase,
		DENSE_RANK() OVER (Partition BY Cust_id ORDER by Order_Date) DENSE_DATE 
	FROM combined_table
) A
WHERE dense_date =3


SELECT *
FROM combined_table
WHERE	Cust_id = 'Cust_1000'
ORDER BY order_date 


--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by the customer.


WITH T1 AS (
SELECT	cust_id,
		SUM(CASE WHEN Prod_id='Prod_11' THEN order_quantity else 0 end ) as P11,
		SUM(CASE WHEN Prod_id='Prod_14' THEN order_quantity else 0 end ) as P14,
		SUM(order_quantity) TOTAL_Prod
FROM combined_table
GROUP BY cust_id
HAVING SUM(CASE WHEN Prod_id='Prod_11' THEN order_quantity else 0 end ) >=1  AND
		SUM(CASE WHEN Prod_id='Prod_14' THEN order_quantity else 0 end ) >=1
)

SELECT
		cust_id,
		P11,
		P14,
		TOTAL_Prod,
		cast (1.0*p11/TOTAL_Prod as numeric(3,2)) AS RATIOP11,
		cast (1.0*p14/TOTAL_Prod as numeric(3,2)) AS RATIOP14
FROM T1



--1.	Create a view that keeps visit logs of customers on a monthly basis. 
--(For each log, three field is kept: Cust_id, Year, Month)

CREATE VIEW CUSTOMER_LOGS AS
SELECT	Cust_id,
		YEAR(Order_date) [Year],
		MONTH(Order_date) [MOnth]
FROM combined_table
--ORDER BY 1,2,3

--2.Create a view that keeps the number of monthly visits by users. 
--(Separately for all months from the business beginning)

CREATE VIEW Number_of_visit AS
SELECT	Cust_id,
		[Year],
		[MOnth],
		count(*) total_visit
FROM CUSTOMER_LOGS 
group by Cust_id,
		[Year],
		[MOnth]

--3. CREATE A VIEW : For each visit of customers, create the next month of the visit as a separate column.
CREATE VIEW Next_visit AS
SELECT *,
		LEAD (Current_Month) OVER (PARTITION BY cust_id ORDER BY Current_Month) NEXT_VISIT_MONTH
FROM
	(SELECT	*,
			DENSE_RANK() over (ORDER BY [YEAR],[MONTH]) AS Current_Month
	FROM Number_of_visit
	--ORDER BY 1,2,3
	) A


--4.CREATE VIEW : Calculate the monthly time gap between two consecutive visits by each customer.
CREATE VIEW time_gaps AS 
SELECT *,
		NEXT_VISIT_MONTH-Current_Month AS TIME_GAP
FROM Next_visit

--5.Categorise customers using average time gaps. Choose the most fitted labeling model for you.
--For example: 
--o	Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
--o	Labeled as regular if the customer has made a purchase every month.
--Etc.

SELECT
		Cust_id,
		AVG_TIME_GAP,
		CASE	
				WHEN AVG_TIME_GAP=1 then 'RETAINED'
				WHEN AVG_TIME_GAP>1 then 'IRREGULAR'
				WHEN AVG_TIME_GAP IS NULL then 'CHURNED'
				ELSE 'UNKNOWN'
		END
FROM (

	SELECT Cust_id,
			AVG(time_gaps) AVG_TIME_GAP
	FROM time_gaps
	GROUP BY Cust_id
	) A
ORDER BY 2 DESC

--Find month-by-month customer retention rate  since the start of the business.
--Find the number of customers retained month-wise. (You can use time gaps)

select DISTINCT [YEAR],
		[MONTH],
		NEXT_VISIT_MONTH as retention_month,
		count (cust_id) over (PARTITION BY NEXT_VISIT_MONTH) RETENTION_SUM_MONTHLY
from time_gaps
where time_gaps=1


--2. Calculate the month-wise retention rate.

--Basic formula: 	
--Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Next Nonth 
--							/ Total Number of Customers in The Previous Month

--DROP VIEW CURRENT_NUM_OF_CUST
CREATE VIEW CURRENT_NUM_OF_CUST AS
SELECT DISTINCT
		Cust_id,
		[YEAR],
		[MONTH],
		CURRENT_MONTH,
		COUNT( Cust_id) OVER (PARTITION BY CURRENT_MONTH ) AS CURR_CUST
FROM time_gaps

--DROP VIEW NEXT_NUM_OF_CUST
CREATE VIEW NEXT_NUM_OF_CUST AS
SELECT DISTINCT
		Cust_id,
		[YEAR],
		[MONTH],
		NEXT_VISIT_MONTH,
		COUNT( Cust_id) OVER (PARTITION BY CURRENT_MONTH ) AS NEXT_CUST
FROM time_gaps
WHERE time_gaps=1
AND Current_Month>1

SELECT	DISTINCT 
		B.[YEAR],  
		B.[MONTH],
		B.Current_Month AS RETENTION_MONTH,
		1.0*B.RETENTITON_MONTH_WISE/A.RETENTITON_MONTH_WISE AS RETENTION_RATE
FROM	CURRENT_NUM_OF_CUST A
		LEFT JOIN
		NEXT_NUM_OF_CUST B
ON	A.Current_Month + 1  = B.NEXT_VISIT_MONTH
