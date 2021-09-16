from faker import Faker
from random import randint
from random import uniform
from random import choice, randrange
from datetime import timedelta

from datetime import datetime

MAX_N = 1000

t_tour = ["beach", "excursion", "sports", "quiet", "mobile"]
eat = [1, 2, 3]

cat_hotel = [1, 2, 3, 4, 5]

on_off = [0, 1]
def random_date(start, end):
    delta = end - start
    int_delta = (delta.days * 24 * 60 * 60) + delta.seconds
    random_second = randrange(int_delta)
    return start + timedelta(seconds=random_second)

 


def generate_hotel():
    faker = Faker()
    f = open('hotel.csv', 'w')
    for i in range(MAX_N):
        line = "{0},{1},{2},{3}\n".format(
            faker.name(),
            faker.country(),
            faker.country() + "Region" + str(choice(cat_hotel)),
            choice(cat_hotel))
        f.write(line)
    f.close()


def generate_tours():
    faker = Faker()
    f = open('tour.csv', 'w')
    for i in range(MAX_N):
        week = randint(1, 6)
        hotel = randint(1, 999)

        line = "{0},{1},{2},{3},{4},{5},{6}\n".format(
            faker.name(),
            choice(t_tour),
            faker.country(),
            choice(on_off),
            choice(eat),
            week,
            hotel,
        )
        f.write(line)
    f.close()


def generate_travel_p():
    faker = Faker()
    f = open('travpack.csv', 'w')
    for i in range(MAX_N):
        tour = randint(1, 999)
        oper = randint(1, 999)
        price = randint(1111, 44444)
        n = randint(2, 6)
        s = faker.address()
        s = s.replace('\n', '=')
        d1 = datetime.strptime('1/1/2022 1:30 PM', '%m/%d/%Y %I:%M %p')
        d2 = datetime.strptime('1/1/2023 4:50 AM', '%m/%d/%Y %I:%M %p')
        a = random_date(d1, d2)
        line = "{0},{1},{2},{3},{4}\n".format(
            tour,
            oper,
            a,
            price,
            n
        )
        # print(line)
        f.write(line)
    f.close()


def generate_companies():
    faker = Faker()
    f = open('companies.csv', 'w')
    for i in range(MAX_N):
        s = faker.address()
        s = s.replace('\n', '=')
        line = "{0},{1},{2},{3},{4},{5},{6}\n".format(
            faker.name()[:5],
            faker.city(),
            s,
            faker.phone_number(),
            faker.phone_number()[1:],
            faker.phone_number()[2:8] + "@b.com",
            "Dir " + faker.name(),
        )
        # print(line)
        f.write(line)
    f.close()

if __name__ == "__main__":
    # generate_hotel()
    # generate_tours()
    # generate_companies()
    generate_travel_p()
    faker = Faker()
    s = faker.address()
    print(type(s))
    s = s.replace('\n', '=')
    if '\n' in s:
        print("ererfer")
    print(s)