from tk import *

import psycopg2


def main():
    a = ('2',)
    b = 'z'
    new = a + (b,)
    print(new)
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

    # Объект cursor используется для фактического
    # выполнения наших команд.
    cur = con.cursor()

    # Интерфейс.
    window(cur, con)

    # Закрываем соединение с БД.
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
