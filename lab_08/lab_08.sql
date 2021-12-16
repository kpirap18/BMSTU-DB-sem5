CREATE TABLE log_lab_08 (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    filename varchar,
    uuid varchar 
);

SELECT * FROM log_lab_08;

DROP TABLE log_lab_08;

SELECT * FROM packages.hotels;

CREATE FUNCTION emp_stamp() RETURNS trigger AS $emp_stamp$
    BEGIN
        RAISE NOTICE '%', NEW;
       RETURN NEW;
    END;
$emp_stamp$ LANGUAGE plpgsql;Ы

CREATE TRIGGER emp_stamp BEFORE INSERT OR UPDATE ON emp
    FOR EACH ROW EXECUTE PROCEDURE emp_stamp();
    
DROP TRIGGER emp_stamp ON emp

DROP FUNCTION emp_stamp
   INSERT INTO emp
(
	id,
	cname,
	yearbc,
	what,
	id_manager
)
VALUES 
(1, 'Name1', 1999, 'draw', 1);




