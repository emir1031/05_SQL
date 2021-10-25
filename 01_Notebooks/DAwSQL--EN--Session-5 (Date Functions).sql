--GET DATA TYPES FROM BIKESTORE DATABASE

SELECT DATA_TYPE,COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_CATALOG='BikeStores'
GROUP BY DATA_TYPE

--LET'S BUILD A TABLE THAT INCLUDES ALL THE DATE AND TIME FORMATS WE NEED
CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
)

--INSERT SOME DATA TO THE NEW TABLE
INSERT INTO dbo.t_date_time (
	A_time ,
	A_date ,
	A_smalldatetime,
	A_datetime,
	A_datetime2,
	A_datetimeoffset
	)
VALUES (
	'11:00:00',
	'2021-07-31',
	'2021-07-31',
	'2021-07-31',
	'2021-07-31',
	'2021-07-31'
)



--LET'S USE CONSTRUCT FUNCTIONS FOR INSERTING DATA

--INSERT TIME FORMATTED VALUE FOR 12:10:30 INTO COLUMN A_time
INSERT INTO dbo.t_date_time (A_time) 
VALUES (TIMEFROMPARTS(12,10,30,0,0))

--INSERT TIME FORMATTED VALUE FOR 20:30:15 INTO COLUMN A_time
INSERT INTO dbo.t_date_time (A_time) 
VALUES (TIMEFROMPARTS(20,30,15,0,0))

--INSERT DATE FORMATTED VALUE FOR TODAY INTO COLUMN A_date
INSERT INTO dbo.t_date_time (A_date) 
VALUES (DATEFROMPARTS(2021,07,31))

--INSERT DATETIME FORMATTED VALUE FOR TODAY AT 15:30:20 INTO COLUMN A_datetime
INSERT INTO dbo.t_date_time (A_datetime) 
VALUES (DATETIMEFROMPARTS(2021,07,31,15,30,20,0))

SELECT *
FROM dbo.t_date_time

--INSERT DATETIMEOFFSET FORMATTED VALUE FOR TODAY AT 15:30:20  OFFSET=2 HOURS INTO COLUMN A_datetimeoffset
INSERT INTO dbo.t_date_time (A_datetimeoffset) 
VALUES (DATETIMEOFFSETFROMPARTS(2021,07,31,15,30,20,0,2,0,0))

--DELETE FROM DBO.t_date_time where A_datetimeoffset ='2021-07-31 15:30:20.0000000 +02:00'

--RETURN FUNCTIONS
SELECT A_date,
		DATENAME(DW,A_date) as date_name,
		DAY(A_date) as [day],
		DATEPART(MONTH,A_date) as [datepart],
		DATENAME(MONTH,A_date) as [datename]
FROM dbo.t_date_time

SELECT *,DATENAME(DW,order_date) as order_date
		,DATENAME(DW,required_date) as required_date
		,DATENAME(DW,shipped_date) as shipped_date
FROM sales.orders

SELECT *,DATENAME(DW,order_date) as order_date
		,DATEPART(MONTH,required_date) as [month]
		,DAY(shipped_date) as [day]
FROM sales.orders


--ISDATE, GETDATE(), CURRENT_TIMESTAMP,	GETUTCDATE();
SELECT ISDATE('2021-01-32')
SELECT GETDATE()
SELECT CURRENT_TIMESTAMP
SELECT GETUTCDATE()

INSERT INTO t_date_time VALUES (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE());

SELECT *
FROM t_date_time  ​


-- DATEADD ve EOMONTH FUNCTIONS
SELECT EOMONTH('2021-02-15')
SELECT EOMONTH('2020-02-15')
SELECT DAY(EOMONTH('2020-02-15'))
SELECT DAY(EOMONTH('2021-02-15'))

SELECT DATEADD(M,3,'2021-01-01')
SELECT DATEADD(WEEK,3,'2021-01-01')
SELECT DATEADD(D,-5,'2021-01-01')
SELECT DATEADD(M,-3,'2021-01-01')

--DATEDIFF, DATEADD,EOMONTH FUNCTIONS

SELECT *,
		DATENAME(DW,order_date) as [order_day],
		DATEDIFF(D, order_date, shipped_date) AS [day_diff]

FROM sales.orders

-- QUESTION: Create a new column that contains labels of the shipping speed of products.
-- 1. If the product has not been shipped yet, it will be marked as "Not Shipped"
-- 2. If the product was shipped in 1 day, it will be labeled as "Fast"
-- 3. If the product is shipped in 2 days after the order day, it will be labeled as "Normal"
-- 4. If the product was shipped 3 or more days after the day of order, it will be labeled as "Slow"
--(ORDER STATUS <> 4 THAT MEANS THIS ORDER IS NOT SHIPPED)

SELECT *,
		DATENAME(DW,order_date) as [order_day],
		DATEDIFF(D, order_date, shipped_date) AS [day_diff],

		CASE	WHEN order_status <> 4 THEN  'Not Shipped'
				WHEN DATEDIFF(D, order_date, shipped_date)=1 THEN 'Fast'
				WHEN DATEDIFF(D, order_date, shipped_date)=2 THEN 'Normal'
				ELSE 'Slow'
		END as Shipping_Speed				
FROM sales.orders

--Question-2: Write a query returning orders that are shipped more than two days after the ordered date. 

SELECT *, 
		DATEDIFF (DAY, order_date, shipped_date) AS difference_date
FROM sales.orders
WHERE DATEDIFF (DAY, order_date, shipped_date) > 2


--Question-3: Write a query that returns the number distributions of the orders in the previous query result, 
--according to the days of the week.
SELECT	SUM(CASE WHEN DATENAME(DW,order_date)='Monday' THEN 1 ELSE 0 END) as Monday,
		SUM(CASE WHEN DATENAME(DW,order_date)='Tuesday' THEN 1 ELSE 0 END) as Tuesday,
		SUM(CASE WHEN DATENAME(DW,order_date)='Wednesday' THEN 1 ELSE 0 END) as Wednesday,
		SUM(CASE WHEN DATENAME(DW,order_date)='Thursday' THEN 1 ELSE 0 END) as Thursday,
		SUM(CASE WHEN DATENAME(DW,order_date)='Friday' THEN 1 ELSE 0 END) as Friday,
		SUM(CASE WHEN DATENAME(DW,order_date)='Saturday' THEN 1 ELSE 0 END) as Saturday,
		SUM(CASE WHEN DATENAME(DW,order_date)='Sunday' THEN 1 ELSE 0 END) as Sunday
FROM sales.orders

--Question-4:Write a query that returns the order numbers of the states by months.

SELECT	c.state
		,YEAR(o.order_date) as [Year]
		,MONTH(o.order_date) as [MONTH]
		,COUNT(DISTINCT o.order_id) AS NUM_OF_ORDERS
FROM SALES.orders O, sales.customers C
WHERE  O.customer_id=C.customer_id
group by C.state, YEAR(o.order_date),MONTH(o.order_date)
ORDER BY C.state,[Year]


