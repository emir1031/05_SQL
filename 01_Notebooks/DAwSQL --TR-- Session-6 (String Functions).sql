

-------- DAwSQL Session 6 String Functions 02.08.2021 ----------


--LEN

SELECT LEN (123344)

SELECT LEN ( 123344)

SELECT LEN ('WELCOME')

SELECT LEN (' WELCOME')

SELECT LEN ('"WELCOME"')

SELECT '"WELCOME"'


--CHARINDEX

SELECT CHARINDEX ('C', 'CHARACTER')

SELECT CHARINDEX ('C', 'CHARACTER', 2)


SELECT CHARINDEX ('CT', 'CHARACTER')


SELECT CHARINDEX ('ct', 'CHARACTER')



--PATINDEX

SELECT PATINDEX ('R', 'CHARACTER')


SELECT PATINDEX ('%R%', 'CHARACTER')


SELECT PATINDEX ('%R', 'CHARACTER')


SELECT PATINDEX ('%r', 'CHARACTER')


SELECT PATINDEX ('%A____', 'CHARACTER')



--LEFT

SELECT LEFT ('CHARACTER', 3)

SELECT LEFT (' CHARACTER', 3)


--RIGHT


SELECT RIGHT ('CHARACTER', 3)


SELECT RIGHT ('CHARACTER ', 3)


--SUBSTRING


SELECT SUBSTRING ('CHARACTER', 3, 5)


SELECT SUBSTRING ('12345689', 3, 5)

SELECT SUBSTRING ('CHARACTER', -1, 5)

SELECT SUBSTRING ('CHARACTER', 0, 5)



--LOWER

SELECT LOWER ('CHARACTER')

--UPPER

SELECT UPPER ('character')

--STRING_SPLIT

SELECT	VALUE
FROM	string_split('John,Sarah,Jack' , ',')

SELECT	VALUE
FROM	string_split('John/Sarah/Jack' , '/')


SELECT	VALUE
FROM	string_split('John//Sarah//Jack' , '/')

SELECT	*
FROM	string_split('John//Sarah//Jack' , '/')



-- character >>>>>> Character

SELECT UPPER (LEFT('character', 1))


select LEN('character')-1


SELECT RIGHT ('character', LEN('character')-1)


SELECT UPPER (LEFT('character', 1)) + RIGHT ('character', LEN('character')-1)


--TRIM

SELECT TRIM(' CHARACTER ')

SELECT TRIM (' CHARACT ER')

SELECT TRIM('./' FROM '/character..') result

---

--LTRIM

SELECT LTRIM(' CHARACTER ')

--RTRIM

SELECT RTRIM(' CHARACTER ')



--REPLACE

SELECT REPLACE ('CHARACTER', 'RAC' , '')


SELECT REPLACE ('CHARACTER', 'RAC' , '/')


--STR

SELECT STR (1234.573, 6, 2)

SELECT STR (1234.573, 7, 1)


--JACK_10

SELECT 'JACK' + '_' + '10'


SELECT 'JACK' + '_' + STR (10, 2)


-------------

--CAST

SELECT CAST (123456 AS CHAR(6))

SELECT CAST (123456 AS VARCHAR(10))    

SELECT CAST (123456 AS VARCHAR(10)) + ' CHRIS'   



SELECT CAST (GETDATE() AS DATE)


--CONVERT

SELECT CONVERT (INT, 30.30)


SELECT CONVERT (FLOAT, 30.30)


--COALECE()

SELECT COALESCE(NULL, NULL, 'JACK', 'HANS', NULL)

--NULLIF

SELECT NULLIF ('JACK', 'JACK')


SELECT NULLIF ('JACK', 'HANS')


SELECT first_name
FROM	sales.customers


SELECT NULLIF (first_name, 'Debra')
from	sales.customers


SELECT	COUNT (NULLIF (first_name, 'Debra'))
from	sales.customers


SELECT	COUNT (*)
from	sales.customers


--ROUND


SELECT ROUND (432.368, 2, 0)

SELECT ROUND (432.368, 2)

SELECT ROUND (432.368, 1, 0)


SELECT ROUND (432.368, 1, 1)

SELECT ROUND (432.300, 1, 1)


SELECT ROUND (432.368, 3, 0)


------------How many yahoo mails in customer’s email column?


SELECT	SUM (CASE WHEN PATINDEX('%yahoo%', email) > 0 THEN 1 ELSE 0 END) num_of_domain
FROM	SALES.customers


select count(*)
from sales.customers
where email like '%yahoo%'


--Write a query that returns the characters before the '.' character in the email column.


SELECT	SUBSTRING (email, 1, CHARINDEX('.', email)-1), 
		email
FROM	sales.customers


---Add a new column to the customers table that contains the customers' contact information. 
--If the phone is available, the phone information will be printed, if not, the email information will be printed.


SELECT *, COALESCE (phone, email) contact
FROM	sales.customers



--Write a query that returns streets. The third character of the streets is numerical.


SELECT SUBSTRING( street, 3, 1), street
FROM sales.customers
WHERE	SUBSTRING( street, 3, 1) LIKE '[0-9]'



SELECT SUBSTRING( street, 3, 1), street
FROM sales.customers
WHERE	SUBSTRING( street, 3, 1) NOT LIKE '[^0-9]'



SELECT SUBSTRING( street, 3, 1), street
FROM sales.customers
WHERE	ISNUMERIC (SUBSTRING( street, 3, 1) ) = 1



--In the street column, clear the string characters that were accidentally added to the end of the initial numeric expression.









