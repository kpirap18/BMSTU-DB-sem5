from time import *
from peewee import *
import datetime

from datetime import *


TASK_2_1 = """
select department
from employee
group by department
having count(id) > 10;
"""

TASK_2_2 = """
select id
from employee
where id not in(
	select employee_id
	from (
		select employee_id, rdate, rtype, count(*)
		from record
		group by employee_id, rdate, rtype
		having rtype=2 and count(*) > 1
		) as tmp
);
"""

TASK_2_3 = """
select distinct department
from employee
where id in 
(
	select employee_id
	from
	(
		select employee_id, min(rtime)
		from record
		where rtype = 1 and rdate = '23-12-2019'
		group by employee_id
		having min(rtime) > '9:00'
	) as tmp
);
"""

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


def output(cur):
    rows = cur.fetchall()
    for elem in rows:
        print(*elem)
    print()


def print_query(query):
	u_b = query.dicts().execute()
	for elem in u_b:
		print(elem)


def task_0():
    global con

    cur = con.cursor()

    cur.execute(TASK_2_1)
    print("Задание 1:")
    output(cur)

    cur.execute(TASK_2_2)
    print("Задание 2:")

    output(cur)

    dat = input("Введите дату: (ГГГГ-ММ-ДД) ")
    query = '''
            select distinct department
            from employee
            where id in 
            (
                select employee_id
                from
                (
                    select employee_id, min(rtime)
                    from record
                    where rtype = 1 and rdate = %s
                    group by employee_id
                    having min(rtime) > '9:00'
                ) as tmp
            );'''
    cur.execute(query, (dat, ))
    print("Задание 3:")
    output(cur)

    cur.close()

# Найти все отделы, в которых работает более 10 сотрудников
def task_1():
    print("1. Найти все отделы, в которых работает более 10 сотрудников")
    now = datetime.now()
    now = now.strftime("%Y-%m-%d")
    tmp = now - Employee.birthdate
    query = Employee\
        .select(Employee.department)\
        .group_by(Employee.department)\
        .having(fn.Count(Employee.id) > 10)

    print_query(query)

# Найти сотрудников, которые не выходят с рабочего места 
# в течение всего рабочего дня
def task_2():
    data = '21-12-2019'
    print("2. Найти сотрудников, которые не выходят с рабочего места в течение всего рабочего дня")
    # query = Record\
    #         .select(Record.employee_id).distinct()\
    #         .where(Record.rtype == 2)\
    #         .group_by(Record.employee_id, Record.rdate, Record.rtype)\
    #         .having(fn.count(Record.employee_id) > 1)

    # query1 = Employee.select(Employee.id).where(Employee.id.not_in(query))
    # print_query(query1)

    t1 = Record\
        .select(Record.employee_id, Record.rdate)\
        .where(Record.rtype == 1)\
        .where(Record.rdate == data)\
        .group_by(Record.employee_id, Record.rdate)\
        .having(fn.count(Record.employee_id) == 1).alias('res1')
    print_query(t1)

    t2 = Record\
        .select(Record.employee_id, Record.rdate)\
        .where(Record.rtype == 2)\
        .where(Record.rtime >= '17:30')\
        .group_by(Record.employee_id, Record.rdate)\
        .having(fn.count(Record.employee_id) == 1).alias('res2')
    print_query(t2)


    res = Employee\
        .select(Employee.fio)\
        .join(t1, on=Employee.id == SQL('res1.employee_id'))\
        .join(t2, on=Employee.id == SQL('res2.employee_id'))\

    print_query(res)


# Найти все отделы, в которых есть сотрудники, опоздавшие \
# в определенную дату. Дату передавать с клавиатуры
def task_3():
    print("3. Найти все отделы, в которых есть сотрудники, опоздавшие в определенную дату. Дату передавать с клавиатуры")
    dat = '2019-12-21'
    query = Record\
        .select(Record.employee_id)\
        .where(Record.rtype == 1 and Record.rdate == dat)\
        .group_by(Record.employee_id)\
        .having(fn.Min(Record.rtime) > '9:00')

    query1 = Employee\
        .select(Employee.department).distinct()\
        .where(Employee.id.in_(query))

    print_query(query1)


    res = (Employee
            .select(Employee.department)\
            .from_(Record
                    .select(SQL('employee_id'), SQL('rdate'), SQL('rtime'), SQL('rdate'), SQL('rtype'), SQL('num'))\
                    .from_(Record
                            .select(Record.employee_id.alias('employee_id'), Record.rdate.alias('rdate'), Record.rtime.alias('rtime'),
                                Record.rtype.alias('rtype'),
                                fn.RANK().over(partition_by=[Record.employee_id, Record.rdate], order_by=[Record.rtime]).alias('num'))\
                            .where(Record.rtype == 1))\
                    .where(SQL('rtime') > '09:00:00')\
                    .where(SQL('num') == 1)\
                    .where(SQL('rdate') == dat))\
            .join(Employee, on=Employee.id == SQL('employee_id'))\
            .group_by(Employee.department))
    print_query(res)

# Отделы, в которых сотрудники опаздывают более 2х раз в неделю
def task_4():
    Record1 = Record.alias()
    query = (Record1\
        .select(Record1.employee_id, fn.Date_part('week', Record1.rdate).alias('data1'))\
        .where(Record1.rtype == 1)\
        .group_by(Record1.employee_id, Record1.rdate)\
        .having(fn.min(Record1.rtime) > '9:00'))

    print(query)
    
    print_query(query)

    query1 = Employee\
        .select(Employee.department, fn.count(Employee.id))\
        .join(query, on=(query.c.employee_id==Employee.id))\
        .group_by(query.c.data1, Employee.department)\
        .having(fn.count(query.c.employee_id) > 2)

    print_query(query1)

# Найти средний возраст сотрудников, не находящихся
# на рабочем месте 8 часов в день.
def task_5():
    pass

# Все отделы и кол-во сотрудников
# Хоть раз опоздавших за всю историю учета.
def task_6():
    query = Employee\
        .select(Employee.department, fn.count(SQL('employee_id').distinct()))\
        .from_(Record\
            .select( #fn.Distinct(Record.rdate, SQL('time_in')),
                    SQL('employee_id'), 
                    Record.rdate, 
                    fn.min(Record.rtime).over(partition_by=[Record.employee_id, Record.rdate]).alias('time_in'))\
            .where(Record.rtype==1)).alias('r')\
        .join(Employee, on=(Employee.id == SQL('employee_id')))\
        .where(SQL('time_in') > '09:00:00')\
        .group_by(Employee.department)

    print_query(query)

# Найти самого старшего сотрудника в бухгалтерии
def task_7():
    Employee1 = Employee.alias()
    min_bir = (Employee\
        .select(fn.min(Employee.birthdate).alias('mb'))\
        .where(Employee.department == 'IT'))
    print_query(min_bir)

    query = Employee\
        .select(Employee.id, Employee.fio, Employee.birthdate)\
        .where(Employee.department=='IT' and Employee.birthdate == min_bir)

    print_query(query)

# Найти сотрудников, выходивших больше 3-х раз с рабочего места
def task_8():
    Record1 = Record.alias()
    query = Record1\
        .select(Record1.employee_id, fn.count(Record1.employee_id).alias('cnt')).distinct()\
        .where(Record1.rtype == 2)\
        .group_by(Record1.employee_id, Record1.rdate)\
        .having(fn.count(Record1.employee_id) > 2)

    print_query(query)

    query1 = Employee.select(Employee.id, Employee.fio, query.c.cnt).join(query, on=(query.c.employee_id==Employee.id))
    print_query(query1)

# Найти сотрудника, который пришел сегодня последним
def task_9():
    Record1 = Record.alias()
    dat = '21-12-2019'
    query1 = Record1\
        .select(Record1.rdate,
                fn.min(Record1.rtime)\
                    .over(partition_by=[Record1.employee_id, Record1.rdate]).alias('time_in'))\
        .where(Record1.rtype == 1)\
        .where(Record1.rdate == dat)\
        .order_by(SQL('time_in').desc())\
        .distinct()\
        .limit(1)
    print_query(query1)


# В идеале сравнить время с максимумом за нужную дату....
# Но что-то пошло не так
# Поэтому сортировка и беру первую
    query = Employee\
    .select(Employee.id, Employee.fio, SQL('time_in'), SQL('rdate'))\
    .from_(Record\
        .select( #fn.Distinct(Record.rdate, SQL('time_in')),
                SQL('employee_id'), 
                SQL('rdate'), 
                fn.min(Record.rtime).over(partition_by=[Record.employee_id, Record.rdate]).alias('time_in'))\
        .where(Record.rtype==1)).alias('r')\
    .join(Employee, on=(Employee.id == SQL('employee_id')))\
    .where(SQL('rdate') == dat)\
    .order_by(SQL('time_in').desc())\
    .limit(1)
    # .where(SQL('time_in') == query1.c.time_in)

    print_query(query)

def task_10():
    pass


def main():
    task_9()


if __name__ == '__main__':
    main()
