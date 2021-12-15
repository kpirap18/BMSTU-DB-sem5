create table employee (
	id int not null primary key,
	fio varchar,
	birthdate date, 
	department varchar
);

create table record(
	id_employee int references employee(id) not null,
	rdate date,
	dayweek varchar,
	rtime time,
	rtype int
);


insert into employee(
	id,
	fio,
	birthdate, 
	department
) values 
	(1, 'FIO1', '25-09-1995', 'IT'),
	(2, 'FIO2', '30-09-1999', 'IT'),
	(3, 'FIO3', '25-09-1990', 'Fin'),
	(4, 'FIO4', '15-09-1997', 'Fin');


insert into employee(
	id,
	fio,
	birthdate, 
	department
) values 
	(5, 'FIO5', '25-09-1995', 'IT'),
	(6, 'FIO6', '30-09-1999', 'IT'),
	(7, 'FIO7', '25-09-1990', 'Fin'),
	(8, 'FIO8', '15-09-1997', 'Fin'),
	(9, 'FIO9', '25-09-1990', 'Fin'),
	(10, 'FIO10', '25-09-1991', 'Fin'),
	(11, 'FIO11', '22-09-1992', 'Fin'),
	(12, 'FIO12', '26-09-1993', 'Fin'),
	(13, 'FIO13', '25-09-1994', 'Fin'),
	(14, 'FIO14', '15-09-1995', 'Fin'),
	(15, 'FIO15', '24-09-1996', 'Fin'),
	(16, 'FIO16', '22-09-1996', 'Fin'),
	(17, 'FIO17', '25-05-1994', 'Fin'),
	(18, 'FIO18', '25-04-1997', 'Fin');


insert into record(
	id_employee, 
	rdate, 
	dayweek, 
	rtime, 
	rtype
) values
	(1, '20-12-2019', 'Понедельник', '09:01', 1),
	(1, '20-12-2019', 'Понедельник', '09:12', 2),
	(1, '20-12-2019', 'Понедельник', '09:40', 1),
	(1, '20-12-2019', 'Понедельник', '12:01', 2),
	(1, '20-12-2019', 'Понедельник', '13:40', 1),
	(1, '20-12-2019', 'Понедельник', '20:40', 2),
	
	(1, '21-12-2019', 'Понедельник', '09:01', 1),
	(1, '21-12-2019', 'Понедельник', '09:12', 2),
	(1, '21-12-2019', 'Понедельник', '09:40', 1),
	(1, '21-12-2019', 'Понедельник', '12:01', 2),
	(1, '21-12-2019', 'Понедельник', '13:40', 1),
	(1, '21-12-2019', 'Понедельник', '20:40', 2),
	
	(1, '22-12-2019', 'Понедельник', '09:01', 1),
	(1, '22-12-2019', 'Понедельник', '09:12', 2),
	(1, '22-12-2019', 'Понедельник', '09:40', 1),
	(1, '22-12-2019', 'Понедельник', '12:01', 2),
	(1, '22-12-2019', 'Понедельник', '13:40', 1),
	(1, '22-12-2019', 'Понедельник', '20:40', 2),
	
	
	(3, '21-12-2019', 'Понедельник', '09:01', 1),
	(3, '21-12-2019', 'Понедельник', '09:12', 2),
	(3, '21-12-2019', 'Понедельник', '09:40', 1),
	(3, '21-12-2019', 'Понедельник', '12:01', 2),
	(3, '21-12-2019', 'Понедельник', '13:40', 1),
	(3, '21-12-2019', 'Понедельник', '20:40', 2),

	(2, '21-12-2019', 'Понедельник', '08:51', 1),
	(2, '21-12-2019', 'Понедельник', '20:31', 2),

	(4, '21-12-2019', 'Понедельник', '09:51', 1),
	(4, '21-12-2019', 'Понедельник', '20:31', 2),

	(1, '23-12-2019', 'Среда', '09:11', 1),
	(1, '23-12-2019', 'Среда', '09:12', 2),
	(1, '23-12-2019', 'Среда', '09:40', 1),
	(1, '23-12-2019', 'Среда', '20:01', 2),

	(3, '23-12-2019', 'Среда', '09:01', 1),
	(3, '23-12-2019', 'Среда', '09:12', 2),
	(3, '23-12-2019', 'Среда', '09:50', 1),
	(3, '23-12-2019', 'Среда', '20:01', 2),

	(2, '23-12-2019', 'Среда', '08:41', 1),
	(2, '23-12-2019', 'Среда', '20:31', 2),

	(4, '23-12-2019', 'Среда', '09:51', 1),
	(4, '23-12-2019', 'Среда', '20:31', 2);



--########### Вариант 1 ###########--
-- Написать скалярную функцию, возвращающую количество сотрудников в возрасте от 18 до
-- 40, выходивших более 3х раз.
create extension plpython3u;

create or replace function latters_cnt(target_date date) 
returns int 
as $$
	BEGIN
	RETURN(
		select count(*)
		from(
			select distinct id
			from employee
			where EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate) BETWEEN 18 and 40 and 
			id in(
				select id_employee
				from(
					select id_employee, rdate, rtype, count(*)
					from record
					where rdate = target_date
					group by id_employee, rdate, rtype
					having rtype = 2 and count(*) >= 3
					) as tmp0
				)
			) as tmp1
		);
	END;
	$$ language plpgsql;

create or replace function latters_cnt2(target_date varchar) 
RETURNS INT
AS $$
count_ = 0
result_ = plpy.execute(f" \
				SELECT id_employee, birthdate, rdate, rtype \
				FROM employee e JOIN record r ON e.id = r.id_employee \
				group by id_employee, birthdate, rdate, rtype \
				having count(*) > 2;")

for i in result_:
	if i["rtype"] == 2 and i["rdate"] == target_date:
		count_ += 1
return count_
$$ LANGUAGE plpython3u;


SELECT id_employee, birthdate, rdate, rtype
FROM employee e JOIN record r ON e.id = r.id_employee 
group by id_employee, birthdate, rdate, rtype
having count(*) >2 


SELECT * FROM record;
select * from latters_cnt2('2019-12-21')

-- Задание 1 часть 2.
-- Кол-во опоздавших сотрудников.
-- Дата опоздания в кач-ве параметра.
CREATE OR REPLACE FUNCTION get_latecomers(dt DATE)
RETURNS INT
AS
$$
    SELECT COUNT(id_employee) AS cnt
    FROM record
    WHERE rdate = dt
    AND rtime > '09:00:00'
    AND rtype = 1;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_latecomers2(dt DATE)
RETURNS INT
AS $$
count_ = 0
plan = plpy.prepare("SELECT DISTINCT id_employee \
				FROM record \
				WHERE rdate = $1 AND rtime > '09:00:00' AND rtype = 1;", ["DATE"])

run = plpy.execute(plan, [dt])
count_ = run.nrows()
return count_
$$ LANGUAGE plpython3u;

SELECT count(DISTINCT id_employee)
FROM record
WHERE rdate = '2019-12-21'
AND rtime > '09:00:00'
AND rtype = 1

SELECT get_latecomers2('2019-12-21') AS cnt;


-- Задание 2
-- пишется на питоне, но запросы проверю тут
-- !!!1. Найти все отделы, в которых работает более 10 сотрудников
select department
from employee
group by department
having count(id) > 10;

-- !!!2. Найти сотрудников, которые не выходят с рабочего места 
-- в течение всего рабочего дня
select id
from employee
where id not in(
	select id_employee
	from (
		select id_employee, rdate, rtype, count(*)
		from record
		group by id_employee, rdate, rtype
		having rtype=2 and count(*) > 1
		) as tmp
);

SELECT DISTINCT id_employee
FROM record r 
WHERE rtype = 2
GROUP BY id_employee , rdate
HAVING COUNT(*) = 1; --с учетом ухода домой



-- !!!3. Найти все отделы, в которых есть сотрудники, опоздавшие \
-- в определенную дату. Дату передавать с клавиатуры
select distinct department
from employee
where id in 
(
	select id_employee
	from
	(
		select id_employee, min(rtime)
		from record
		where rtype = 1 and rdate = '23-12-2019'
		group by id_employee
		having min(rtime) > '9:00'
	) as tmp
);


-- 4. Отделы, в которых сотрудники опаздывают более 2х раз в неделю
--SELECT id, fio, department
--FROM employee t1
---- И если существет таблица, показывающая
---- В какие недели работник опаздывал,
---- То выводим его отдел.
--WHERE EXISTS
--(
--    -- Внутренный запрос вернет таблицу, в которой
--    -- Первой столбец будет неделя (по счету, первая, вторя...)
--    -- А второй, кол-во опозданий сотрудника в этой недели.
--    -- Соотвтетственно, если опозданий нет, то таблица пуста.
    SELECT date_part, COUNT(id_employee) AS cnt, department 
    FROM
    (
    	select id_employee, EXTRACT(WEEK FROM rdate) AS date_part
		from record r
		where rtype = 1 
		group by id_employee, rdate
		having min(rtime) > '9:00'
		
    ) AS tmp join employee e on tmp.id_employee = e.id 
    GROUP BY date_part, department 
    HAVING COUNT(id_employee) > 2
--);

    
    ----------
select id_employee, rtime, --, min(rtime)
		from record 
		where rtype = 1 and rdate = '23-12-2019'
		group by id_employee
		having min(rtime) > '9:00'

select *
from employee e join record r on e.id =r.id_employee 



-- ????????????????????????5. Найти средний возраст сотрудников, не находящихся
-- на рабочем месте 8 часов в день.

-- Получиь возраст.
SELECT *, (CURRENT_DATE - e.birthdate) / 7 / 52  -- 7 - дней в неделе, 52 - недель в году.
FROM employee e;


SELECT AVG(age)
FROM (
    SELECT *, (CURRENT_DATE - employee.birthdate) / 7 / 52 AS age   -- 7 - дней в неделе, 52 - недель в году.
    FROM
    (
        SELECT *,
        (
            SELECT EXTRACT(HOURS FROM e_v2.rtime) - EXTRACT(HOURS FROM e_v.rtime) -- e_v2.employee_time - e_v.employee_time
            FROM record e_v2
            WHERE id_employee = e_v.id_employee
            AND e_v2.rdate = e_v.rdate
            AND rtype = 2
        ) AS working_hours
        FROM record  e_v
        WHERE rtype = 1
    ) AS tmp JOIN employee ON tmp.id_employee = employee.id
    WHERE working_hours <= 8) AS table_res;

SELECT *, e_v.rtime
FROM record e_v;



-- ????6. Все отделы и кол-во сотрудников
-- Хоть раз опоздавших за всю историю учета.

SELECT department, COUNT(employee.id)
FROM employee
JOIN record ev on employee.id = ev.id_employee
WHERE rtype = 1
GROUP BY department
HAVING min(rtime) > '09:00:00'

select *
from employee e join record r on e.id =r.id_employee 

SELECT table1.department, COUNT(table1.id)
FROM employee AS table1
INNER JOIN record AS table2 ON (table2.id_employee = table1.id)
WHERE (table2.rtype = 1)
GROUP BY table1."department"
having min(rtime) > '9:00'


SELECT table1.department, COUNT(table1.id)
FROM employee AS table1
INNER JOIN record AS table2 ON (table2.id_employee = table1.id)
WHERE ((table2.rtime > '09:00:00') AND (table2.rtype = 1))
GROUP BY table1."department"
HAVING Count(table1.id) > 2



-- !!!7. Найти самого старшего сотрудника в бухгалтерии

SELECT id, fio, birthdate 
FROM employee
WHERE department = 'IT' AND birthdate =
(SELECT MIN(birthdate)
FROM employee
WHERE department = 'IT'
);


-- 8. Найти сотрудников, выходивших больше 3-х раз с рабочего места
SELECT DISTINCT id_employee , COUNT(*)
FROM record r 
WHERE rtype = 2
GROUP BY id_employee , rdate
HAVING COUNT(*) > 2; -- с учетом ухода домой


-- 9. Найти сотрудника, который пришел сегодня последним
SELECT fio, rtime
FROM employee e JOIN record ea on e.id = ea.id_employee
WHERE ea.rdate = '21-12-2019' AND ea.rtype = 1 AND ea.rtime =
	(SELECT MAX(rtime)
	FROM record empl_att
	WHERE empl_att.rtype = 1) AND ea.rtime =
	(SELECT MIN(rtime)
	FROM record empl_att
	WHERE empl_att.rtype = 1 and empl_att.id_employee = e.id)













