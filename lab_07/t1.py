from py_linq import *
from hotel import *

def request_1(hotels):
	# Отели категории 1
	result = hotels.where(lambda x: x['categoryid'] == 1).order_by(lambda x: x['namehotel']).select(lambda x: {x['namehotel'], x['categoryid']})
	return result

def request_2(hotels): 
	# Количество отелей категории 1
	result = hotels.count(lambda x: x['categoryid'] == 1)
	return result

def request_3(hotels):
	# Так казываемого минимальный и макисмальный регион
	region = Enumerable([{hotels.min(lambda x: x['region']), hotels.max(lambda x: x['region'])}])
	# Минимальное и максимальное имя 
	name = Enumerable([{hotels.min(lambda x: x['namehotel']), hotels.max(lambda x: x['namehotel'])}])
	result = Enumerable(region).union(Enumerable(name), lambda x: x)
	return result

def request_4(hotels):
	result = hotels.group_by(key_names = ['countryid'], key = lambda x: x['countryid']).select(lambda g: {'key': g.key.countryid, 'count': g.count()})
	return result

def request_5(hotels, country):
	result = hotels.join(country, lambda o_k : o_k['countryid'], lambda i_k: i_k['id'])
	return result

def task_1():
	hotels = Enumerable(create_hotels('data.csv'))
	country = Enumerable(create_country('country.csv'))

	print('\n1.Отели категории 1:')
	for elem in request_1(hotels): 
		print(elem)

	print(f'\n2.Количество отелей категории 1: {str(request_2(hotels))}')

	print('\n3.Максималььные и минимальные названия и регионы:')
	for elem in request_3(hotels): 
		print(elem)

	print('\n4.Группировка по полю Страна:')
	for elem in request_4(hotels): 
		print(elem)

	print('\n5.Соединяем отель и страну:\n')
	for elem in request_5(hotels, country): 
		print(elem)
		print()