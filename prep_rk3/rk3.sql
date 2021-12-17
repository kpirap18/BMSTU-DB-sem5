CREATE OR REPLACE FUNCTION get_latecomers(dt DATE)
RETURNS INT
AS
$$
    SELECT COUNT(employee_id) AS cnt
    FROM record
    WHERE rdate = dt
    AND rtime > '09:00:00'
    AND rtype = 1;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_latecomers2(dt DATE)
RETURNS INT
AS $$
count_ = 0
plan = plpy.prepare("SELECT employee_id \
				FROM record \
				WHERE rdate = $1 AND rtype = 1\
				group by employee_id \
				HAVING min(rtime) > '9:00';", ["DATE"])

run = plpy.execute(plan, [dt])
count_ = run.nrows()
return count_
$$ LANGUAGE plpython3u;

SELECT employee_id
FROM record
WHERE rdate = '2019-12-21'
AND rtype = 1
group by employee_id 
HAVING min(rtime) > '9:00'

SELECT get_latecomers2('2019-12-21') AS cnt;
