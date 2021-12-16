from time import time

import matplotlib.pyplot as plt
import psycopg2
import redis
import json
import threading
from random import randint

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

class spacecraft_listener(object):
  
  def __init__(self):
    self.redis = redis.Redis()
    self.sub = self.redis.pubsub()
    self.sub.psubscribe(['channel1'])

  def listen(self):
    for blob in self.sub.listen():
      if blob['type'] == "message":
        data    = json.loads(blob['data'])
        print(data)
        sender  = data['data']['sender']
        channel = data['data']['channel']
        text    = data['data']['message']
        


# Написать запрос, получающий статистическую информацию на основе
# данных БД. Например, получение топ 10 самых покупаемых товаров или
# получение количества проданных деталей в каждом регионе.
def get_hotel_1(cur):
    redis_client = redis.Redis(host="localhost", port=6379, db=0)

    cache_value = redis_client.get("hotels_1")
    if cache_value is not None:
        redis_client.close()
        return json.loads(cache_value)

    cur.execute("select * from packages.hotels where hotels.categoryid = 1")
    res = cur.fetchall()

    redis_client.set("hotels_1", json.dumps(res))
    redis_client.close()

    return res




# 1. Приложение выполняет запрос каждые 5 секунд на стороне БД.
def task_02(cur, id):
    threading.Timer(5.0, task_02, [cur, id]).start()
    
    cur.execute("select *\
                   from packages.hotels\
                   where cityd = %s;", (id, ))

    result = cur.fetchall()

    return result


# 2. Приложение выполняет запрос каждые 5 секунд через Redis в качестве кэша.
def task_03(cur, id):
    threading.Timer(5.0, task_02, [cur, id]).start()
    
    redis_client = redis.Redis(host="localhost", port=6379, db=0)
    
    # sub = spacecraft_listener()
    # sub.listen()

    cache_value = redis_client.get("hotels_cityid_" + str(id))
    if cache_value is not None:
        redis_client.close()
        return json.loads(cache_value)

    cur.execute("select *\
                   from packages.hotels\
                   where cityd = %s;", (id, ))

    result = cur.fetchall()
    data = json.dumps(result)
    print("FFFFFFFFFFFF")
    redis_client.set("hotels_cityid_" + str(id), data)
    redis_client.close()

    return result


def dont_do(cur):
    # print("simple\n")
    # threading.Timer(10.0, dont_do, [cur]).start()
    redis_client = redis.Redis(host="localhost", port=6379, db=0)

    t1 = time()
    cur.execute("select *\
                   from hotel_copy\
                   where hotelid = 1;")
    t2 = time()

    result = cur.fetchall()

    data = json.dumps(result)
    cache_value = redis_client.get("h1")
    if cache_value is not None:
        pass
    else:
        redis_client.set("h1", data)

    
    t11 = time()
    redis_client.get("h1")
    t22 = time()

    redis_client.close()

    return t2 - t1, t22 - t11


def del_tour(cur, con):
    redis_client = redis.Redis()
    # print("delete\n")
    # threading.Timer(10.0, del_tour, [cur, con]).start() 

    hid = randint(1, 1000)

    t1 = time()
    cur.execute("delete from public.hotel_copy\
         where hotelid = %s;", (hid, ))
    t2 = time()

    t11 = time()
    redis_client.delete("h"+str(hid))
    t22 = time()

    redis_client.close()
    
    con.commit()

    return t2-t1, t22-t11

def ins_tour(cur, con):
    redis_client = redis.Redis()
    # print("insert\n")
    # threading.Timer(10.0, ins_tour, [cur, con]).start() 

    hid = randint(1, 1000)
    
    t1 = time()
    cur.execute("insert into public.hotel_copy values(%s, 'AAA', 33, 'AAARegion', 2);", (hid, ))
    t2 = time()

    cur.execute("select * from public.hotel_copy\
         where hotelid = %s;", (hid, ))
    result = cur.fetchall()

    data = json.dumps(result)
    t11 = time()
    redis_client.set("h"+str(hid), data)
    t22 = time()

    redis_client.close()
    
    con.commit()

    return t2-t1, t22-t11

def upd_tour(cur, con):

    redis_client = redis.Redis()
    # print("update\n")
    # threading.Timer(10.0, upd_tour, [cur, con]).start() 

    hid = randint(1000, 2000)
    
    t1 = time()
    cur.execute("UPDATE hotel_copy SET cityd = 1 WHERE hotelid = %s;", (hid, ))
    t2 = time()

    cur.execute("select * from public.hotel_copy\
         where hotelid = %s;", (hid, ))

    result = cur.fetchall()
    data = json.dumps(result)

    t11 = time()
    redis_client.set("h"+str(hid), data)
    t22 = time()

    redis_client.close()
    
    con.commit()

    return t2-t1, t22-t11

# гистограммы
def task_04(cur, con):
    # simple 
    t1 = 0
    t2 = 0
    for i in range(1000):
        b1, b2 = dont_do(cur)
        t1 += b1
        t2 += b2
    print("simple 100 db redis", t1 / 1000, t2 / 1000)
    index = ["БД", "Redis"]
    values = [t1 / 1000, t2/ 1000]
    plt.bar(index,values)
    plt.title("Без изменения данных")
    plt.show()

    # delete 
    t1 = 0
    t2 = 0
    for i in range(1000):
        b1, b2 = del_tour(cur, con)
        t1 += b1
        t2 += b2
    print("delete 100 db redis", t1 / 1000, t2 / 1000)

    index = ["БД", "Redis"]
    values = [t1 / 1000, t2/ 1000]
    plt.bar(index,values)
    plt.title("При добавлении новых строк каждые 10 секунд")
    plt.show()

    # insert 
    t1 = 0
    t2 = 0
    for i in range(1000):
        b1, b2 = ins_tour(cur, con)
        t1 += b1
        t2 += b2
    print("ins_tour 100 db redis", t1 / 1000, t2 / 1000)

    index = ["БД", "Redis"]
    values = [t1 / 1000, t2/ 1000]
    plt.bar(index,values)
    plt.title("При удалении строк каждые 10 секунд")
    plt.show()

    # updata 
    t1 = 0
    t2 = 0
    for i in range(1000):
        b1, b2 = upd_tour(cur, con)
        t1 += b1
        t2 += b2
    print("updata 100 db redis", t1 / 1000, t2 / 1000)

    index = ["БД", "Redis"]
    values = [t1 / 1000, t2/ 1000]
    plt.bar(index,values)
    plt.title("При изменении строк каждые 10 секунд")
    plt.show()


def do_cache(cur):
    redis_client = redis.Redis(host="localhost", port=6379, db=0)

    for id in range(1000):
        cache_value = redis_client.get("h" + str(id))
        if cache_value is not None:
            redis_client.close()
            return json.loads(cache_value)

        cur.execute("select *\
                    from packages.hotels\
                    where hotelid = %s;", (id, ))

        result = cur.fetchall()
        print("FFFFFFFFFFFF")
        redis_client.set("h" + str(id), json.dumps(result))
        redis_client.close()

    return result

if __name__ == '__main__':

    #do_cache(cur)


    print("1. Отели категории 1 (задание 2)\n"
          "2. Приложение выполняет запрос каждые 5 секунд на стороне БД. (задание 3.1)\n"
          "3. Приложение выполняет запрос каждые 5 секунд через Redis вкачестве кэша. (задание 3.2)\n"
          "4. Гистограммы (задание 3.3)\n\n"
    ) 

    con = connection()
    cur = con.cursor()

    while True:
        c = int(input("Выбор: "))

        if c == 1:
            res = get_hotel_1(cur)

            for elem in res:
                print(elem)

        elif c == 2:
            citid = int(input("ID города (от 0 до 1000): "))

            res = task_02(cur, citid)

            for elem in res:
                print(elem)

        elif c == 3:
            citid = int(input("ID города (от 0 до 1000): "))

            res = task_03(cur, citid)

            for elem in res:
                print(elem)

        elif c == 4:
            task_04(cur, con)
        else:
            print("Ошибка\n")
            break

    cur.close()

    print("BY!")
