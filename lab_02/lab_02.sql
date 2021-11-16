--1. Инструкция SELECT, использующая предикат сравнения. 
SELECT DISTINCT table1.namehotel, table2.typecategory
FROM packages.hotels AS table1 JOIN packages.categoryhotel AS table2 ON table1.categoryid = table2.categoryid 
WHERE table2.typecategory = 'Luxe'
ORDER BY table1.namehotel, table2.typecategory

--2. Инструкция SELECT, использующая предикат BETWEEN. 
-- Путевки, цена которых от 1000 до 1500
SELECT DISTINCT packages.trpackages.trpackagesid, packages.trpackages.price 
FROM packages.trpackages 
WHERE price BETWEEN 1000 AND 1500

--3. Инструкция SELECT, использующая предикат LIKE. 
-- Путевки, отправление которых в июле
SELECT DISTINCT packages.trpackages.trpackagesid, packages.trpackages.datadis 
FROM packages.trpackages 
WHERE CAST(datadis AS varchar(11)) LIKE '%_07_%'


--4. Инструкция SELECT, использующая предикат IN с вложенным подзапросом. 
-- Туры, которые в Австрии
SELECT packages.tours.tourid, packages.tours.nametour 
FROM packages.tours 
WHERE hotelid IN (
	SELECT t1.hotelid 
	FROM packages.hotels AS t1 JOIN location1.cities AS t2 ON t1.cityd = t2.cityid 
	WHERE t2.namecity = 'Tokyo'
)

--5. Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом.
SELECT  hotelid, namehotel 
FROM packages.hotels AS t 
WHERE  categoryid = 3 AND 
	EXISTS (
		SELECT t1.hotelid, t1.namehotel 
		FROM packages.hotels AS t1 JOIN location1.cities AS t2 ON t1.cityd = t2.cityid 
		WHERE t2.countryid IN (
			SELECT countryid 
			FROM location1.countries
			WHERE namecountry = 'Russia'
			) 
		AND t.hotelid = t1.hotelid 
) 

--6. Инструкция SELECT, использующая предикат сравнения с квантором
-- Список туров в отель 1, продолжительность которых больше чем в отеле 8
SELECT tourid, nametour, duration 
FROM packages.tours 
WHERE duration > ALL (
	SELECT duration 
	FROM packages.tours 
	WHERE hotelid = 1
) AND hotelid = 8


--7. Инструкция SELECT, использующая агрегатные функции в выражениях столбцов
-- AVG - Эта функция возвращает среднее арифметическое группы значений. Значения NULL она не учитывает.
-- Средняя стоимоть путевки
SELECT AVG(TotalPrice) AS Actual_AVG,
	   SUM(TotalPrice) / COUNT(companyid) AS Calc_AVG
FROM (
	SELECT companyid, SUM(price * numberpeople) AS TotalPrice
	FROM packages.trpackages 
	GROUP BY companyid 
	) AS Totalor
	
	
--8. Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов.
-- Максимальная и средняя продолжительность туров в Libya
SELECT cityid, namecity,
	(
		SELECT AVG(duration)
		FROM packages.tours AS t1
		WHERE t1.hotelid IN 
		(
			SELECT hotelid 
			FROM packages.hotels 
			WHERE cityid = t.cityid
		)
	) AS AvgDur,
	(
		SELECT MAX(duration)
		FROM packages.tours AS t1 
		WHERE t1.hotelid IN 
		(
			SELECT hotelid
			FROM packages.hotels 
			WHERE cityid = t.cityid
		)
	) AS MaxDur
FROM location1.cities AS t
WHERE countryid IN 
(
	SELECT countryid
	FROM location1.countries
	WHERE namecountry = 'Russia'
)
	

--9. Инструкция SELECT, использующая простое выражение CASE. 
SELECT namehotel, categoryid, 
	CASE categoryid 
		WHEN 1 THEN 'simple'
		WHEN 2 THEN 'pLux'
		WHEN 3 THEN 'Luxe'
		WHEN 4 THEN 'best'
		WHEN 5 THEN 'preQ'
		ELSE 'False category'
	END AS what
FROM packages.hotels 
ORDER BY hotelid 


--10. Инструкция SELECT, использующая поисковое выражение CASE.
-- Разделение путевок по цене
SELECT trpackagesid,
	CASE 
		WHEN price < 1500 THEN 'Inexpensive'
		WHEN price < 2500 THEN 'Fair'
		WHEN price < 4000 THEN 'Expensive'
		ELSE 'Very expensive'
	END AS price		
FROM packages.trpackages 


--11. Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT. 
-- Туры в Австию 
SELECT tourid, nametour, typetour, cityid, travelonoff, powersupply, duration, hotelid
INTO TAustraliaSЫЫ
FROM packages.tours 
WHERE hotelid IN 
	(
		SELECT t1.hotelid 
		FROM packages.hotels AS t1 JOIN location1.cities AS t2 ON t1.cityd = t2.cityid
		WHERE countryid IN 
		(
			SELECT countryid
			FROM location1.countries 
			WHERE namecountry = 'Australia'
		)
	)
SELECT * FROM TAustralia
DROP TABLE TAustralia


--12. Инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM. 
-- Путевки с максимальнымой и минимальной стоимостью
SELECT 'MAX' AS Cr, t.trpackagesid, SSQ AS price_all, t.tourid 
FROM packages.trpackages AS t JOIN
	(
		SELECT t1.trpackagesid, SUM(price * numberpeople) AS SSQ
		FROM packages.trpackages AS t1
		GROUP BY t1.trpackagesid 
		ORDER BY SSQ DESC 
	) AS od ON od.trpackagesid = t.trpackagesid 
UNION 
SELECT 'MIN' AS Cr, t.trpackagesid, SSQ AS price_all, t.tourid 
FROM packages.trpackages AS t JOIN
	(
		SELECT t1.trpackagesid, SUM(price * numberpeople) AS SSQ
		FROM packages.trpackages AS t1
		GROUP BY t1.trpackagesid 
		ORDER BY SSQ
	) AS od ON od.trpackagesid = t.trpackagesid 
	

--13. Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3. 
-- Путевки с максимальнымой и минимальной стоимостью
SELECT 'MAX' AS Cr, t.trpackagesid, price 
FROM packages.trpackages AS t 
WHERE tourid =
	(
		SELECT t1.trpackagesid 
		FROM packages.trpackages AS t1
		GROUP BY trpackagesid 
		HAVING SUM(price * numberpeople) = 
		(
			SELECT MAX(SQ)
			FROM 
			(
				SELECT SUM(price * numberpeople) AS SQ
				FROM packages.trpackages 
				GROUP BY trpackagesid 			
			) AS od 
		)
	)
UNION 
SELECT 'MIN' AS Cr, t.trpackagesid, price
FROM packages.trpackages AS t 
WHERE tourid =
	(
		SELECT t1.trpackagesid 
		FROM packages.trpackages AS t1
		GROUP BY trpackagesid 
		HAVING SUM(price * numberpeople) = 
		(
			SELECT MAX(SQ)
			FROM 
			(
				SELECT SUM(price * numberpeople) AS SQ
				FROM packages.trpackages 
				GROUP BY trpackagesid 
			) AS od 
		)
	)
	

--14. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING
-- Средняя и минимальная продолжительность туров в города 
SELECT t.tourid, t.nametour , t.cityid,
	AVG(t.duration) AS AVGdur,
	MIN(t.duration) AS MINdur
FROM packages.tours AS t JOIN location1.cities AS t1 ON t.cityid = t1.cityid 
WHERE t1.countryid BETWEEN 10 AND 50
GROUP BY t.tourid, t.nametour, t.cityid 


--15. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING. 
-- Путевки, средняя цена которых больше средней цены общей
SELECT t.trpackagesid , t.price 
FROM packages.trpackages AS t
GROUP BY t.trpackagesid 
HAVING AVG(price * numberpeople) > 
	(
		SELECT AVG(t1.price * t1.numberpeople)
		FROM packages.trpackages AS t1
	)


--16. Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений. 
INSERT INTO packages.hotels (namehotel, cityd, region, categoryid)
VALUES ('Hotel1', 12, 'SamaraRegion2', 5)

SELECT * FROM packages.hotels 
	

--17. Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса. 
INSERT INTO packages.trpackages (tourid, companyid , datadis, price, numberpeople)
SELECT packages.trpackages.tourid, packages.trpackages.companyid, '2022-04-03', 3000, 1
FROM packages.trpackages 
WHERE tourid = 5

SELECT * FROM packages.trpackages t 


--18. Простая инструкция UPDATE. 
SELECT * FROM packages.trpackages 

UPDATE packages.trpackages 
SET price = price * 1.5
WHERE tourid = 5

SELECT * FROM packages.trpackages t 


--19. Инструкция UPDATE со скалярным подзапросом в предложении SET. 
SELECT * FROM packages.trpackages 

UPDATE packages.trpackages 
SET price =
(
	SELECT AVG(price)
	FROM packages.trpackages
)
WHERE tourid = 1

SELECT * FROM packages.trpackages t 


--20. Простая инструкция DELETE. 
DELETE FROM packages.companies 
WHERE fax IS NULL


--21. Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE. 
INSERT INTO packages.companies (namecompany, city, addresscom, phone, fax, email, director)
VALUES ('Hotel1', '12', 'SamaraRegion2', 12345678911, NULL, NULL, 'Dir fgfgfg')

SELECT * FROM packages.companies c 

DELETE FROM packages.companies 
WHERE companyid IN 
(
	SELECT companyid
	FROM packages.companies
	WHERE fax IS NULL
	ORDER BY companyid desc)

	
--22. Инструкция SELECT, использующая простое обобщенное табличное выражение
-- Табличное выражение продаж туров по месяцам
WITH CTE_sales(salesmonth, salescount, salesprice)
AS
	(
		SELECT EXTRACT(MONTH FROM datadis) AS salesmonth, COUNT(t.trpackagesid), SUM(price * numberpeople)
		FROM packages.trpackages AS t
		GROUP BY EXTRACT(MONTH FROM datadis)  
	)
SELECT * FROM CTE_sales
ORDER BY salesmonth

--23. Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение
WITH RECURSIVE subtable AS
(
	SELECT 
		trpackagesid,
		tourid
	FROM packages.trpackages
	WHERE tourid = 10
	UNION 
		SELECT t1.trpackagesid, t1.tourid 
		FROM packages.trpackages AS t1 JOIN packages.tours AS t2 ON t1.tourid = t2.tourid 
)
SELECT * FROM subtable


--24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER() 

--Order by

--Оператор Order by выполняет сортировку выходных значений, т.е. сортирует извлекаемое значение по определенному столбцу. Сортировку также можно применять по псевдониму столбца, который определяется с помощью оператора.

--Сортировка по возрастанию применяется по умолчанию. Если хотите отсортировать столбцы по убыванию — используйте дополнительный оператор DESC.

--OVER PARTITION BY(столбец для группировки) — это свойство для задания размеров окна. Здесь можно указывать дополнительную информацию, давать служебные команды, например добавить номер строки. Синтаксис оконной функции вписывается прямо в выборку столбцов.

-- Для путевок среднее, мин, макс
SELECT T.tourid, 
		T.price * numberpeople AS price, 
		AVG(T.price * T.numberpeople) OVER(PARTITION BY T.tourid) AS AvgPrice,
		MIN(T.price * T.numberpeople) OVER(PARTITION BY T.tourid) AS MinPrice,
		MAX(T.price * T.numberpeople) OVER(PARTITION BY T.tourid) AS MaxPrice
INTO newTable
FROM packages.trpackages AS T 

SELECT * FROM newtable 

DROP TABLE newtable 



--25. Оконные фнкции для устранения дублей
CREATE TABLE test( name VARCHAR NOT NULL, surname VARCHAR NOT NULL, age INTEGER);
INSERT INTO test (name, surname, age) VALUES 
('Ann', 'Kosenko', 12), ('Brian', 'Shaw', 22), ('Brian', 'Shaw', 22), ('Brian', 'Shaw', 22), ('Ann', 'Kosenko', 12);

SELECT * FROM test 

WITH test_deleted AS(DELETE FROM test RETURNING *),
test_inserted AS(SELECT name, surname, age, ROW_NUMBER() OVER(PARTITION BY name, surname, age ORDER BY name, surname, age) 
 				 rownum FROM test_deleted)INSERT INTO test SELECT name, surname, age
				 FROM test_inserted WHERE rownum = 1;
				
SELECT * FROM test
DROP TABLE test










