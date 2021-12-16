-- Создание базы данных
CREATE DATABASE RK2;

-- ===== Задание 1 ===== --
-- СОздание таблиц
CREATE TABLE IF NOT EXISTS vcircle
(
	id int PRIMARY KEY,
	cname varchar(50),
	yearbc int,
	what varchar(50), -- описание 
	id_manager int
);

CREATE TABLE IF NOT EXISTS visitor
(
	id int PRIMARY KEY,
	fiov varchar(50),
	yearbv int,
	adress varchar(50),
	email varchar(50)
);

CREATE TABLE IF NOT EXISTS manager
(
	id int PRIMARY KEY,
	fiom varchar(50),
	yearbm int,
	experience int,
	phone varchar(15)
);

CREATE TABLE IF NOT EXISTS vc
(
	id_c int,
	id_v int,
	FOREIGN KEY (id_v) REFERENCES visitor(id),
	FOREIGN KEY (id_c) REFERENCES vcircle(id)
);


-- Заполнение таблиц
INSERT INTO vcircle
(
	id,
	cname,
	yearbc,
	what,
	id_manager
)
VALUES 
(1, 'Name1', 1999, 'draw', 1),
(2, 'Name2', 1987, 'swim', 3),
(3, 'Name3', 1959, 'run', 6),
(4, 'Name4', 1979, 'draw', 8),
(5, 'Name5', 1998, 'run', 9),
(6, 'Name6', 2000, 'swim', 10),
(7, 'Name7', 2005, 'dance', 5),
(8, 'Name8', 1974, 'draw', 6),
(9, 'Name9', 1965, 'dance', 2),
(10, 'Name10', 1989, 'run', 4);


INSERT INTO manager
(
	id,
	fiom,
	yearbm,
	experience,
	phone
)
VALUES 
(1, 'FIO1', 1959, 34, '89467394930'),
(2, 'FIO2', 1967, 31, '89535359930'),
(3, 'FIO3', 1953, 43, '89463434340'),
(4, 'FIO4', 2000, 5, '89345678930'),
(5, 'FIO5', 1988, 10, '89497557881'),
(6, 'FIO6', 2001, 4, '81234567935'),
(7, 'FIO7', 2001, 3, '89467654336'),
(8, 'FIO8', 1963, 13, '894223449930'),
(9, 'FIO9', 1965, 7, '894544345530'),
(10, 'FIO10', 1989, 8, '89442424930');

INSERT INTO visitor
(
	id,
	fiov,
	yearbv,
	adress,
	email
)
VALUES 
(1, 'FIO1', 1989, 'Adress1', '1@bk.ru'),
(2, 'FIO2', 1999, 'Adress2', '2@bk.ru'),
(3, 'FIO3', 1998, 'Adress3', '3@bk.ru'),
(4, 'FIO4', 2000, 'Adress4', '4@bk.ru'),
(5, 'FIO5', 2003, 'Adress5', '5@bk.ru'),
(6, 'FIO6', 2001, 'Adress6', '6@bk.ru'),
(7, 'FIO7', 2001, 'Adress7', '7@bk.ru'),
(8, 'FIO8', 1999, 'Adress8', '8@bk.ru'),
(9, 'FIO9', 1997, 'Adress9', '9@bk.ru'),
(10, 'FIO10', 1989, 'Adress10', '10@bk.ru');


INSERT INTO vc
(
	id_c,
	id_v
)
VALUES 
(1, 4),
(3, 4),
(9, 5),
(10, 1),
(1, 2),
(9, 3),
(6, 6),
(2, 8),
(3, 9),
(4, 7);

-- добавление FK 
ALTER TABLE vcircle
	ADD CONSTRAINT FRKEY_VC FOREIGN KEY (id_manager) REFERENCES manager(id);

-- проверка, что все данные заполненны
SELECT * FROM manager;
SELECT * FROM vcircle;
SELECT * FROM visitor;
SELECT * FROM vc;

-- ===== Задание 2 ===== --
-- 1) Инструкцию SELECT, использующую простое выражение CASE
-- Выводит описание кружка в полной форме.
-- То есть в базе у нас run swim dance draw
-- Вывод идет понятный для человека
-- По типу Circle running 
-- Имелла в виду (Кружок бега, Кружок рисования)
SELECT id, cname,
	CASE what
		WHEN 'run' THEN 'Circle running'
		WHEN 'swim' THEN 'Circle swimming'
		WHEN 'draw' THEN 'Circle drawing'
		WHEN 'dance' THEN 'Circle dancind'
		ELSE 'none'
	END AS What_is_it
FROM vcircle;


-- 2) Инструкцию, использующую оконную функцию
-- Самый "молодой" и самый "старый" кружок в своем описании (то есть 
-- run swim dance draw)
SELECT id, cname, what, yearbc, MAX(yearbc) OVER (PARTITION BY what) AS young,
								MIN(yearbc) OVER (PARTITION BY what) AS older
FROM vcircle;

-- Самый молодой и самый старый посетитель кружка (по описанию)
SELECT c.cname, c.what, v.fiov, v.yearbv, 
	MAX(yearbv) OVER (PARTITION BY what) AS young,
	MIN(yearbv) OVER (PARTITION BY what) AS older
FROM vcircle c JOIN vc ON vc.id_c = c.id 
			   JOIN visitor v ON vc.id_v = v.id;


-- 3) Инструкцию SELECT, консолидирующую данные с помощью
-- предложения GROUP BY и предложения HAVING
-- Кружки, количество посетителей которых больше 2
SELECT c.what, count(vc.id_v) AS count_visitors
FROM vcircle c JOIN vc ON vc.id_c = c.id 
			   JOIN visitor v ON vc.id_v = v.id
GROUP BY what
HAVING count(vc.id_v) > 2;


-- ===== Задание 3 ===== -- 
--Создать хранимую процедуру с выходным параметром, которая выводит
--список имен и параметров всех скалярных SQL функций пользователя
--(функции типа 'FN') в текущей базе данных. Имена функций без параметров
--не выводить. Имена и список параметров должны выводиться в одну строку.
--Выходной параметр возвращает количество найденных функций.
--Созданную хранимую процедуру протестировать.
  
-- proargtypes -- Массив с типами данных аргументов функции. 
-- В нём учитываются только входные аргументы функции 
-- (включая аргументы INOUT и VARIADIC), так что он представляет 
-- сигнатуру вызова функции.

-- oidvectortypes -- возвращет готовый спсок аргументов через запятую.

-- из документации: Каждому параметру INOUT для процедуры 
-- должна соответствовать переменная в операторе CALL, 
-- и этой переменной по завершении процедуры будет присвоено 
-- возвращаемое процедурой значение. 

-- То есть вообще есть OUT, но в документации написано, что не поддерживается 
-- Поэтому я думала надо написать так (Вы на самом РК отвечали людям)
-- что тогда просто выводить, чтобы пользователь это увидел
-- именно это я и делаю, но при этом возвращаю этот параметр 
-- вызывающей стороне через INOUT)

-- Если INOUT нельзя было использовать (не решилась спрашиватьв конце рк)
-- То просто надо перенести count_ int в раздел DECLARE
-- и вызов процедуры производить как  CALL function_info();

CREATE OR REPLACE PROCEDURE function_info(count_ INOUT int)
AS $$
	DECLARE 
	row_ RECORD;
	cur_table CURSOR 
		FOR SELECT p.oid AS id, oidvectortypes(proargtypes) AS arg_type, 
			proargnames, proname AS namef, nspname, prokind 
		FROM pg_proc p INNER JOIN pg_catalog.pg_namespace s 
			ON s."oid" = p.pronamespace 
		WHERE s.nspname NOT IN ('pg_catalog', 'pg_toast', 'information_schema') -- это же не пользователя)
			AND prokind = 'f' -- тип функция (в postgres так)
			AND oidvectortypes(proargtypes) != '' -- у которых есть параметры
		ORDER BY s.nspname;
	BEGIN 
		OPEN cur_table;
		LOOP
			FETCH cur_table INTO row_;
			EXIT WHEN NOT FOUND;
			-- вывод в консоль
			RAISE NOTICE 'Name function: %; args: %; args_type: %',
							row_.namef, row_.proargnames, row_.arg_type;
			count_ = count_ + 1;
		END LOOP;
		RAISE NOTICE 'All count = %', count_;
	END;
$$ LANGUAGE PLPGSQL;

-- можно вызвать вот так (1)
CALL function_info(0);

-- можно вызвать вот так (2)
-- вывод "(out f)" - вывод вне функции
DO $$
DECLARE c int := 0;
BEGIN
	CALL function_info(c);
	RAISE NOTICE '(out f) All count = %', c; 
END;
$$;

---------------------------------------------------------------------
-- функции для тестирования 
-- функция без параметров
CREATE OR REPLACE FUNCTION f1()
RETURNS INT 
AS '
	select 5;
' LANGUAGE SQL;

-- функция с одним int
CREATE OR REPLACE FUNCTION f2(c int)
RETURNS INT 
AS '
	select 5 + c;
' LANGUAGE SQL;

-- функция с одним varchar
CREATE OR REPLACE FUNCTION f3(str varchar(10))
RETURNS varchar(10)
AS '
	select str;
' LANGUAGE SQL;

-- функция с двумя int 
CREATE OR REPLACE FUNCTION f4(v1 int, v2 int)
RETURNS INT 
AS '
	select v1 + v2;
' LANGUAGE SQL;

-- функция с двумя vachar 
CREATE OR REPLACE FUNCTION f5(str1 varchar(10), str2 varchar(10))
RETURNS varchar(10)
AS '
	select str1;
' LANGUAGE SQL;

---------------------------------------------------------------------
-- Вывод вызова
-- Не написал ничего про f1, так как у нее нет параметров 
-- Вывел нужную информацию про другие функции
-- Name function: f3; args: {str}; args_type: character varying
-- Name function: f2; args: {c}; args_type: integer
-- Name function: f4; args: {v1,v2}; args_type: integer, integer
-- Name function: f5; args: {str1,str2}; args_type: character varying, character varying
-- All count = 4
-- (out f) All count = 4
---------------------------------------------------------------------





EXPLAIN ANALYZE -- для определния времени дописывается ANALYZE, без него будет в воробушках
SELECT c.what, count(vc.id_v) AS count_visitors
FROM vcircle c JOIN vc ON vc.id_c = c.id 
			   JOIN visitor v ON vc.id_v = v.id
GROUP BY what
HAVING count(vc.id_v) > 2;







