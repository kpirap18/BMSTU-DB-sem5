CREATE DATABASE rk2_2;

CREATE TABLE IF NOT EXISTS employee
(
	id int PRIMARY KEY,
	id_department int ,
	post varchar(50),
	fio varchar(50),
	salary int
);


CREATE TABLE IF NOT EXISTS department 
(
	id int PRIMARY KEY,
	named varchar(50),
	manager int,
	phone varchar(15)
);

CREATE TABLE IF NOT EXISTS medication
(
	id int PRIMARY KEY, 
	namem varchar(50),
	manual varchar(50),
	costm int
);

CREATE TABLE IF NOT EXISTS emp_med
(
	id_emp int,
	id_med int,
	FOREIGN KEY (id_emp) REFERENCES department(id),
	FOREIGN KEY (id_med) REFERENCES medication(id)
);


alter table employee
    add constraint FRKEY_DEP_EMP foreign key (id_department) references department(id);

alter table department
    add constraint FRKEY_MEN_EMP foreign key (manager) references employee(id);

INSERT INTO employee (
	id,
	id_department,
	post,
	fio,
	salary
	)
values
	(1, 3, 'm', 'FIO1', 12000),
	(2, 1, 'd', 'FIO2', 45400),
	(3, 5, 'p', 'FIO3', 54230),
	(4, 2, 'k', 'FIO4', 44440),
	(5, 9, 'k', 'FIO5', 62000),
	(6, 8, 'k', 'FIO6', 32000),
	(7, 5, 'm', 'FIO7', 72000),
	(8, 4, 'm', 'FIO8', 92000),
	(9, 6, 'd', 'FIO9', 11000),
	(10, 4, 'p', 'FIO10', 12050);
	
   
INSERT INTO department 
(
	id,
	named,
	manager,
	phone
)
VALUES 
(1, 'Name1', 4, '89473920473'),
(2, 'Name2', 5, '89471214738'),
(3, 'Name3', 1, '89474345763'),
(4, 'Name4', 2, '89471243273'),
(5, 'Name5', 7, '81324242473'),
(6, 'Name6', 9, '89456324473'),
(7, 'Name7', 3, '89475757673'),
(8, 'Name8', 10, '89385754473'),
(9, 'Name9', 6, '89445465673'),
(10, 'Name10',2, '83535366473');





INSERT INTO medication
(
	id, 
	namem,
	manual,
	costm
)
VALUES 
(1, 'Name1', 'manual1', 1213),
(2, 'Name2', 'manual2', 3434),
(3, 'Name3', 'manual3', 553),
(4, 'Name4', 'manual4', 344),
(5, 'Name5', 'manual5', 12),
(6, 'Name6', 'manual6', 334),
(7, 'Name7', 'manual7', 533),
(8, 'Name8', 'manual8', 352),
(9, 'Name9', 'manual9', 90),
(10, 'Name10','manual10', 123);


INSERT INTO emp_med
(
	id_emp,
	id_med
)
VALUES 
(1,3),
(2,7),
(3,2),
(4,4),
(5,2),
(6,8),
(7,6),
(8,9),
(9,10),
(10,1);


-- =================== задание 2 ==============

-- Простое выражение CASE
SELECT id, fio,
CASE post 
	WHEN 'm' THEN 'manager'
	WHEN 'd' THEN 'director'
	WHEN 'k' THEN 'konsultant'
	WHEN 'p' THEN 'prodavech'
	ELSE 'none'
END AS what 
FROM employee e 


-- оконная функция

SELECT id, fio, post, salary, MAX(salary) OVER (PARTITION BY post) AS max_salary,
						MIN(salary) OVER (PARTITION BY post) AS min_salary
FROM employee e 

-- GPOUP BY HAVING 

SELECT e.post, sum(m.costm) AS c
FROM employee e JOIN emp_med em ON e.id = em.id_emp
				JOIN medication m ON em.id_med = m.id 
GROUP BY post 
HAVING sum(m.costm) > 500



-- =================== Вариант 2 =====================
CREATE TABLE IF NOT EXISTS society
(
	id int PRIMARY KEY, 
	names varchar(50),
	yearb int, 
	what varchar(50),
	id_manager int
)

CREATE TABLE IF NOT EXISTS manager
(
	id int PRIMARY KEY,
	fio varchar(50),
	yearb varchar(50),
	experience int,
	phone varchar(15)
)

CREATE TABLE IF NOT EXISTS visitor
(
	id int PRIMARY KEY,
	fio varchar(50),
	yearb int,
	adress varchar(50),
	email varchar(50)
)

CREATE TABLE IF NOT EXISTS vs
(
	id_v int,
	id_s int,
	FOREIGN KEY (id_s) REFERENCES society(id),
	FOREIGN KEY (id_v) REFERENCES visitor(id)
)

INSERT INTO society
(
	id, 
	names,
	yearb, 
	what,
	id_manager
)
VALUES 
(1, 'Name1', 2000, 'what1', 1),
(2, 'Name2', 2001, 'what2', 5),
(3, 'Name3', 1999, 'what3', 6),
(4, 'Name4', 1998, 'what4', 4),
(5, 'Name5', 2002, 'what5', 9),
(6, 'Name6', 1987, 'what6', 10),
(7, 'Name7', 1988, 'what7', 3),
(8, 'Name8', 2000, 'what8', 7),
(9, 'Name9', 2003, 'what9', 4),
(10, 'Name10', 1989, 'what10', 5);

INSERT INTO manager
(
	id,
	fio,
	yearb,
	experience,
	phone
)
VALUES 
(1, 'FIO1', 1999, 2, '89766293939'),
(2, 'FIO2', 2000, 2, '89766293939'),
(3, 'FIO3', 1988, 8, '89724224939'),
(4, 'FIO4', 1994, 6, '89764242429'),
(5, 'FIO5', 1993, 5, '89444443939'),
(6, 'FIO6', 1992, 8, '89999999939'),
(7, 'FIO7', 1996, 9, '89762423939'),
(8, 'FIO8', 1999, 5, '82424242449'),
(9, 'FIO9', 1996, 8, '89766888839'),
(10, 'FIO10', 1987, 12, '89788888889');

INSERT INTO visitor
(
	id,
	fio,
	yearb,
	adress,
	email
)
values
(1, 'FIO1', 1988, 'Adress1', '1@bk.ru'),
(2, 'FIO2', 1983, 'Adress2', '2@bk.ru'),
(3, 'FIO3', 1998, 'Adress3', '3@bk.ru'),
(4, 'FIO4', 1977, 'Adress4', '4@bk.ru'),
(5, 'FIO5', 1999, 'Adress5', '5@bk.ru'),
(6, 'FIO6', 1998, 'Adress6', '6@bk.ru'),
(7, 'FIO7', 1966, 'Adress7', '7@bk.ru'),
(8, 'FIO8', 1998, 'Adress8', '8@bk.ru'),
(9, 'FIO9', 1980, 'Adress9', '9@bk.ru'),
(10, 'FIO10', 1988, 'Adress10', '10@bk.ru');


INSERT INTO vs
(
	id_v,
	id_s
)
VALUES 
(1,3),
(2,7),
(3,2),
(4,4),
(5,2),
(6,8),
(7,6),
(8,9),
(9,10),
(10,1);

alter table society
    add constraint FRKEY_MS foreign key (id_manager) references manager(id);


SELECT * FROM society 
SELECT * FROM visitor 
SELECT * FROM manager
SELECT * FROM vs


-- case


-- оконная функция
-- group by + HAVING 









