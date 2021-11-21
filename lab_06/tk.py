from tasks import *

from tkinter import *

root = Tk()

t = ["1. Выполнить скалярный запрос\nПутевки (цена между МИН и МАКС)",
     "2. Выполнить запрос с несколькими соединениями(JOIN)\nКомпания и кол-во ее путевок",
     "3. Выполнить запрос с ОТВ(CTE) и оконными функциями\nДобавить столбец с мин ценой путевки для каждой компании (группа по комапии)",
     "4. Выполнить запрос к метаданным",
     "5. Вызвать скалярную функцию(написанную в третьей лабораторной работе)\nМаксимальная стоимость путевки",
     "6. Вызвать многооператорную или табличную функцию(написанную в третьей лабораторной работе)\nПутевки от такой-то компании или с такой-то ценой",
     "7. Вызвать хранимую процедуру(написанную в третьей лабораторной работе)\nсделать цену как кол-во * 500",
     "8. Вызвать системную функцию или процедуру\nтекущий пользователь и текущая БД",
     "9. Создать таблицу в базе данных, соответствующую тематике БД\nСОздается hotelblacklist",
    "10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY.\nи COPY и INSERT"]

def info_show():
    global root
    info = Toplevel(root)
    info_txt = "Условия задачи: \n\
     1. Выполнить скалярный запрос;\n \
     2. Выполнить запрос с несколькими соединениями(JOIN);\n\
     3. Выполнить запрос с ОТВ(CTE) и оконными функциями;\n\
     4. Выполнить запрос к метаданным;\n\
     5. Вызвать скалярную функцию(написанную в третьей лабораторной работе);\n\
     6. Вызвать многооператорную или табличную функцию(написанную в третьей лабораторной работе);\n\
     7. Вызвать хранимую процедуру(написанную в третьей лабораторной работе); \n\
     8. Вызвать системную функцию или процедуру; \n\
     9. Создать таблицу в базе данных, соответствующую тематике БД; \n\
    10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY."

    label1 = Label(info, text=info_txt, font="Verdana 14", bg="#b3deff")
    label1.pack()


def window(cur, con):
    global root

    root.title('Лабораторная работа №6')
    root.geometry("800x950")
    root.configure(bg="#b3deff")
    root.resizable(width=False, height=False)

    main_menu = Menu(root)
    root.configure(menu=main_menu)

    third_item = Menu(main_menu, tearoff=0)
    main_menu.add_cascade(label="Техническое задание",
                          menu=third_item, font="Verdana 10")

    third_item.add_command(label="Услования заданий",
                           command=info_show, font="Verdana 12")

    tasks = [task1, task2, task3, task4, task5,
             task6, task7, task8, task9, task10]

    k = 0
    for (index, i) in enumerate(range(15, 300, 65)):
        button = Button(text="Задание " + str(index + 1), width=35, height=2,
                        command=lambda a=index: tasks[a](cur, con),  bg="#7dc4fa")
        button.place(x=70, y=i)

        button = Button(text="Задание " + str(index + 6), width=35, height=2,
                        command=lambda a=index + 5: tasks[a](cur, con),  bg="#7dc4fa")
        button.place(x=420, y=i)  # anchor="center")

    for i in range(10):
        label = Label(text=t[i],  bg="#7dc4fa")
        label.place(x=50, y=350 + 50 * i) # anchor="center")


    root.mainloop()
