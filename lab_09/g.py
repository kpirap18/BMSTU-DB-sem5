import matplotlib.pyplot as plt

mode = 3

# Без изменения данных


index = ["БД", "Redis"]
values = [1.4865636825561523e-05, 3.901481628417969e-06]
plt.bar(index,values)
plt.title("Без изменения данных")
plt.show()

# При добавлении новых строк каждые 10 секунд

index = ["БД", "Redis"]
values = [8.021593093872071e-06, 1.879596710205078e-05]
plt.bar(index,values)
plt.title("При добавлении новых строк каждые 10 секунд")
plt.show()


# При удалении строк каждые 10 секунд

index = ["БД", "Redis"]
values = [1.213860511779785e-05, 1.6412734985351563e-05]
plt.bar(index,values)
plt.title("При удалении строк каждые 10 секунд")
plt.show()


# При изменении строк каждые 10 секунд

index = ["БД", "Redis"]
values = [1.418161392211914e-05, 2.2530317306518554e-05]
plt.bar(index,values)
plt.title("При изменении строк каждые 10 секунд")
plt.show()


