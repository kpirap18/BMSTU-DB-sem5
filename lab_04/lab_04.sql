
select * from pg_language;
SELECT name, default_version, installed_version FROM pg_available_extensions 
create extension plpython3u;

-- • Определяемую пользователем скалярную функцию CLR
-- Получить города страны с индексом id 
CREATE OR REPLACE FUNCTION get_name_country(id INT)
RETURNS VARCHAR
AS $$
res = plpy.execute(f" \
    SELECT namecountry \
    FROM location1.countries  \
    WHERE countryid = {id};", 2)
if res:
    return res[0]['namecountry']
$$ LANGUAGE plpython3u;

SELECT * 
FROM location1.cities c JOIN location1.countries c2 ON c.countryid = c2.countryid 
WHERE c2.namecountry = get_name_country(1);


-- • Пользовательскую агрегатную функцию CLR
-- Агрегатные функции получают единственный 
-- результат из набора входных значений.
CREATE OR REPLACE FUNCTION count_hotel(a int, region VARCHAR)
RETURNS INT
AS $$
count_ = 0
result_ = plpy.execute(f" \
				select * \
				from packages.hotels;")
for i in result_:
	if i["region"] == region:
		count_ += 1
return count_
$$ LANGUAGE plpython3u;

CREATE AGGREGATE hotel_in_region(Varchar)
(
	sfunc = count_hotel,
	stype = int
);

SELECT hotel_in_region('AngolaRegion1') FROM packages.hotels;

-- Проверка на пока еще нерабочую функцию
SELECT region, count(region) 
FROM packages.hotels h 
GROUP BY region
ORDER BY region;


--!!! • Определяемую пользователем табличную функцию CLR
-- Все туры в стране такой-то...
CREATE OR REPLACE FUNCTION tour_in_cointry(namecountry VARCHAR)
RETURNS TABLE 
(
	tourid INT,
	nametour VARCHAR,
	namecountry VARCHAR
)
AS $$
buf = plpy.execute(f" \
select t.tourid, t.nametour, t.typetour, c2.namecountry  \
from packages.tours t join location1.cities c on t.cityid = c.cityid \
join location1.countries c2 on c.countryid = c2.countryid")
result_ = []
for i in buf:
	if i["namecountry"] == namecountry:
		result_.append(i)
return result_
$$ LANGUAGE plpython3u;

DROP FUNCTION tour_in_cointry(character varying)
SELECT * FROM tour_in_cointry('Russia');

-- Проверка
SELECT t.tourid, t.nametour, t.typetour, t.cityid, t.travelonoff, t.powersupply, t.duration, t.hotelid 
FROM packages.tours t JOIN location1.cities c ON t.cityid = c.cityid 
					  JOIN location1.countries c2 ON c.countryid = c2.countryid
WHERE c2.namecountry = 'Russia';


-- • Хранимую процедуру CLR
-- Меняет звездность отелей с old_star на new_star
CREATE OR REPLACE FUNCTION change_star(old_star int, new_star int)
RETURNS void
AS $$
	plan = plpy.prepare("UPDATE hotel_star set categoryid = $1 where categoryid = $2", ["INT", "INT"])
	plpy.execute(plan, [new_star, old_star])
$$ LANGUAGE plpython3u;

select * from change_star(1, 2);
select *
from hotel_star hs 

SELECT * INTO hotel_copy
FROM packages.hotels h ;
SELECT * FROM hotel_copy;


CREATE OR REPLACE FUNCTION del_hotel(id_ int)
RETURNS void
AS $$
	plan = plpy.prepare("DELETE from hotel_copy where hotelid = $1", ["INT"])
	plpy.execute(plan, [id_])
$$ LANGUAGE plpython3u;

SELECT * FROM del_hotel(7);

-- • Триггер CLR
CREATE VIEW hotels_buf AS 
SELECT * -- INTO hotels_buf
FROM packages.hotels h ;
SELECT * FROM hotels_buf;

DROP view hotels_buf;

CREATE OR REPLACE FUNCTION delete_hotel()
RETURNS TRIGGER 
AS $$
del_id = TD["old"]["hotelid"]
run = plpy.execute(f" \
update hotels_buf set namehotel = \'none\' \
where hotels_buf.hotelid = {del_id}")

return TD["new"]
$$ LANGUAGE plpython3u;

CREATE TRIGGER delete_hotel_trigger
INSTEAD OF DELETE ON hotels_buf
FOR EACH ROW 
EXECUTE PROCEDURE delete_hotel();

DELETE FROM hotels_buf
WHERE hotelid = 2

-- !!!• Определяемый пользователем тип данных CLR
CREATE TYPE type_dur1 AS
(
	typetour VARCHAR,
	duration INT
);

CREATE OR REPLACE FUNCTION get_type_dur(ttype VARCHAR)
RETURNS type_dur1
AS $$
	plan = plpy.prepare(" 			\
	select typetour, max(duration) as duration 	\
	from packages.tours				\
	where typetour = $1      		\
	group by typetour;", ["VARCHAR"])
	run = plpy.execute(plan, [ttype])
	
	if (run.nrows()):
		return (run[0]["typetour"], run[0]["duration"])
$$ LANGUAGE plpython3u;

DROP FUNCTION get_type_dur(character varying)

SELECT * 
FROM get_type_dur('sports');




-- Проверка 
	select duration, max(typetour) 	
	from packages.tours 			
	where duration = 2
	GROUP BY duration ;

select typetour, max(duration) 
from packages.tours 
where typetour = 'sports'
GROUP BY typetour 


--  ЗАЩИТА продедура по id отеля меняет тип тура

SELECT * INTO tour_copy
FROM packages.tours t;
SELECT * FROM tour_copy;

CREATE OR REPLACE PROCEDURE tour_type(id int, new_type varchar)
AS $$
	plan = plpy.prepare("UPDATE tour_copy set typetour = $1 where tourid = $2", ["VARCHAR", "INT"])
	plpy.execute(plan, [new_type, id])
$$ LANGUAGE plpython3u;

CALL tour_type(3, 'sports');

















