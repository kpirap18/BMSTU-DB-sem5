from hotel import hotel
import json
import psycopg2

def connection():
	# Подключаемся к БД.
    try:
        con = psycopg2.connect(
            database="travelpackages",
            user="postgres",
            password="1830",
            host="127.0.0.1",  # Адрес сервера базы данных.
            port="5432"		   # Номер порта.
        )
    except:
        print("Ошибка при подключении к Базе Данных")
        return

    print("База данных успешно открыта")
    return con

def read_table_json(cur, count = 20):
	cur.execute("select * from hotels_json")

	rows = cur.fetchmany(count)
	array = list()
	for elem in rows: 
		tmp = elem[0]
		print(tmp)
		array.append(hotel(tmp['hotelid'], tmp['namehotel'], tmp['cityd'], tmp['region'],
		tmp['categoryid']))

	print(f"{'id':<2} {'namehotel':<20} {'countryid':<5} {'region':<20} {'categoryid':<5}")
	print(*array, sep='\n')
	
	return array

def output_json(array):
	for elem in array:
		print(json.dumps(elem.get()))

def update_hotel(hotels, ws, fs):
	# если звездность равно данной, то заменить ее
	for elem in hotels:
		if elem.categoryid == ws:
			elem.categoryid = fs
	output_json(hotels)

def add_hotel(hotels, hotel):
	hotels.append(hotel)
	output_json(hotels)

def task_2():
	con = connection()
	cur = con.cursor()

	# 1. Чтение из XML/JSON документа.
	print("1.Чтение из XML/JSON документа:")
	hotels_array = read_table_json(cur)

	# 2. Обновление XML/JSON документа.
	print("2.Обновление XML/JSON документа:")
	last = int(input("Введите звездность: "))
	update_hotel(hotels_array, last, last + 1)

	# 3. Запись (Добавление) в XML/JSON документ.
	print("3.Запись (Добавление) в XML/JSON документ:")
	name = input("Введите имя: ")
	country = int(input("Введите номер страны (от 1 до 999): "))
	region = input("Введите регион: ")
	categ = int(input("Введите звездность: "))
	add_hotel(hotels_array, hotel(1111, name, country, region, categ))

	# Закрываем соединение с БД.
	cur.close()
	con.close()