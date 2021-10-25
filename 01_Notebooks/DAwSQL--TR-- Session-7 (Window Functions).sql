


----------- 2021-08-05 DAwSQL Session 7 Window Functions------------



--ürünlerin stock sayýlarýný bulunuz


SELECT	product_id, SUM(quantity)
FROM	production.stocks
GROUP BY product_id


SELECT	product_id
FROM	production.stocks
GROUP BY product_id
ORDER BY 1



SELECT	*, SUM(quantity) OVER (PARTITION BY product_id) 
FROM	production.stocks


SELECT	DISTINCT product_id, SUM(quantity) OVER (PARTITION BY product_id) 
FROM	production.stocks



-- Markalara göre ortalama bisiklet fiyatlarýný hem Group By hem de Window Functions ile hesaplayýnýz.


SELECT	brand_id, AVG(list_price) avg_price
FROM	production.products
GROUP BY brand_id



SELECT	DISTINCT brand_id, AVG(list_price) OVER (PARTITION BY brand_id) avg_price
FROM	production.products



-- 1. ANALYTIC AGGREGATE FUNCTIONS --


--MIN() - MAX() - AVG() - SUM() - COUNT()


--1. Tüm bisikletler arasýnda en ucuz bisikletin fiyatý


SELECT	DISTINCT MIN (list_price) OVER ()
FROM	production.products


--2. Herbir kategorideki en ucuz bisikletin fiyatý


SELECT	DISTINCT category_id, MIN (list_price) OVER (PARTITION BY category_id)
FROM	production.products



--3. Products tablosunda toplam kaç faklý bisikletin bulunduðu


SELECT	DISTINCT COUNT (product_id) OVER () NUM_OF_BIKE
FROM	production.products


--Order_items tablosunda toplam kaç farklý bisiklet olduðu


SELECT DISTINCT COUNT(product_id) OVER() order_num_of_bike
FROM sales.order_items



SELECT DISTINCT COUNT(product_id) OVER() order_num_of_bike
FROM (
		SELECT DISTINCT product_id
		FROM sales.order_items
	) A



SELECT COUNT (DISTINCT product_id)
FROM sales.order_items



--4. Herbir kategoride toplam kaç farklý bisikletin bulunduðu


SELECT	DISTINCT category_id, COUNT (product_id) OVER (PARTITION BY category_id)
FROM	production.products 


--5. Herbir kategorideki herbir markada kaç farklý bisikletin bulunduðu



SELECT	DISTINCT category_id, brand_id, COUNT (product_id) OVER (PARTITION BY category_id, brand_id)
FROM	production.products 




--Soru: WF ile tek select' te herbir kategoride kaç farklý marka olduðunu hesaplayabilir miyiz?



select distinct category_id, COUNT(brand_id) over(partition by category_id) num_of_brand
from (

select distinct category_id, brand_id
from	production.products

) A


---- 2. ANALYTIC NAVIGATION FUNCTIONS --


--first_value() - last_value() - lead() - lag()


--Order tablosuna aþaðýdaki gibi yeni bir sütun ekleyiniz:
--1. Herbir personelin bir önceki satýþýnýn sipariþ tarihini yazdýrýnýz (LAG fonksiyonunu kullanýnýz)



SELECT	*, 
		LAG(order_date, 1) OVER (PARTITION BY staff_id ORDER BY Order_date, order_id) prev_ord_date
FROM	sales.orders



--Order tablosuna aþaðýdaki gibi yeni bir sütun ekleyiniz:
--2. Herbir personelin bir sonraki satýþýnýn sipariþ tarihini yazdýrýnýz (LEAD fonksiyonunu kullanýnýz)


SELECT	*, 
		LEAD(order_date, 1) OVER (PARTITION BY staff_id ORDER BY Order_date, order_id) next_ord_date
FROM	sales.orders



SELECT	*, 
		LEAD(order_date, 2) OVER (PARTITION BY staff_id ORDER BY Order_date, order_id) next_ord_date
FROM	sales.orders



-- Window Frame --



SELECT 
		COUNT (*) OVER () TOTAL_ROW
from	production.products


---


SELECT  DISTINCT category_id,  
		COUNT (*) OVER () TOTAL_ROW,
		COUNT (*) OVER (PARTITION BY category_id) num_of_row,
		COUNT (*) OVER (PARTITION BY category_id ORDER BY product_id) num_of_row
from	production.products


---


SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current
from	production.products


---

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id





SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id



--


SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id


--


SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id



--

SELECT	category_id,
		COUNT(*) OVER( ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id



---


--1. Tüm bisikletler arasýnda en ucuz bisikletin adý (FIRST_VALUE fonksiyonunu kullanýnýz)


SELECT	FIRST_VALUE(product_name) OVER ( ORDER BY list_price)
FROM	production.products


--ürünün yanýna list price' ýný nasýl eklersiniz?

SELECT	 DISTINCT FIRST_VALUE(product_name) OVER ( ORDER BY list_price) , min (list_price) over ()
FROM	production.products




--2. Herbir kategorideki en ucuz bisikletin adý (FIRST_VALUE fonksiyonunu kullanýnýz)



select distinct category_id, FIRST_VALUE(product_name) over (partition by category_id order by list_price)
from production.products



--1. Tüm bisikletler arasýnda en ucuz bisikletin adý (LAST_VALUE fonksiyonunu kullanýnýz)


SELECT	DISTINCT 
		FIRST_VALUE(product_name) OVER ( ORDER BY list_price),
		LAST_VALUE(product_name) OVER (	ORDER BY list_price desc ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM	production.products





-- 3. ANALYTIC NUMBERING FUNCTIONS --


--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()



--1. Herbir kategori içinde bisikletlerin fiyat sýralamasýný yapýnýz (artan fiyata göre 1'den baþlayýp birer birer artacak)


SELECT	category_id, list_price, 
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM
FROM	production.products



--2. Ayný soruyu ayný fiyatlý bisikletler ayný sýra numarasýný alacak þekilde yapýnýz (RANK fonksiyonunu kullanýnýz)


SELECT	category_id, list_price, 
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM
FROM	production.products


--3. Ayný soruyu ayný fiyatlý bisikletler ayný sýra numarasýný alacak þekilde yapýnýz (DENSE_RANK fonksiyonunu kullanýnýz)

SELECT	category_id, list_price, 
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM
FROM	production.products



--4. Herbir kategori içinde bisikletierin fiyatlarýna göre bulunduklarý yüzdelik dilimleri yazdýrýnýz. (CUME_DIST fonksiyonunu kullanýnýz)

--5. Herbir kategori içinde bisikletierin fiyatlarýna göre bulunduklarý yüzdelik dilimleri yazdýrýnýz. (PERCENT_RANK fonksiyonunu kullanýnýz)

SELECT	category_id, list_price, 
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK
FROM	production.products


--6. Herbir kategorideki bisikletleri artan fiyata göre 4 gruba ayýrýn. Mümkünse her grupta ayný sayýda bisiklet olacak. 
--(NTILE fonksiyonunu kullanýnýz)


SELECT	category_id, list_price, 
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK,
		NTILE(4) OVER (PARTITION BY category_id ORDER BY list_price) ntil
FROM	production.products


---

--maðazalarýn 2016 yýlýna ait haftalýk hareketli sipariþ sayýlarýný hesaplayýnýz






--'2016-03-12' ve '2016-04-12' arasýnda satýlan ürün sayýsýnýn 7 günlük hareketli ortalamasýný hesaplayýn.










