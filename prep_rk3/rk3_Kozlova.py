# Козлова ИУ7-52Б
# Вариант 4
# РК3


TASK_2_2 = """select DISTINCT employee_id
from employee join
	(
		select employee_id, rdate, rtime, 
				rtype, 
				rtime-lag(rtime) over (partition by employee_id, rdate order by rtime) as pereryv,
				lead(employee_id) over (partition by employee_id, rdate order by rtime) as q
		from record r 
		order by employee_id, rdate, rtime
	) as durations
on employee.id = durations.employee_id
and durations.pereryv > '00:10:00' -- время вызода больше 10 минут
and durations.q = durations.employee_id -- я проверяю, что след строка
-- тоже принадлежит сотруднику, которого рассматриваю (то есть 
-- если короче, что это не выход домой у него)
group by durations.employee_id 
"""


TASK_2_3 = """
select DISTINCT on (employee.id, employee.fio) employee.id, employee.fio
from (select distinct on (rdate, first_time) employee_id, 
				rdate, 
				min(rtime) OVER (PARTITION BY employee_id, rdate) as first_time
	from record
	where rtype = 1) as tmp join employee on tmp.employee_id = employee.id
where employee.department = 'Accounting' and first_time <= '9:00'
"""


from time import *
from peewee import *
import datetime

from datetime import *


con = PostgresqlDatabase(
    database="postgres",
    user="postgres",
    password="1830",
    host="127.0.0.1",  # Адрес сервера базы данных.
    port=5432	   # Номер порта.
)

class BaseModel(Model):
    class Meta:
        database = con


class Employee(BaseModel):
    id = IntegerField(column_name='id')
    fio = CharField(column_name='fio')
    birthdate = DateField(column_name='birthdate')
    department = CharField(column_name='department')

    class Meta:
        table_name = 'employee'


class Record(BaseModel):
    employee_id = ForeignKeyField(Employee, on_delete="cascade")
    rdate = DateField(column_name='rdate')
    dayweek = CharField(column_name='dayweek')
    rtime = TimeField(column_name='rtime')
    rtype = IntegerField(column_name='rtype')

    class Meta:
        table_name = 'record'

def output(cur): # для вывода просто на урове базы
    rows = cur.fetchall()
    for elem in rows:
        print(*elem)
    print()


def print_query(query): # для вывода на уровне приложения
	u_b = query.dicts().execute()
	for elem in u_b:
		print(elem)


def task_0():
    global con

    cur = con.cursor()

    dat = input("Введите дату: (ДД-ММ-ГГГГ) ")
    query = """
        select employee.id, employee.fio, first_time
        from (select distinct on (rdate, first_time) employee_id, 
                        rdate, 
                        min(rtime) OVER (PARTITION BY employee_id, rdate) as first_time
            from record
            where rtype = 1) as tmp join employee on tmp.employee_id = employee.id
        where rdate = %s and first_time < '9:05' and first_time >= '9:00'
        """
    cur.execute(query, (dat, ))
    print("Задание 1:")
    output(cur)

    cur.execute(TASK_2_2)
    print("Задание 2:")
    output(cur)

    cur.execute(TASK_2_3)
    print("Задание 3:")
    output(cur)


def task_2_1():
    dat = input("Введите дату: (ДД-ММ-ГГГГ) ")

    query = Employee\
    .select(Employee.id, Employee.fio, SQL('first_time'))\
    .from_(Record\
        .select(fn.Distinct(SQL('employee_id'), SQL('rdate')),
                SQL('employee_id'), 
                SQL('rdate'), 
                fn.min(Record.rtime).over(partition_by=[Record.employee_id, Record.rdate]).alias('first_time'))\
        .where(Record.rtype==1)).alias('r')\
    .join(Employee, on=(Employee.id == SQL('employee_id')))\
    .where(SQL('first_time') > '09:00')\
    .where(SQL('first_time') <= '09:05')\
    .where(SQL('rdate') == dat)

    print_query(query)

def task_2_2():
    query = Record\
                .select(fn.Distinct(SQL('employee_id')))\
                .from_(
                    Record\
                        .select(SQL('employee_id'), 
                                SQL('rdate'), 
                                SQL('rtime'), 
                                SQL('rtype'), 
                                (Record.rtime - fn.Lag(Record.rtime).over(partition_by=[Record.employee_id, Record.rdate])).alias('pereryv'),
                                (fn.LEAD(SQL('employee_id')).over(partition_by=[Record.employee_id, Record.rdate])).alias('next1'))\
                        .order_by(Record.employee_id, Record.rdate, Record.rtime)
                ).alias('durations')\
        .join(Employee, on=(Employee.id==SQL('employee_id')))\
        .where(SQL('pereryv') > '00:10:00')\
        .where(SQL('next1') == SQL('employee_id'))\
        .group_by(SQL('employee_id'))

    print_query(query)


def task_2_3():
    query = Employee\
    .select(fn.Distinct(Employee.id, Employee.fio), Employee.id, Employee.fio)\
    .from_(Record\
        .select(fn.Distinct(SQL('employee_id'), SQL('rdate')),
                SQL('employee_id'), 
                SQL('rdate'), 
                fn.min(Record.rtime).over(partition_by=[Record.employee_id, Record.rdate]).alias('first_time'))\
        .where(Record.rtype==1)).alias('r')\
    .join(Employee, on=(Employee.id == SQL('employee_id')))\
    .where(Employee.department == 'Accounting')\
    .where(SQL('first_time') <= '9:00')

    print_query(query)

def main():
    task_0()

    print("ЗАПРОСЫ НА УРОВНЕ ПРИЛОЖЕНИЯ peewee\n\n\n")
    print("Задание 1:")
    task_2_1()

    print("\nЗадание 2:")
    task_2_2()

    print("\nЗадание 3:")
    task_2_3()

if __name__ == '__main__':
    main()
