CREATE TABLE public.table1
(
	id INT, 
	var1 char,
	valid_from_dttm date,
	valid_to_dttm date
);


CREATE TABLE public.table2
(
	id INT, 
	var2 char,
	valid_from_dttm date,
	valid_to_dttm date
);

INSERT INTO table1 (id, var1, valid_from_dttm, valid_to_dttm) VALUES (1, 'A', '20180901', '20180915');
INSERT INTO table1 (id, var1, valid_from_dttm, valid_to_dttm) VALUES (1, 'B', '20180916', '59991231');

INSERT INTO table2 (id, var2, valid_from_dttm, valid_to_dttm) VALUES (1, 'A', '20180901', '20180918');
INSERT INTO table2 (id, var2, valid_from_dttm, valid_to_dttm) VALUES (1, 'B', '20180919', '59991231');


SELECT * FROM table1;
SELECT * FROM table2;


SELECT table1.id, table1.var1, table2.var2,
	CASE WHEN table1.valid_from_dttm <= table2.valid_from_dttm 
				THEN table2.valid_from_dttm
				ELSE table1.valid_from_dttm
	END valid_from_dttm,
	
	CASE WHEN table1.valid_to_dttm >= table2.valid_to_dttm 
				THEN table2.valid_to_dttm
				ELSE table1.valid_to_dttm
	END valid_to_dttm
FROM table1 FULL OUTER JOIN table2 ON table1.id = table2.id
		AND table1.valid_to_dttm >= table2.valid_from_dttm
		AND table2.valid_to_dttm >= table1.valid_from_dttm
ORDER BY id, valid_from_dttm

	







