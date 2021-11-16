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

--6.??? Инструкция SELECT, использующая предикат сравнения с квантором
-- Список туров в отель 1, продолжительность которых больше чем в отеле 8
SELECT tourid, nametour, duration 
FROM packages.tours 
WHERE duration > ALL (
	SELECT duration 
	FROM packages.tours 
	WHERE hotelid = 1
) AND hotelid = 8


--7. Инструкция SELECT, использующая агрегатные функции в выражениях столбцов
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



--10. Инструкция SELECT, использующая поисковое выражение CASE.
-- Разделение путевок по цене
SELECT 
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
INTO TAustralia
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
-- Т



--13. Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3. 


--14. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING


--15. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING. 


--16. Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений. 


--17. Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса. 


--18. Простая инструкция UPDATE. 


--19. Инструкция UPDATE со скалярным подзапросом в предложении SET. 


--20. Простая инструкция DELETE. 


--21. Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE. 


--22. Инструкция SELECT, использующая простое обобщенное табличное выражение


--23. Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение


--24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER() 


--25. Оконные фнкции для устранения дублей











