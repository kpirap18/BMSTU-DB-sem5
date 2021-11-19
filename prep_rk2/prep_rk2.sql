CREATE DATABASE rk2_1;

-- СОЗДАНИЕ ТАБЛИЦ

-- Сотрудник
CREATE TABLE IF NOT EXISTS employee
(
	id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	fio VARCHAR(50) NOT NULL,
	yearb int NOT NULL,
	positione VARCHAR(50)
);

-- Виды валюты
CREATE TABLE IF NOT EXISTS typecurren
(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nametype VARCHAR(50)
);

-- Курс валюты
CREATE TABLE IF NOT EXISTS rate
(
	id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	id_curren int NOT NULL,
    sale INT NOT NULL, -- Продажа.
    purchase INT NOT NULL, -- Покупка.
    FOREIGN KEY (id_curren) REFERENCES typecurren(id)
);

-- Операция обмена
CREATE TABLE IF NOT EXISTS operation
(
	id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	id_employee int NOT NULL,
	id_curren int NOT NULL,
	summ int NOT NULL,
	FOREIGN KEY (id_curren) REFERENCES rate(id),
	FOREIGN KEY (id_employee) REFERENCES employee(id)
);

-- ЗАГРУЗКА ДАННЫХ
copy employee(fio, yearb, positione) from '/home/kpirap18/sem5/db1/prep_rk2/employee.csv' delimiter ',';
select * from employee

copy typecurren(nametype) from '/home/kpirap18/sem5/db1/prep_rk2/typecurren.csv' delimiter ',';
select * from typecurren

copy rate(id_curren, sale, purchase) from '/home/kpirap18/sem5/db1/prep_rk2/rate.csv' delimiter ',';
select * from rate

copy operation(id_employee, id_curren, summ) from '/home/kpirap18/sem5/db1/prep_rk2/operation.csv' delimiter ',';
select * from operation

-- ЗАГРУЗКА ДАННЫХ ЧЕРЕЗ INSERT
INSERT INTO rate (
	id_curren,
	sale,
	purchase
)
VALUES
	(1, 67, 87),
	(2, 78, 91),
	(3, 23, 51),
	(4, 80, 61),
	(5, 23, 19),
	(6, 77, 52);



-- ============================ ЗАДАНИЕ 2 - ЗАПРОСЫ ========================================
-- Инструкцию SELECT, использующую простое выражение CASE 
SELECT id, summ, 
	CASE summ 
		WHEN (
			SELECT MAX(summ)
			FROM operation 
			) THEN 'MAX'
		WHEN (
			SELECT MIN(summ)
			FROM operation 
			) THEN 'MIN'
			
		ELSE 'AVG'
	END AS what
FROM operation 
ORDER BY id 

-- Инструкцию, использующую оконную функцию
SELECT e.id, e.fio, positione, MIN(yearb) OVER(PARTITION BY positione) max_age
INTO newTable
FROM employee AS e

SELECT * FROM newtable 

DROP TABLE newtable 

-- Инструкцию SELECT, консолидирующую данные с помощью 
-- предложения GROUP BY и предложения HAVING 
SELECT r.id_curren
FROM rate r JOIN typecurren t ON r.id_curren = t.id 
GROUP BY id_curren
HAVING count(id_curren) >= 2


-- ================================= ЗАДАНИЕ 3 ===================================
SELECT *
FROM pg_index
JOIN pg_class ON pg_index.indrelid=pg_class.oid
WHERE relname='employee';

SELECT * FROM pg_class
SELECT * FROM rk2_2.public.

SELECT * FROM pg_catalog.pg_indexes 
WHERE tablename LIKE 'em%'

SELECT * FROM pg_catalog.pg_database 

SELECT *
FROM information_schema."tables" t 

SELECT *
FROM rk2_2.public.employee e 

﻿-- === OK Создать хранимую процедуру с входным параметром – имя таблицы,
-- которая выводит сведения об индексах указанной таблицы в текущей базе
-- данных. Созданную хранимую процедуру протестировать.
CREATE OR REPLACE PROCEDURE get_indexes_info(tblname VARCHAR)
AS $$
DECLARE
    rec RECORD;
    cur CURSOR FOR
        SELECT *
        FROM pg_indexes pind 
        WHERE pind.schemaname = 'public' AND pind.tablename = tblname
        ORDER BY pind.indexname;
BEGIN
    OPEN cur;
    FETCH cur INTO rec;
    RAISE NOTICE 'TABLE: %, INDEX: %s, DEFINITION: %', tblname, rec.indexname, rec.indexdef;
    RAISE NOTICE '%', rec;
    CLOSE cur;
END;
$$ LANGUAGE PLPGSQL;

CALL get_indexes_info('rate');


SELECT *
FROM pg_catalog.pg_indexes
WHERE tablename = 'companies';

SELECT *
FROM information_schema."tables" t 

create OR REPLACE procedure get_index(table_name varchar(30))
AS $$
	declare
		row record;
		cur cursor
		for select *
	    from pg_indexes 
	    where tablename = table_name;

	begin
		open cur;
		loop
			fetch cur into row;
			exit when not found;

			raise notice '%', ROW;
		end loop;
		close cur;
	end;
$$ language plpgsql;

call get_index('rate');

-- ========================================================================= 
-- === NOT (не понятно как использовать имя базы данных)
-- Создать хранимую процедуру с двумя входными параметрами – имя базы данных 
-- и имя таблицы, которая выводит сведения об индексах указанной таблицы в 
-- указанной базе данных. Созданную хранимую процедуру протестировать.

CREATE OR REPLACE PROCEDURE index_info
(
    db_name_in VARCHAR(32),
    table_name_in VARCHAR(32)
)
AS '
DECLARE
    elem RECORD;
BEGIN
    FOR elem in
        SELECT *
        FROM pg_indexes
        WHERE tablename = table_name_in
        LOOP
            RAISE NOTICE ''elem: %'', elem;
        END LOOP;
END;
' LANGUAGE plpgsql;

CALL index_info('rk_2_1', 'rate');

SELECT *
FROM pg_index JOIN pg_class ON pg_index.indrelid=pg_class.oid
WHERE relname='rate';

SELECT *
FROM pg_class

SELECT * 
FROM information_schema."tables" t 

SELECT *
FROM pg_catalog.pg_database pd 

-- ===============================================================================
-- === OK Создать хранимую процедуру без параметров, в которой для экземпляра SQL Server 
-- создаются резервные копии всех пользовательских баз данных. Имя файла резервной 
-- копии должно состоять из имени базы данных и даты создания резервной копии, разделенных 
-- символом нижнего подчеркивания. Дата создания резервной копии должна быть представлена 
-- в формате YYYYDDMM. Созданную хранимую процедуру протестировать.

-- datistemplate может быть установлен, чтобы указать, что база данных предназначена 
-- в качестве шаблона для CREATE DATABASE. Если этот флаг установлен, 
-- база данных может быть клонирована любым пользователем с привилегиями CREATEDB; 
-- если он не установлен, клонироват ....
-- владелец базы данных. 

-- pg_terminate_backend передают сигналы (SIGINT и SIGTERM, соответственно) серверному 
-- процессу с заданным кодом PID. Код активного процесса можно получить из 
-- столбца pid представления pg_stat_activity или просмотрев на сервере
-- процессы с именем postgres (используя ps в Unix или Диспетчер задач в Windows). 
-- Роль пользователя активного процесса можно узнать в столбце usename 
-- представления pg_stat_activity.
CREATE EXTENSION dblink;
CREATE OR REPLACE PROCEDURE backups()
AS
$$
DECLARE
	rec RECORD;
	buf RECORD;
	new_name varchar(50);
	last_name varchar(50);
	_user TEXT := 'postgres';
  	_password TEXT := '1830';
BEGIN
	FOR rec IN SELECT datname FROM pg_database WHERE datistemplate = false LOOP
		SELECT EXTRACT(YEAR FROM now())::varchar(20) || EXTRACT(DAY FROM now()) || EXTRACT(MONTH FROM now()) INTO new_name;
		new_name = rec.datname::varchar(20) || '_' || new_name;
		last_name = rec.datname;
		RAISE NOTICE 'new_name =  %', new_name;
		RAISE NOTICE 'datname =  %', last_name;
		
		SELECT pg_terminate_backend(pg_stat_activity.pid) 
		FROM pg_stat_activity 
		WHERE pg_stat_activity.datname = last_name 
		AND pid <> pg_backend_pid() INTO buf;
		
		--CREATE DATABASE new_name WITH TEMPLATE last_name;
		--PERFORM dblink_connect('host=localhost user=' || _user || ' password=' || _password || ' dbname=' || current_database());
		PERFORM dblink_exec('host=localhost user=' || _user || ' password=' || _password || ' dbname=' || last_name   -- current db
                     , 'CREATE DATABASE ' || new_name);
		
	END LOOP;
END;
$$ LANGUAGE plpgsql;

-- dblink_exec — выполняет команду в удалённой базе данных
CALL backups();


-- еще варинант
-- но ошибка  CREATE DATABASE нельзя выполнять внутри функции
CREATE OR REPLACE PROCEDURE backup2()
AS $$
DECLARE
    elem varchar;
    reserve_name varchar;
BEGIN
    FOR elem IN
        SELECT datname FROM pg_database
    LOOP
        SELECT elem || '_' || EXTRACT(year FROM current_date)::varchar ||
        EXTRACT(month FROM current_date)::varchar || EXTRACT(day FROM current_date)::varchar
        INTO reserve_name;
        RAISE NOTICE 'making copy of % as %', elem, reserve_name;
        EXECUTE 'CREATE DATABASE ' || reserve_name || ' WITH TEMPLATE ' || elem;
       
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

CALL backup2();

-- =================================================================================================
-- === OK NOT Создать хранимую процедуру с выходным параметром, которая уничтожает 
-- все SQL DDL триггеры (триггеры типа 'TR') в текущей базе данных. Выходной
--  параметр возвращает количество уничтоженных триггеров. Созданную хранимую 
-- процедуру протестировать. 
SELECT * FROM information_schema.triggers t 

SELECT * FROM pg_catalog.pg_trigger pt 

SELECT * FROM pg_catalog.pg_event_trigger pet 

CREATE OR REPLACE FUNCTION update_trigger()
RETURNS TRIGGER 
AS '
BEGIN
	RAISE NOTICE ''New =  %'', new;
    RAISE NOTICE ''Old =  %'', old; RAISE NOTICE ''New =  %'', new;
	
	RETURN new;
END;
' LANGUAGE plpgsql;

CREATE TRIGGER update_my
AFTER UPDATE ON rate
FOR EACH ROW 
EXECUTE PROCEDURE update_trigger();

-- по факту ЭТО УДАЛИТЬ DDL триггеры
-- НОООО в посгрессе нет DDL триггеров
-- там только DML.....
-- ясен пень, что ничего не удалит
CREATE OR REPLACE PROCEDURE drop_trigger(count_ INOUT int)  
AS 
$$
DECLARE 
    tmp_trigger_name record;
    cursor_trigger_name CURSOR FOR
	    SELECT trigger_name, event_object_table 
	    FROM information_schema.triggers;
	    --WHERE event_manipulation = 'CREATE' OR 
	      --    event_manipulation = 'ALTER' OR 
	        --  event_manipulation = 'DROP';
BEGIN  
    OPEN cursor_trigger_name;
    LOOP 
    	
        FETCH cursor_trigger_name INTO tmp_trigger_name;
        EXIT WHEN NOT FOUND;
   		count_ = count_ + 1;
        EXECUTE 'DROP TRIGGER ' || tmp_trigger_name.trigger_name || ' ON ' || tmp_trigger_name.event_object_table;
        RAISE NOTICE 'Trigger "%" was deleted!', tmp_trigger_name.trigger_name;
    END LOOP;

    CLOSE cursor_trigger_name;
END;
$$    LANGUAGE plpgsql;

DROP TRIGGER update_my ON rate;
CALL drop_trigger(0); 

-- Вроде вроде это вот тригерры ddl
SELECT * FROM pg_catalog.pg_event_trigger 

CREATE OR REPLACE FUNCTION snitch() RETURNS event_trigger AS $$
BEGIN
    RAISE NOTICE 'Произошло событие: % %', tg_event, tg_tag;
END;
$$ LANGUAGE plpgsql;

CREATE EVENT TRIGGER snitch ON ddl_command_start 
EXECUTE PROCEDURE snitch();

CREATE OR REPLACE PROCEDURE drop_trigger(count_ INOUT int)  
AS 
$$
DECLARE 
    tmp_trigger_name record;
    cursor_trigger_name CURSOR FOR
	    SELECT evtname, evtevent 
	    FROM pg_catalog.pg_event_trigger 
BEGIN  
    OPEN cursor_trigger_name;
    LOOP 
    	
        FETCH cursor_trigger_name INTO tmp_trigger_name;
        EXIT WHEN NOT FOUND;
   		count_ = count_ + 1;
        EXECUTE 'DROP TRIGGER ' || tmp_trigger_name.trigger_name || ' ON ' || tmp_trigger_name.event_object_table;
        RAISE NOTICE 'Trigger "%" was deleted!', tmp_trigger_name.trigger_name;
    END LOOP;

    CLOSE cursor_trigger_name;
END;
$$    LANGUAGE plpgsql;

DROP TRIGGER update_my ON rate;
CALL drop_trigger(0); 


-- ============================================================================================
-- === OK Создать хранимую процедуру, которая, не уничтожая базу данных, уничтожает 
-- все те таблицы текущей базы данных в схеме 'dbo', имена которых начинаются с 
-- фразы 'TableName'. Созданную хранимую процедуру протестировать. 

-- Это вот с параметром
CREATE TABLE IF NOT EXISTS TableName1 (
    a int
);

CREATE TABLE IF NOT EXISTS TableName2 (
    a int
);

CREATE TABLE IF NOT EXISTS TableName3 (
    a int
);

CREATE TABLE IF NOT EXISTS TableName4 (
    a int
);
CREATE OR REPLACE PROCEDURE rm_all_like(tablename varchar)
AS $$
DECLARE
    elem varchar = '';
BEGIN
    FOR elem IN
        EXECUTE 'SELECT table_name FROM information_schema.tables
        WHERE table_type=''BASE TABLE'' AND table_name LIKE ''' || tablename || '%'''
    LOOP
        EXECUTE 'DROP TABLE ' || elem;
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

call rm_all_like('tablename');
----------------------------------------------------------------------------------
-- это без параметров (мне нравится больше)
CREATE OR REPLACE PROCEDURE drop_by_interval()  
AS 
$$
DECLARE 
    tmp_table_name text;
    cursor_table_name CURSOR FOR
    SELECT tablename
    FROM pg_tables
    WHERE schemaname = 'public';
BEGIN  
    OPEN cursor_table_name;
    LOOP
        FETCH cursor_table_name INTO tmp_table_name;
        EXIT WHEN NOT FOUND;

        IF tmp_table_name LIKE 'tablename%' THEN
            EXECUTE 'DROP TABLE IF EXISTS ' || tmp_table_name || ';'; 
            RAISE NOTICE 'Table "%" was deleted!', tmp_table_name;
        END IF;
    END LOOP;

    CLOSE cursor_table_name;
END;
$$    LANGUAGE plpgsql;

CALL drop_by_interval(); 
------------------------------------------------------------------------------
-- чисто с одним курсором
create table TableNameTemp1 ( id int );
create table TableNameTemp2 ( id int );
create table TableNameTemp3 ( id int );

select table_name
from information_schema.tables
where table_schema = 'public' and
      table_name like 'tablename%';

create or replace procedure DeleteTableNames() as
$$
    declare
        tbl_cursor cursor for (
            select 'drop table ' || table_name || ';' as cmd
            from (
                select table_name
                from information_schema.tables
                where table_schema = 'public' and
                      table_name like 'tablename%'
            ) x
        );
        rec record;
    begin
        open tbl_cursor;
        loop
            fetch next from tbl_cursor into rec;

            if rec.cmd is not null then
                raise notice '%', rec.cmd;
                execute rec.cmd;
            end if;

            exit when not found;
        end loop;
        close tbl_cursor;
    end
$$
language plpgsql;

call DeleteTableNames();

select *
from information_schema.routines
where table_schema = 'public' and
      table_name like 'tablename%';


-- ==============================================================================
-- === NOT Создать хранимую процедуру с выходным параметром, которая уничтожает 
-- все представления в текущей базе данных, которые не были зашифрованы. 
-- Выходной параметр возвращает количество уничтоженных представлений. 
-- Созданную хранимую процедуру протестировать. 
     
SELECT * FROM pg_catalog.pg_matviews pm 
SELECT * FROM pg_catalog.pg_views pv 

SELECT * FROM information_schema."views" v 

-- ========================================================================================
-- === OK (update) (только процедра, а не функция) Хранимую процедуру доступа к метаданным  (название таблицы и размер)
-- Информационная схема состоит из набора представлений, содержащих информацию 
-- об объектах, определенных в текущей базе данных.
-- pg_relation_size принимает OID или имя таблицы, индекса или TOAST-таблицы 
-- и возвращает размер одного слоя этого отношения (в байтах). (Заметьте, что в
-- большинстве случаев удобнее использовать более высокоуровневые функции 
-- pg_total_relation_size и pg_table_size, которые суммируют размер всех слоёв.)
 --С одним аргументом она возвращает размер основного слоя для данных заданного отношения.
-- desc - сортировка в порядке убывания
     
select table_name, count(*) as size
into my_tables
from information_schema.tables
where table_schema = 'public'
group by table_name;

DROP TABLE my_tables;
select * from my_tables;

SELECT * from information_schema.TABLES


create or replace PROCEDURE table_size()
as
$$
declare
    cur cursor
    for select table_name, size
    from (
        select table_name,
        pg_relation_size(cast(table_name as varchar)) as size
        from information_schema.tables
        where table_schema = 'public'
        order by size desc
    ) AS tmp;
         row record;
begin
    open cur;
    loop
        fetch cur into row;
        exit when not found;
        raise notice '{table : %} {size : %}', row.table_name, row.size;
        --update my_tables
        --set size = row.size
        --where my_tables.table_name = row.table_name;
    end loop;
    close cur;
end
$$ language plpgsql;

select * from  table_size();
CALL table_size();
select * from my_tables;

SELECT * 
FROM pg_class p JOIN information_schema.TABLEs i ON p.relname = i.table_name 

SELECT nspname || '.' || relname AS "relation",
    pg_size_pretty(pg_relation_size(C.oid)) AS "size"
  FROM pg_class C
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
  ORDER BY pg_relation_size(C.oid) DESC;
 
 
 
-- ===================================================================================================
-- === NOT Создать хранимую процедуру с выходным параметром, которая выводит
-- список имен и параметров всех скалярных SQL функций пользователя
-- (функции типа 'FN') в текущей базе данных. Имена функций без параметров
-- не выводить. Имена и список параметров должны выводиться в одну строку.
-- Выходной параметр возвращает количество найденных функций.
-- Созданную хранимую процедуру протестировать. 

-- в pg_type названия типов, можно как-то сделать чтобы выводились имена типов, но как....
 CREATE OR REPLACE PROCEDURE info_function
(
    count_ INOUT int
)
AS '
DECLARE
	i int,
    elem RECORD;
BEGIN
    FOR elem in
        SELECT proname, prokind, proargnames, proallargtypes, pronargs
        FROM pg_proc
        WHERE prokind = ''f'' and pronargs > 0
    LOOP
		count_ = count_ + 1;
        RAISE NOTICE ''Name: %, count: %, name_param: %, type_param: %'', 
						elem.proname, elem.pronargs, elem.proargnames, 
						elem.proallargtypes;
    END LOOP;
END;
' LANGUAGE plpgsql;

CALL info_function(0);

SELECT *
FROM pg_proc
SELECT *
FROM information_schema.routines
WHERE specific_schema = 'public'

CREATE OR REPLACE PROCEDURE MyTables13 
(
res INOUT INT
)
AS  '
BEGIN  
--SELECT * FROM sys.all_objects
--where type = ''FN''
SELECT res = COUNT(*) FROM sys.all_objects
where type = ''FN'';
RAISE NOTICE ''elem = %, index = %'', res, index_;
END;
' LANGUAGE plpgsql;


CALL mytables13(0);

-- Получаем информацию о всех функциях
select *
from pg_proc
where pronargs > 0; -- кол-во принимаемых аргументов

-- Хранимая процедура доступа к метаданным
-- Вывести имя функции и типы принимаемых значений
create or replace procedure show_functions() as
$$
declare 
	cur cursor
	for select proname, proargtypes
	from (
		select proname, pronargs, prorettype, proargtypes
		from pg_proc
		where pronargs > 0
	) AS tmp;
	row record;
begin
	open cur;
	loop
		fetch cur into row;
		exit when not found;
		raise notice '{func_name : %} {args : %}', row.proname, row.proargtypes;
	end loop;
	close cur;
end
$$ language plpgsql;

call show_functions();


-- =================================================================================================
-- === OK\NOT Создать хранимую процедуру с входным параметром – "имя таблицы",
-- которая удаляет дубликаты записей из указанной таблицы в текущей
-- базе данных. Созданную процедуру протестировать.
CREATE TABLE IF NOT EXISTS test_duplicates
(
    id INT,
    name VARCHAR(32)
);
insert into test_duplicates(id, name) values
(1, 'f'),
(2, 'fdf'),
(3, 'df'),
(4, 'd'),
(1, 'f'),
(2, 'fdf'),
(3, 'df'),
(4, 'd'),
(1, 'f'),
(2, 'fdf'),
(38, 'df'),
(4, 'd'),
(1, 'f'),
(2, 'fdf'),
(3, 'df'),
(11, 'ff'),
(22, 'ffdf'),
(31, 'dff'),
(41, 'dd');

CREATE OR REPLACE PROCEDURE remove_duplicates
(
    table_name_in VARCHAR(32)
)
AS '
BEGIN
    EXECUTE ''
        create table tab_temp as
        select distinct *
        from '' || table_name_in;
    EXECUTE ''
        DROP TABLE '' || table_name_in;
    EXECUTE ''
    ALTER TABLE tab_temp rename to '' || table_name_in;
END;
' LANGUAGE plpgsql;

CALL remove_duplicates('test_duplicates');

SELECT * FROM test_duplicates;

DROP TABLE test_duplicates;
select table_name, column_name
from information_schema.columns
where table_name = 'test_duplicates';

-------------- удаляет по id (то есть если есть {1, уу} и {1, y} удалит все)
create or replace procedure rem_duplicates(in t_name text)
language plpgsql
as
$$
declare
    query text;
    col text;
    column_names text[];
begin
    query = 'delete from ' || t_name || ' where id in (' ||
                'select ' || t_name || '.id ' ||
                'from ' || t_name ||
                ' join (select id, row_number() over (partition by ';
    for col in select column_name from information_schema.columns where information_schema.columns.table_name=t_name loop
        query = query || col || ',';
    end loop;
    query = trim(trailing ',' from query);
    query = query || ') as rn from ' || t_name || ') as t on t.id = ' || t_name || '.id' ||
            ' where rn > 1)';
    raise notice '%', query;
    execute query;
end
$$;

CALL rem_duplicates('test_duplicates');


select *
from information_schema.columns 
where information_schema.columns.table_name='test_duplicates'

------ еще вариант
drop table if exists tmp;
create table if not exists tmp (a integer, b integer, c varchar(5));
insert into tmp values (1, 1, '2'), (2, 3, '3'), (1, 1, '2'), (2, 3, '3'), (1, 1, '2');
select * from tmp;

create or replace procedure del_duplicates_a(table_in varchar)
as
$$
begin
	EXECUTE 'delete from '
        || quote_ident(table_in)
        || ' where ctid not in (select min(ctid) from '
        || quote_ident(table_in)
        || ' group by '
        || quote_ident(table_in)
        || '.*)';
end;
$$ language plpgsql;

call del_duplicates_a('tmp');

select * from tmp;


-- ===============================================================================================
-- === OK Создать хранимую процедуру с входным параметром – имя базы данных,
-- которая выводит имена ограничений CHECK и выражения SQL, которыми
-- определяются эти ограничения CHECK, в тексте которых на языке SQL
-- встречается предикат 'LIKE'. Созданную хранимую процедуру
-- протестировать.

---------------- что тут можно сказать, начиная с 12 версии столбика consrc не существует и как теперь быть - хз
create extension dblink;
create or replace procedure get_like_constraints(in data_base_name text)
    language plpgsql
as
$$
declare
    constraint_rec record;
begin
    for constraint_rec in select *
                          from dblink(concat('dbname=', data_base_name, ' options=-csearch_path='),
                                      'select conname, consrc
                                      from pg_constraint
                                      where contype = ''c''
                                          and (lower(consrc) like ''% like %'' or consrc like ''% ~~ %'')')
                                   as t1(con_name varchar, con_src varchar)
        loop
            raise info 'Name: %, src: %', constraint_rec.con_name, constraint_rec.con_src;
        end loop;
end
$$;

create table customer(
	customer_id serial not null primary key,
	customer_name varchar(30),
	adress varchar(30) unique,
	email varchar(30) unique
);

insert into customer(customer_name, adress, email)
values ('AAAAA', 'ASdd', 'AAAAA@mail.ru');

-- Тестируем
-- Добавили ограничение с like
alter table customer
    add constraint a_in_name check ( customer_name like '%A%');
-- Вызвали процедуру
DO
$$
    begin
        call get_like_constraints('rk2_1');
    end;
$$;


SELECT * 
FROM pg_constraint


--------почему то like это ~~, и вообще работает странно
create or replace procedure table_info(bname varchar(10))
    language plpgsql
as
$$
declare
    c record;
begin
    select constraint_catalog, constraint_schema, constraint_name, check_clause into c 
    from information_schema.check_constraints cc JOIN pg_catalog.pg_constraint pp ON pp.conname = cc.constraint_name 
	where pp.contype = 'c' and cc.check_clause like '%~~%' and cc.constraint_catalog = bname;
    raise notice 'Catalog: %, schema: %, name: %, clause: %', c.constraint_catalog, c.constraint_schema, c.constraint_name, c.check_clause;
end
$$;

SELECT * 
FROM information_schema.check_constraints 

call table_info('rk2_1');


select *
from pg_catalog.pg_constraint pc 

select *
from pg_catalog.pg_constraint pp JOIN information_schema.check_constraints cc ON pp.conname = cc.constraint_name 
where pp.contype = 'c' and (cc.check_clause like '%~~%') and cc.constraint_catalog = 'rk2_1';


-- ==============================================================================================
-- === OK, но в идеале доделать
-- Вывести имя функции и типы принимаемых значений
-- вывеси, то выводит, НО типы аргументов -- это тупо цифры какие-то
create or replace procedure show_functions() as
'
declare 
	cur cursor
	for select proname, proargtypes
	from (
		select proname, pronargs, prorettype, proargtypes
		from pg_proc 
		where pronargs > 0 
	) AS tmp;
	row record;
begin
	open cur;
	loop
		fetch cur into row;
		exit when not found;
		raise notice ''{func_name : %} {args : %}'', row.proname, row.proargtypes;
	end loop;
	close cur;
END;
'language plpgsql;

SELECT * FROM pg_proc where pronargs > 0 
SELECT * FROM pg_type

call show_functions();


-- =======================================================================================================
-- === OK Создать хранимую процедуру с входным параметром, которая выводит
-- имена и описания типа объектов (только хранимых процедур и скалярных
-- функций), в тексте которых на языке SQL встречается строка, задаваемая
-- параметром процедуры. Созданную хранимую процедуру протестировать. 
select * from information_schema.routines;

create procedure Task3z(str varchar(20))
as'
DECLARE
    elem RECORD;
BEGIN
    FOR elem in
    select routine_name, routine_type
    from information_schema.routines
    where (routine_definition like ''%'' || str || ''%'')
    LOOP
        RAISE NOTICE ''elem: %'', elem;
    END LOOP;
END;
' LANGUAGE plpgsql;

call Task3z('LOOP');
drop procedure Task3(str varchar(20));

-------------------------------------------
select * from information_schema.routines;

create procedure Task3(str varchar(20))
language sql
as
$$
    select routine_name, routine_type into table tbl
    from information_schema.routines
    where (routine_definition like '%' || str || '%');
$$;

call Task3('RECORD');
drop procedure Task3(str varchar(20));
drop table tbl;

select * from tbl;
----------------------
-- как мне кажется - это лучше
CREATE OR REPLACE PROCEDURE info_routine
(
    str VARCHAR(32)
)
AS '
DECLARE
    elem RECORD;
BEGIN
    FOR elem in
        SELECT routine_name, routine_type
        FROM information_schema.routines
             -- Чтобы были наши схемы.
        WHERE specific_schema = ''public''
        AND (routine_type = ''PROCEDURE''
        OR (routine_type = ''FUNCTION'' AND data_type != ''record''))
        AND routine_definition LIKE CONCAT(''%'', str, ''%'')
    LOOP
        RAISE NOTICE ''elem: %'', elem;
    END LOOP;
END;
' LANGUAGE plpgsql;

CALL info_routine('SELECT');

select data_type , routine_definition
FROM information_schema.routines
WHERE specific_schema = 'public';

CREATE OR REPLACE FUNCTION func_int()
RETURNS INT AS '
    SELECT  5
' LANGUAGE sql;


-- ================================================================================================
-- === OK (вроде так) Создать хранимую процедуру без параметров, которая осуществляет поиск
-- ключевого слова 'EXEC' в тексте хранимых процедур в текущей базе
-- данных. Хранимая процедура выводит инструкцию 'EXEC', которая
-- выполняет хранимую процедуру или скалярную пользовательскую
-- функцию. Созданную хранимую процедуру протестировать. 
CREATE OR REPLACE PROCEDURE info_routine_exec
(
    str VARCHAR(32)
)
AS '
DECLARE
    elem RECORD;
BEGIN
    FOR elem in
        SELECT routine_name, routine_type
        FROM information_schema.routines
             -- Чтобы были наши схемы.
        WHERE specific_schema = ''public''
        AND routine_type = ''PROCEDURE''
        AND routine_definition LIKE CONCAT(''%'', str, ''%'')
    LOOP
        RAISE NOTICE ''elem: %'', elem;
    END LOOP;
END;
' LANGUAGE plpgsql;

CALL info_routine_exec('EXECUTE');

-- =============================================================================================
-- === OK Создать хранимую процедуру с выходным параметром, которая уничтожает
-- все представления в текущей базе данных. Выходной параметр возвращает
-- количество уничтоженных представлений. Созданную хранимую процедуру
-- протестировать. 

SELECT * FROM pg_catalog.pg_views 
SELECT * FROM information_schema."views" v 

CREATE VIEW ff AS 
SELECT * -- INTO tours_buf
FROM public.department d ;
SELECT * FROM ff;

CREATE OR REPLACE PROCEDURE drop_view(count_ INOUT int)  
AS 
$$
DECLARE 
    tmp_view_name record;
    cursor_view_name CURSOR FOR
	    SELECT viewname 
	    FROM pg_catalog.pg_views
	    -- ЧТОбы не удалить важное!!!!
	    WHERE schemaname <> 'pg_catalog' AND schemaname <> 'information_schema';
BEGIN  
    OPEN cursor_view_name;
    LOOP 
        FETCH cursor_view_name INTO tmp_view_name;
        EXIT WHEN NOT FOUND;
   		count_ = count_ + 1;
        EXECUTE 'DROP VIEW ' || tmp_view_name.viewname;
        RAISE NOTICE 'View "%" was deleted!', tmp_view_name.viewname;
    END LOOP;

    CLOSE cursor_view_name;
END;
$$    LANGUAGE plpgsql;

CALL drop_view(0) 

-- ==========================================================================================
-- === OK, доделать как принимаемый парамент имя таблицы 
-- Вывод всех столбцов из таблицы 
CREATE OR REPLACE PROCEDURE proc_name()
AS '
DECLARE
    elem RECORD;
BEGIN
    FOR elem in
        SELECT COLUMN_NAME
        FROM information_schema.columns
        WHERE table_name = ''employee''
    LOOP
        RAISE NOTICE ''elem: %'', elem;
    END LOOP;
END;
'LANGUAGE plpgsql;

CALL proc_name();


-- ===================================================================================================
-- === OK , но имена параметров....
-- Хранимая процедура, которая выводит в консоль имена пользовательских функций с хотя бы одним параметром,
-- имена параметров, типы параметров функций.
--
-- Насколько мне известно в postgres процедуры не могут возвращать никаких значений,
-- поэтому я вывожу в консоль количество функций.
create or replace procedure functions_info(count int) as
$$
    declare cur cursor
        for select p.oid as id, oidvectortypes(proargtypes) as arg_type, proargnames, proname as name, nspname, prokind
            from pg_proc p
            inner join pg_namespace s
            on p.pronamespace = s.oid
            where s.nspname not in ('pg_catalog', 'pg_toast', 'information_schema')
            and prokind = 'f'
            and oidvectortypes(proargtypes) != ''
            order by s.nspname;
        row record;
    begin
        open cur;
        loop
            fetch cur into row;
            exit when not found;
            raise notice '{f_name : %} {args : %} {args_type : %}', row.name, row.proargnames, row.arg_type;
            count = count + 1;
        end loop;
        raise notice 'function amount : %', count;
        close cur;
    end;
$$ language plpgsql;

call functions_info(0);

SELECT * FROM pg_proc
SELECT * FROM pg_catalog.pg_user pu 


-- ======================================================================================
-- === NOT Создать хранимую процедуру с входным параметром, которая выводит
-- имена хранимых процедур, созданных с параметром WITH RECOMPILE, в
-- тексте которых на языке SQL встречается строка, задаваемая параметром
-- процедуры. Созданную хранимую процедуру протестировать. 

CREATE OR REPLACE PROCEDURE info_routine
(
    str VARCHAR(32)
)
AS '
DECLARE
    elem RECORD;
BEGIN
    FOR elem in
        SELECT routine_name, routine_type
        FROM information_schema.routines
             -- Чтобы были наши схемы.
        WHERE specific_schema = ''public''
        AND (routine_type = ''PROCEDURE''
        OR (routine_type = ''FUNCTION'' AND data_type != ''record''))
        AND routine_definition LIKE CONCAT(''%'', str, ''%'')
    LOOP
        RAISE NOTICE ''elem: %'', elem;
    END LOOP;
END;
' LANGUAGE plpgsql;

CALL info_routine('SELECT');

select *
FROM information_schema.routines
WHERE specific_schema = 'public';

CREATE OR REPLACE FUNCTION func_int()
RETURNS INT AS '
    SELECT  5
' LANGUAGE sql;


-- ===========================================================================================
-- === NOT Создать хранимую процедуру без параметров, которая в текущей базе
--данных обновляет все статистики для таблиц в схеме 'dbo'. Созданную
--хранимую процедуру протестировать.
--help: Чтобы обновить статистику оптимизации запросов для таблицы в
--указанной базе данных, необходимо
--воспользоваться инструкцией UPDATE STATISTICS, которая в простейшем
--случае имеет следующий формат: 

SELECT * FROM pg_catalog.pg_stat_activity psa 

select specific_catalog, specific_schema, specific_name, routine_definition
from information_schema.ROUTINES
WHERE specific_schema = 'public'

SELECT * FROM pg_stats WHERE tablename = 'tbl'
UPDATE pg_stats



EXECUTE 'SQL CONNECT TO "rk2_2"';

EXECUTE 'select * from rate'











