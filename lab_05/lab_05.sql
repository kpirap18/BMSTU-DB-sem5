--1. Из таблиц базы данных, созданной в первой лабораторной работе, извлечь
--данные в XML (MSSQL) или JSON(Oracle, Postgres). Для выгрузки в XML
--проверить все режимы конструкции FOR XML
SELECT row_to_json(c) result FROM packages.categoryhotel c;
SELECT row_to_json(c1) result FROM packages.companies c1;
SELECT row_to_json(h) result FROM packages.hotels h;



--2. Выполнить загрузку и сохранение XML или JSON файла в таблицу.
--Созданная таблица после всех манипуляций должна соответствовать таблице
--базы данных, созданной в первой лабораторной работе.

-- Копия таблицы
CREATE TABLE IF NOT EXISTS Companies_copy(
    CompanyId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	NameCompany VARCHAR(100) NOT NULL,
	City VARCHAR(100) NOT NULL,
	AddressCom VARCHAR(100) NOT NULL,
	Phone VARCHAR(15) NOT NULL,
    Fax VARCHAR(15) NULL,
    Email VARCHAR(100) NULL,
    Director VARCHAR(100) NOT NULL
);

-- Копирование
-- надо через терминал (linux) сделать комнду chmod uog+w <имя файла json>
COPY
(
	SELECT row_to_json(c) RESULT FROM packages.companies c 
)
TO '/home/kpirap18/sem5/db1/lab_05/companies.json';


-- Файл в таблицу БД
CREATE TABLE IF NOT EXISTS companies_import(doc json);

COPY companies_import FROM '/home/kpirap18/sem5/db1/lab_05/companies.json';

SELECT * FROM companies_import;

-- потом все в таблицу 
INSERT INTO Companies_copy (NameCompany, City, AddressCom, Phone, Fax, Email, Director)
SELECT doc->>'namecompany', doc->>'city', doc->>'addresscom', doc->>'phone',
	   doc->>'fax', doc->>'email', doc->>'director' FROM companies_import;

SELECT * FROM companies_copy;


--3. Создать таблицу, в которой будет атрибут(-ы) с типом XML или JSON, или
--добавить атрибут с типом XML или JSON к уже существующей таблице.
--Заполнить атрибут правдоподобными данными с помощью команд INSERT
--или UPDATE.
CREATE TABLE IF NOT EXISTS companies_json
(
	DATA json
);

INSERT INTO companies_json
SELECT * FROM json_object('{companyid, namecompany, city, addresscom, phone, fax, email, director}',
						  '{1023, "AAAAAAAAA", "KKK", "HHH", 89765434567, 9998765432, "gyg@bk.ru", "Dirkjhkj"}');

SELECT * FROM companies_json;

CREATE TABLE IF NOT EXISTS json_table
(
	id serial PRIMARY KEY,
	name varchar(40) NOT NULL,
	DATA json
);

insert into json_table(name, data) values 
    ('Ira', '{"age": 22, "group": "IU7-52"}'::json),
    ('Marina', '{"age": 30, "group": "SM11-51"}'::json),
    ('Hadezhda', '{"ag": 19, "group": "SM4-53"}'::json);

select * from json_table;

--4. Выполнить следующие действия:
--4.1. Извлечь XML/JSON фрагмент из XML/JSON документа
CREATE TABLE IF NOT EXISTS companies_name_city
(
	namecompany VARCHAR(40),
	city VARCHAR(40)
)

SELECT * FROM companies_import, json_populate_record(NULL::companies_name_city, doc);

SELECT doc->'namecompany' namecompany FROM companies_import;

SELECT doc->'city' city FROM companies_import;

--4.2. Извлечь значения конкретных узлов или атрибутов XML/JSON
--документа
CREATE TABLE rats 
(
    data jsonb
);
INSERT INTO rats (data) VALUES 
('{"name": "Ira", "age": 20, "hobby": {"actor": "Benedict", "film": "Sherlock"}}'), 
('{"name": "Vika", "age": 20, "hobby": {"actor": "Pattinson", "film": "Twilight"}}'),
('{"name": "Alena", "age": 19, "hobby": {"actor": "Migel", "film": "Dance on TNT"}}');;

SELECT data->'hobby'->'film' film FROM rats;

-- !!!4.3. Выполнить проверку существования узла или атрибута
-- jsonb

DROP TABLE json_table1;

CREATE TABLE IF NOT EXISTS json_table1
(
	id serial PRIMARY KEY,
	name varchar(40) NOT NULL,
	doc jsonb
);

insert into json_table1(name, doc) values 
    ('Ira', '{"age": 22, "group": "IU7-52"}'::jsonb),
    ('Marina', '{"age": 30, "group": "SM11-51"}'::jsonb),
    ('Hadezhda', '{"age": 19, "group": "SM4-53"}'::jsonb);

select * from json_table1;

CREATE OR REPLACE FUNCTION get_json_table(u_id int)
RETURNS VARCHAR AS '
    SELECT CASE
               WHEN count.cnt > 0
                   THEN ''true''
               ELSE ''false''
               END AS comment
    FROM (
             SELECT COUNT(doc -> ''age'') cnt
             FROM json_table1
             WHERE id < u_id
         ) AS count;
' LANGUAGE sql;

SELECT * FROM json_table1;

SELECT get_json_table(0);
        


CREATE OR REPLACE FUNCTION rat_exists(json_check jsonb, key text)
RETURNS BOOLEAN 
AS $$
BEGIN
    RETURN (json_check->key);
END;
$$ LANGUAGE PLPGSQL;
SELECT rat_exists('{"name": "Ira", "age": 20}', 'hobby');


--4.4. Изменить XML/JSON документ
UPDATE rats 
SET data = data || '{"age": 20}'::jsonb
WHERE (data->'age')::INT = 21;

SELECT * FROM rats 

--4.5. Разделить XML/JSON документ на несколько строк по узлам
CREATE TABLE rats1 
(
    doc json
);
DROP TABLE rats1;
INSERT INTO rats1 (doc) VALUES 
('[{"name": "Ira", "age": 20, "hobby": {"actor": "Benedict", "film": "Sherlock"}},
{"name": "Vika", "age": 20, "hobby": {"actor": "Pattinson", "film": "Twilight"}},
{"name": "Alena", "age": 19, "hobby": {"actor": "Migel", "film": "Dance on TNT"}}]');

SELECT jsonb_array_elements(doc::jsonb) 
FROM rats1;

SELECT * FROM rats1;


-- jsonb json
SELECT '[{"user_id": 0, "game_id": 1},
  {"user_id":   2, "game_id": 2}, {"user_id": 3, "game_id": 1}]'::jsonb;

SELECT '[{"user_id": 0, "game_id": 1},
  {"user_id":    2, "game_id": 2}, {"user_id": 3, "game_id": 1}]'::json;

-- JSONB — двоичная разновидность формата JSON, у которой пробелы удаляются, 
-- сортировка объектов не сохраняется, вместо этого они хранятся наиболее оптимальным образом, 
-- и сохраняется только последнее значение для ключей-дубликатов. JSONB обычно является предпочтительным 
-- форматом, поскольку требует меньше места для объектов, может быть проиндексирован и обрабатывается
--  быстрее, так как не требует повторного синтаксического анализа.

 ---- для 6 лабы ----
 SELECT inet_server_addr();
