-- ### Скалярная функция
-- Кол-во посетителей в отеле, название которого ...
CREATE OR REPLACE FUNCTION public.count_clients (hotel VARCHAR(100))
returns int  AS ' 
	SELECT sum(t.numberpeople)
	FROM packages.trpackages t JOIN packages.tours t2  ON t.tourid = t2.tourid 
							   JOIN packages.hotels h ON t2.hotelid = h.hotelid 
	WHERE h.namehotel = hotel
' LANGUAGE SQL;	

SELECT public.count_clients('Jennifer Lopez') 

-- Максимальная стоимость при кол-ве человек ..
CREATE OR REPLACE FUNCTION get_max_price_where_number(i int)
RETURNS int AS '
	select max(price)
	from packages.trpackages 
	where numberpeople = i; 
' LANGUAGE SQL;

SELECT get_max_price_where_number(2);

-- Просто максимальная стоимость путевки
CREATE OR REPLACE FUNCTION get_max_price()
RETURNS int AS '
	select max(price)
	from packages.trpackages;
' LANGUAGE SQL;

SELECT get_max_price();


-- ### Подставляемная табличная функция
-- Все путевки, туроператорами которых является фирма, id которой ...
CREATE OR REPLACE FUNCTION get_packages_idtour(id int = 1)
RETURNS TABLE 
(
	TrPackagesId INT,
	TourId INT,
	CompanyId INT,
	DataDis DATE,
	Price INT,
    NumberPeople INT
)
AS ' 
	SELECT *
	FROM packages.trpackages t
	WHERE t.companyid = id
' LANGUAGE SQL;

SELECT *
FROM get_packages_idtour(178);


-- вывести пользователя с таким - то id
CREATE OR REPLACE FUNCTION get_user(u_id INT = 0) -- По умолчанию == 0.
RETURNS fortest AS '
    SELECT *
    FROM fortest
    WHERE testid = u_id;
' LANGUAGE  sql;

SELECT *
FROM get_user(2);


-- ### Многооператорная табличная функция
-- Путевки от такой-то компании или с такой-то ценой
CREATE OR REPLACE FUNCTION get_packages_com_price(com int, pricen int)
RETURNS TABLE 
(
	TrPackagesId INT,
	CompanyId INT,
	DataDis DATE,
	Price INT,
    NumberPeople INT
)
AS ' 
begin
	RETURN QUERY
	SELECT t.trpackagesid , t.companyid, t.datadis, t.price, t.numberpeople 
	FROM packages.trpackages t 
	WHERE t.companyid  = com;
	
	RETURN QUERY
	SELECT t.trpackagesid , t.companyid, t.datadis, t.price, t.numberpeople 
	FROM packages.trpackages t 
	WHERE t.price = pricen;
end;
' LANGUAGE plpgsql;

SELECT *
FROM get_packages_com_price(21, 4500);


-- ### Рекурсивная функция
-- вывести все отели, начиная с какого-то id
CREATE OR REPLACE FUNCTION all_hotel(in_id INT)
RETURNS TABLE
(
	HotelId INT,
    NameHotel VARCHAR(100),
    CountryId INT,
    Region VARCHAR(100),
    CategoryId  INT
)
AS '
	DECLARE
	    elem INT;
	BEGIN
	    RETURN QUERY
	    SELECT *
	    FROM packages.hotels h
	    WHERE h.hotelid = in_id;
	    FOR elem IN
	        SELECT *
	        FROM packages.hotels h
	        WHERE h.cityd = in_id
	    LOOP
	            -- RAISE NOTICE ''ELEM = % '', elem;
	            RETURN QUERY
	            SELECT *
	            FROM all_hotel(elem);
	    END LOOP;
	END;
' LANGUAGE plpgsql;

SELECT *
FROM all_hotel(2);

-- еще одна задача, потому что мне показалось логичнее сделать
-- еще и это + к тому, что сделала...
-- просто Ира...
CREATE OR REPLACE FUNCTION all_users_dop(in_id INT)
RETURNS TABLE
(
    testId  INT,
    NameTest VARCHAR(100),
    TestAddId INT,
    CountryeTest VARCHAR(100)
)
AS '
DECLARE
    elem INT;
BEGIN
    RETURN QUERY
    SELECT *
    FROM fortest
    WHERE fortest.testId = in_id;
    FOR elem IN
        SELECT *
        FROM fortest
        WHERE fortest.TestAddId = in_id and fortest.TestAddId != 4
    LOOP
            -- RAISE NOTICE ''ELEM = % '', elem;
            RETURN QUERY
            SELECT *
            FROM all_users_dop(elem);
    END LOOP;
END;
' LANGUAGE plpgsql;

SELECT *
FROM all_users_dop(1);

-- Числа Фибоначи
CREATE OR REPLACE FUNCTION fib(first INT, second INT,max INT)
RETURNS TABLE (fibonacci INT)
AS '
BEGIN
    RETURN QUERY
    SELECT first;
    IF second <= max THEN
        RETURN QUERY
        SELECT *
        FROM fib(second, first + second, max);
    END IF;
END' LANGUAGE plpgsql;

SELECT *
FROM fib(1,1, 13);




-- ############################################################ --
-- ### Хранимую процедуру без параметров или с параметрами
-- Изменить звездность отеля с id...
CREATE OR REPLACE PROCEDURE change_star
(
	star int,
	idd int	
)
AS '
BEGIN
	UPDATE packages.hotels 
    SET categoryid = star
    WHERE hotelid = idd;
END;
' LANGUAGE plpgsql;
   
CALL change_star(3, 1);

-- Без параметров (поменять звездность у всех отелей, 
-- у которых было 5, стало 3) - ну бывает...
SELECT * INTO hotel_star
FROM packages.hotels h ;
SELECT * FROM hotel_star;

DROP TABLE hotel_star;

CREATE OR REPLACE PROCEDURE change_star_all()
AS '
BEGIN
	UPDATE hotel_star
    SET categoryid = 3
    WHERE categoryid = 5;
END;
' LANGUAGE plpgsql;
   
CALL change_star_all();

-- сделать цену как кол-во * 500
SELECT * INTO travelpackages_price
FROM packages.trpackages t ;
SELECT * FROM travelpackages_price;

DROP TABLE travelpackages_price;

CREATE OR REPLACE PROCEDURE change_price()
AS '
BEGIN
	UPDATE travelpackages_price
    SET price = 500 * numberpeople;
END;
' LANGUAGE plpgsql;

CALL change_price(); 


-- ### Рекурсивную хранимую процедуру или хранимую процедур с рекурсивным ОТВ
-- Сначала создам тестовую таблицу
CREATE TABLE public.fortest(
    testId  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NameTest VARCHAR(100) NOT NULL,
    TestAddId INT NOT NULL,
    CountryeTest VARCHAR(100) NOT NULL
);
copy public.fortest(NameTest, TestAddId, CountryeTest) from '/home/kpirap18/db1/lab_03/test.csv' delimiter ';';
select * from public.fortest

DROP TABLE fortest;

-- Баллы за каждого приглашенного участника 
CREATE OR REPLACE PROCEDURE what_bonus
(
    res INOUT INT,
    in_id INT,
    coef FLOAT DEFAULT 1
)
AS '
DECLARE
    elem INT;
BEGIN
    IF coef >= 0 THEN
        res = res + 1000 * coef;
    	RAISE NOTICE ''id = %, res = %, coef = %'',in_id, res, coef;
    	FOR elem IN
       		SELECT *
        	FROM fortest
        	WHERE TestAddId = in_id
        	LOOP
            	CALL what_bonus(res, elem, coef - 0.1);
        	END LOOP;
    END IF;
    
END;
' LANGUAGE plpgsql;

CALL what_bonus(0, 1);

-- числа Фиббоначи (чисто потому что это самая известная рекурсия)
CREATE OR REPLACE PROCEDURE fib_index
(
	res INOUT int,
	index_ int,
	start_ int DEFAULT 1, 
	end_ int DEFAULT 1
)
AS ' 
BEGIN
	IF index_ > 0 THEN
		RAISE NOTICE ''elem = %'', res;
		res = start_ + end_;
		CALL fib_index(res, index_ - 1, end_, start_ + end_);
	END IF;
END; 
' LANGUAGE plpgsql;

CALL fib_index(1, 5); 

-- ### Хранимую процедуру с курсором
-- Одним из способов возврата результатов работы хранимых процедур является 
-- формирование результирующего множества. Данное множество формируется при 
-- выполнении оператора SELECT. Оно записывается во временную таблицу - курсор. 
CREATE OR REPLACE PROCEDURE find_cities
(
	Country VARCHAR(100)
)
AS '
DECLARE
	city VARCHAR(100);
    myCursor CURSOR 
	FOR
        SELECT c.namecity 
		FROM location1.cities c JOIN location1.countries c2 ON c.countryid = c2.countryid 
		WHERE c2.namecountry = Country;
BEGIN
    OPEN myCursor;
    LOOP
        -- FETCH - Получает следующую строку из курсора
        -- И присваевает в переменную, которая стоит после INTO.
        -- Если строка не найдена (конец), то присваевается значение NULL.
        FETCH myCursor
        INTO city;
        -- Выходим из цикла, если нет больше строк (Т.е. конец).
        EXIT WHEN NOT FOUND;
        RAISE NOTICE ''City =  %'', city;
    END LOOP;
    CLOSE myCursor;
END;
'LANGUAGE  plpgsql;

CALL find_cities('Russia');


-- ### Хранимую процедуру доступа к метаданным
CREATE OR REPLACE PROCEDURE access_to_meta
(
	tablename VARCHAR(100)
)
AS '
DECLARE
	buf RECORD;
    myCursor CURSOR 
	FOR
        SELECT column_name, data_type
		FROM information_schema.columns
        WHERE table_name = tablename;
BEGIN
    OPEN myCursor;
    LOOP
		FETCH myCursor
        INTO buf;
		EXIT WHEN NOT FOUND;
        RAISE NOTICE ''column name = %; data type = %'', buf.column_name, buf.data_type;
    END LOOP;
	CLOSE myCursor;
END;
' LANGUAGE plpgsql;

CALL access_to_meta('hotels');

-- метаданные без курсора
CREATE OR REPLACE PROCEDURE access_to_meta2(
	name_ VARCHAR(100)
)
AS ' 
DECLARE
	el RECORD;
BEGIN
	FOR el IN
		SELECT column_name, data_type
		FROM information_schema.columns
        WHERE table_name = name_
	LOOP
		RAISE NOTICE ''el = %'', el;
	END LOOP;
END;
' LANGUAGE plpgsql;

CALL access_to_meta2('hotels');

-- ############################################################ --
SELECT * INTO city_buf
FROM location1.cities;
SELECT * FROM city_buf;

DROP TABLE city_buf;

-- ### Триггер AFTER
-- AFTER - оперделяет, что заданная цункция будет вызываться после события.
-- Если изменить id страны для одного города в этой стране, 
-- то надо изменить такие же id для других городов этой страны
CREATE OR REPLACE FUNCTION update_trigger()
RETURNS TRIGGER 
AS '
BEGIN
	RAISE NOTICE ''New =  %'', new;
    RAISE NOTICE ''Old =  %'', old; RAISE NOTICE ''New =  %'', new;

	UPDATE city_buf
	SET countryid = new.countryid
	WHERE city_buf.countryid = old.countryid;
	
	RETURN new;
END;
' LANGUAGE plpgsql;

CREATE TRIGGER update_my
AFTER UPDATE ON city_buf 
FOR EACH ROW 
EXECUTE PROCEDURE update_trigger();

--UPDATE city_buf 
--SET countryid = 2
--WHERE countryid = 1;


-- ### Триггер INSTEAD OF
-- INSTEAD OF - Сработает вместо указанной операции.
-- если захотят удалить путевку, то его не удалим, 
-- а просто сделаем имя как none
-- делаем все в копии (я не хочу портить исходную таблицу...)
CREATE VIEW tours_buf AS 
SELECT * -- INTO tours_buf
FROM packages.tours t ;
SELECT * FROM tours_buf;

DROP view tours_buf;

CREATE OR REPLACE FUNCTION del_packages()
RETURNS TRIGGER 
AS ' 
BEGIN
    RAISE NOTICE ''New =  %'', new;

    UPDATE tours_buf
    SET nametour = ''none'' 
    WHERE tours_buf.nametour = old.nametour;
    RETURN new;
END;
' LANGUAGE plpgsql;

CREATE TRIGGER del_packages_trigger
INSTEAD OF DELETE ON tours_buf
	FOR EACH ROW 
	EXECUTE PROCEDURE del_packages();

DELETE FROM tours_buf 
WHERE tours_buf.cityid = 1;


SELECT * FROM tours_buf
ORDER BY cityid;

