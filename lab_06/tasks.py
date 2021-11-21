def create_list_box(rows, title, count=15):
    root = Tk()

    root.title(title)
    root.resizable(width=False, height=False)

    size = (count + 3) * len(rows[0]) + 1

    list_box = Listbox(root, width=size, height=22,
                       font="monospace 10", bg="lavender", highlightcolor='lavender', selectbackground='#59405c', fg="#59405c")

    list_box.insert(END, "⬮" * size)

    for row in rows:
        string = (("⬮ {:^" + str(count) + "} ") * len(row)).format(*row) + '⬮'
        list_box.insert(END, string)

    list_box.insert(END, "⬮" * size)

    list_box.grid(row=0, column=0)

    root.configure(bg="lavender")

    root.mainloop()


def execute_task1(cur, p1, p2):
    try:
        p1 = int(p1.get())
        p2 = int(p2.get())
    except:
        mb.showerror(title="Ошибка", message="Введите число!")
        return

    cur.execute(" \
        SELECT t.price , count(price) \
        FROM packages.trpackages t  \
        WHERE t.price > %s and t.price < %s \
        GROUP BY t.price ", (p1, p2))

    row = cur.fetchall()
    r = tuple()
    for e in cur.description:
        r = r + (e[0],)
    row.insert(0, r)
    print(row)
    s = ""
    for i in range(len(row)):
        s += f"Цена: {row[i][0]} Кол-во: {row[i][1]}\n"

    create_list_box(row, "Задание 1")


def execute_task4(cur, table_name, con):
    table_name = table_name.get()

    try:
        cur.execute(f"SELECT * FROM pg_catalog.pg_indexes WHERE tablename = '{table_name}';")
        row = cur.fetchall()
    except:
        # Откатываемся.
        con.rollback()
        mb.showerror(title="Ошибка", message="Такой таблицы нет!")
        return
    rows = [(elem[0],) for elem in cur.description]
    r = tuple()
    for e in cur.description:
        r = r + (e[0],)
    
    row.append(r)
    rr = []
    p = (row[0][0],)
    print(len(row[0]), p, row)
    for i in range(3):
        p = (row[0][i],)
        p = p + (row[1][i],)
        rr.append(p)
    print(rr)

    create_list_box(rr, "Задание 4")


def execute_task6(cur, id_h, price):
    id_h = id_h.get()
    price = price.get()
    try:
        id_h = int(id_h)
        price = int(price)
    except:
        mb.showerror(title="Ошибка", message="Введите число!")
        return

    cur.execute("SELECT * FROM get_packages_com_price(%s, %s);", (id_h, price,))

    rows = cur.fetchall()
    r = tuple()
    for e in cur.description:
        r = r + (e[0],)
    rows.insert(0, r)

    create_list_box(rows, "Задание 6")



def execute_task10(cur, param, con):
    try:
        user_id = int(param[0].get())
        world_id = int(param[1].get())
        reason = param[2].get()
    except:
        mb.showerror(title="Ошибка", message="Некорректные параметры!")
        return

    print(user_id, world_id, reason)

    #cur.execute("SELECT * FROM packages.hotel_blacklist")

    # print(cur.fetchone(), not cur.fetchone())

    # if not cur.fetchone():
    #     mb.showerror(title="Ошибка", message="Таблица не создана!")
    #     return

    try:
        cur.execute("INSERT INTO packages.hotel_blacklist VALUES(%s, %s, %s)",
                    (user_id, world_id, reason))
    except:
        mb.showerror(title="Ошибка!", message="Ошибка запроса!")
        # Откатываемся.
        con.rollback()
        return

    # Фиксируем изменения.
    con.commit()

    cur.execute("SELECT * FROM packages.hotel_blacklist")
    
    row = cur.fetchall()
    create_list_box(row, "Задание 10")

    #mb.showinfo(title="Информация!", message="Отель добавлен!")


def execute_task10_1(cur, param, con):
    try:
        id_ = int(param[0].get())
        hotelid = int(param[1].get())
        reason = param[2].get()
    except:
        mb.showerror(title="Ошибка", message="Некорректные параметры!")
        return

    print(id_, hotelid, reason)

    #cur.execute("SELECT * FROM packages.hotel_blacklist")

    # if not cur.fetchone():
    #     mb.showerror(title="Ошибка", message="Таблица не создана!")
    #     return

    try:
        f = open("/home/kpirap18/sem5/db1/lab_06/hotelbl.csv", "w")
        print(f)
        f.write(f"{id_};{hotelid};{reason}\n")
        f.close()

        cur.execute("copy packages.hotel_blacklist(id, hotelid, reason) from '/home/kpirap18/sem5/db1/lab_06/hotelbl.csv' delimiter ';';")
    except:
        mb.showerror(title="Ошибка!", message="Ошибка запроса!")
        # Откатываемся.
        con.rollback()
        return

    # Фиксируем изменения.
    con.commit()
    cur.execute("SELECT * FROM packages.hotel_blacklist")
    
    row = cur.fetchall()
    print(row)

    create_list_box(row, "Задание 10")



def task1(cur, con = None):
    root_1 = Tk()

    root_1.title('Задание 1')
    root_1.geometry("300x300")
    root_1.configure(bg="lavender")
    root_1.resizable(width=False, height=False)

    Label(root_1, text="  Нижняя граница:", bg="lavender").place(
        x=75, y=50)
    p1 = Entry(root_1)
    p1.place(x=75, y=85, width=150)

    Label(root_1, text="  Верхняя граница:", bg="lavender").place(
        x=75, y=120)
    p2 = Entry(root_1)
    p2.place(x=75, y=145, width=150)

    b = Button(root_1, text="Выполнить",
               command=lambda arg1=cur, arg2=p1, arg3=p2: execute_task1(arg1, arg2, arg3),  bg="thistle3")
    b.place(x=75, y=175, width=150)

    root_1.mainloop()


def task2(cur, con = None):
    # компания и кол-вао ее путевок
    cur.execute(" \
    SELECT namecompany, COUNT(namecompany) \
    FROM packages.companies c  \
    JOIN packages.trpackages t  \
    ON c.companyid = t.companyid  \
    GROUP BY namecompany ;")

    rows = cur.fetchall()
    r = tuple()
    for e in cur.description:
        r = r + (e[0],)
    rows.insert(0, r)
    print(rows)

    create_list_box(rows, "Задание 2")


def task3(cur, con = None):
    # Добавить столбец с минимальной ценой путевки для каждой компании (группа по комапии)
    cur.execute("\
    WITH new_table (trpackagesid, companyid, price, Min_price) \
    AS ( \
        SELECT trpackagesid, companyid, price, MIN(t.price) OVER(PARTITION BY t.companyid) Min_price \
        FROM packages.trpackages t  \
        ORDER BY t.companyid  \
    ) \
    SELECT * FROM new_table;;")
    rows = cur.fetchall()
    r = tuple()
    for e in cur.description:
        r = r + (e[0],)
    rows.insert(0, r)
    create_list_box(rows, "Задание 3")


def task4(cur, con):

    root_1 = Tk()

    root_1.title('Задание 4')
    root_1.geometry("300x200")
    root_1.configure(bg="lavender")
    root_1.resizable(width=False, height=False)

    Label(root_1, text="Введите название таблицы:", bg="lavender").place(
        x=65, y=50)
    name = Entry(root_1)
    name.place(x=75, y=85, width=150)

    b = Button(root_1, text="Выполнить",
               command=lambda arg1=cur, arg2=name: execute_task4(arg1, arg2, con),  bg="thistle3")
    b.place(x=75, y=120, width=150)

    root_1.mainloop()


def task5(cur, con = None):
    cur.execute("SELECT get_max_price();")

    row = cur.fetchone()

    mb.showinfo(title="Результат",
                message=f"Максимальное стоимость путевки составляет: {row[0]}")


def task6(cur, con = None):
    root = Tk()

    root.title('Задание 6')
    root.geometry("300x300")
    root.configure(bg="lavender")
    root.resizable(width=False, height=False)

    Label(root, text="  Номер компании:", bg="lavender").place(
        x=75, y=50)
    p1 = Entry(root)
    p1.place(x=75, y=85, width=150)

    Label(root, text=" Цена:", bg="lavender").place(
        x=75, y=120)
    p2 = Entry(root)
    p2.place(x=75, y=145, width=150)

    b = Button(root, text="Выполнить",
               command=lambda arg1=cur, arg2=p1, arg3=p2: execute_task6(arg1, arg2, arg3),  bg="thistle3")
    b.place(x=75, y=170, width=150)

    root.mainloop()


def task7(cur, con=None):
    cur.execute("CALL change_price(); \
    SELECT t.trpackagesid, t.tourid, t.companyid, t.price, t.numberpeople \
    FROM travelpackages_price t \
    ORDER BY t.trpackagesid;;")

    rows = cur.fetchall()
    r = tuple()
    for e in cur.description:
        r = r + (e[0],)
    rows.insert(0, r)
    create_list_box(rows, "Задание 7")


def task8(cur, con = None):
    # Информация:
    # https://postgrespro.ru/docs/postgrespro/10/functions-info
    cur.execute(
        "SELECT current_database(), current_user;")
    current_database, current_user = cur.fetchone()
    mb.showinfo(title="Информация",
                message=f"Имя текущей базы данных:\n{current_database}\nИмя пользователя:\n{current_user}")


def task9(cur, con):
    cur.execute(" \
        CREATE TABLE IF NOT EXISTS packages.hotel_blacklist \
        ( \
            id INT PRIMARY KEY, \
            hotelid INT, \
            FOREIGN KEY(hotelid) REFERENCES packages.hotels(hotelid), \
            reason VARCHAR \
        ) ")

    con.commit()

    mb.showinfo(title="Информация",
                message="Таблица успешно создана!")


def task10(cur, con):
    root = Tk()

    root.title('Задание 10')
    root.geometry("400x300")
    root.configure(bg="lavender")
    root.resizable(width=False, height=False)

    names = ["порядковый номер отеля в ЧС",
             "идентификатор отеля",
             "причина"]

    param = list()

    i = 0
    for elem in names:
        Label(root, text=f"Введите {elem}:",
              bg="lavender").place(x=70, y=i + 25)
        elem = Entry(root)
        i += 50
        elem.place(x=115, y=i, width=150)
        param.append(elem)

    b = Button(root, text="INSERT",
               command=lambda: execute_task10(cur, param, con),  bg="thistle3")
    b.place(x=115, y=190, width=150)

    b2 = Button(root, text="COPY",
               command=lambda: execute_task10_1(cur, param, con),  bg="thistle3")
    b2.place(x=115, y=220, width=150)

    root.mainloop()
