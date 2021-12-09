# 3. LINQ to SQL. Создать классы сущностей, которые моделируют таблицы
# Вашей базы данных. Создать запросы четырех типов:
    # 1. Однотабличный запрос на выборку.
    # 2. Многотабличный запрос на выборку.
    # 3. Три запроса на добавление, изменение и удаление данных в базе
    # данных.
    # 4. Получение доступа к данным, выполняя только хранимую
    # процедуру.

from peewee import *
import psycopg2

con = PostgresqlDatabase(
    database="travelpackages",
    user="postgres",
    password="1830",
    host="127.0.0.1",  # Адрес сервера базы данных.
    port=5432	   # Номер порта.
)


class BaseModel(Model):
	class Meta:
		database = con


class Hotels(BaseModel):
	id = IntegerField(column_name='id')
	namehotel = CharField(column_name='namehotel')
	countryid = IntegerField(column_name='cityd')
	region = CharField(column_name='region')
	categoryid = IntegerField(column_name='categoryid')

	class Meta:
		table_name = 'hotel_star'

class Cities(BaseModel):
	id = IntegerField(column_name='cityid')
	namecity = CharField(column_name='namecity')
	countryid = IntegerField(column_name='countryid')

	class Meta:
		table_name = 'city_buf'
    
class Categoryhotel(BaseModel):
	id = IntegerField(column_name='categoryid')
	typecategory = CharField(column_name='typecategory')

	class Meta:
		table_name = 'categoryhotel'

def query_1():
	# 1. Однотабличный запрос на выборку.
	hotel = Hotels.get(Hotels.categoryid == 2)
	print("1. Однотабличный запрос на выборку:")
	print(hotel.id, hotel.namehotel, hotel.countryid, hotel.region, hotel.categoryid)

	# Получаем набор записей.
	query = Hotels.select().where(Hotels.categoryid == 2).limit(10).order_by(Hotels.id)

	print("Запрос:", query, '\n')
	
	hotels_selected = query.dicts().execute()

	print("Результат:\n")
	for elem in hotels_selected:
		print(elem)


def query_2():
	# 2. Многотабличный запрос на выборку.
	global con 
	print("\n2. Многотабличный запрос на выборку:")
	
	print("Отели и их города:")

	# Изеры и игры, в которых они заблокированы.
	query = Hotels.select(Hotels.id, Hotels.namehotel, Cities.namecity).join(Cities, on=(Hotels.countryid == Cities.id)).order_by(Hotels.id).limit(5).where(Hotels.id>2)
	
	u_b = query.dicts().execute()
	for elem in u_b:
		print(elem)

	print("Отели и названия категорий:")

	# Изер и цвет его шлема.
	query = Hotels.select(Hotels.id, Categoryhotel.typecategory).join(Categoryhotel, on=(Hotels.categoryid == Categoryhotel.id)).limit(5)

	u_d = query.dicts().execute()

	for elem in u_d:
		print(elem)

def print_last_five_hotels():
	# Вывод последних 5-ти записей.
	print("Последнии 5 отеля:")
	query = Hotels.select().limit(5).order_by(Hotels.id.desc())
	for elem in query.dicts().execute():
		print(elem)
	print()

def add_user(new_id, new_name, new_countryid, new_region, new_categoryid):
	global con 
	
	try:
		with con.atomic() as txn:
			# user = Users.get(Users.id == new_id)
			h = Hotels(id=new_id, namehotel=new_name, countryid=new_countryid, region=new_region, categoryid=new_categoryid)
			print("Пользователь успешно добавлен!")	
			h.save()
	except:
		print("Пользователь уже существует!")
		txn.rollback()

def update_name(hotel_id, new_name):
	hotel = Hotels(id=hotel_id)
	hotel.namehotel = new_name
	hotel.save()	
	print("Name успешно обновлен!")

def del_hotel(hotel_id):
	print("Пользователь успешно удален удален!")
	hotel = Hotels.get(Hotels.id == hotel_id)
	hotel.delete_instance()

def query_3():
	# 3. Три запроса на добавление, изменение и удаление данных в базе данных.
	print("3. Три запроса на добавление, изменение и удаление данных в базе данных:")

	print_last_five_hotels()

	add_user(2003, "Mary Rodriguez", 237, "BeninRegion5", 2)
	print_last_five_hotels()

	update_name(2003, 'nnnnnnn')
	print_last_five_hotels()
	
	del_hotel(2003)	
	print_last_five_hotels()


def query_4():
	# 4. Получение доступа к данным, выполняя только хранимую процедуру.
	global con 
	# Можно выполнять простые запросы.
	cursor = con.cursor()

	print("4. Получение доступа к данным, выполняя только хранимую процедуру:")

	# cursor.execute("SELECT * FROM users ORDER BY id DESC LIMIT 5;")
	# for elem in cursor.fetchall():
	# 	print(*elem)

	print_last_five_hotels()

	cursor.execute("SELECT change_star(%s, %s);", (2,3))
	# # Фиксируем изменения.
	# # Т.е. посылаем команду в бд.
	# # Метод commit() помогает нам применить изменения,
	# # которые мы внесли в базу данных,
	# # и эти изменения не могут быть отменены,
	# # если commit() выполнится успешно.
	con.commit()

	print_last_five_hotels()

	cursor.execute("SELECT change_star(%s, %s);", (3,2))
	con.commit()

	cursor.close()

def task_3():
	global con 

	query_1()
	query_2()
	query_3()
	query_4()

	con.close()