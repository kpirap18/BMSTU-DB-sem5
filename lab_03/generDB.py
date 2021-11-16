from faker import Faker
from random import choice, randrange, randint, uniform
from datetime import timedelta, datetime

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

hotels = list()
# hotels.append(1)
def generate_hotel():
    faker = Faker()
    f = open('hotel.csv', 'w')
    for i in range(MAX_N):
        country = randint(1, 239)
        line = "{0};{1};{2};{3}\n".format(
            faker.name(),
            country,
            faker.country() + "Region" + str(choice(cat_hotel)),
            choice(cat_hotel)
        )
        hotels.append(country)
        f.write(line)
    f.close()
print(len(hotels))

def generate_tours():
    faker = Faker()
    f = open('tour.csv', 'w')
    for i in range(MAX_N):
        week = randint(1, 6)
        hotel = randint(1, 999)
        country = randint(1, 239)
        print(hotel)
        line = "{0};{1};{2};{3};{4};{5};{6}\n".format(
            faker.name(),
            choice(t_tour),
            hotels[hotel - 1],
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
        price = randint(500, 1200)
        n = randint(2, 6)
        s = faker.address()
        s = s.replace('\n', '=')
        d1 = datetime.strptime('1/1/2022 1:30 PM', '%m/%d/%Y %I:%M %p')
        d2 = datetime.strptime('1/1/2023 4:50 AM', '%m/%d/%Y %I:%M %p')
        a = random_date(d1, d2)
        line = "{0};{1};{2};{3};{4}\n".format(
            tour,
            oper,
            a,
            price * n,
            n
        )
        f.write(line)
    f.close()

mail = ["@yandex.ru", "@mail.ru", "@gmail.com", "@bk.ru", "@m.ru"]
def generate_companies():
    faker = Faker()
    f = open('companies.csv', 'w')
    for i in range(MAX_N):
        s = faker.address()
        s = s.replace('\n', '=')
        phone = randint(10000000000, 99999999999)
        fax = randint(10000000000, 99999999999)
        line = "{0};{1};{2};{3};{4};{5};{6}\n".format(
            "Com" + faker.name()[:5],
            faker.city(),
            s,
            phone,
            fax,
            faker.phone_number()[2:8] + choice(mail),
            "Dir " + faker.name(),
        )
        f.write(line)
    f.close()

test = list()
def generate_fortest():
    faker = Faker()
    f = open('test.csv', 'w')
    for i in range(5):
        country = randint(1, 5)
        line = "{0};{1};{2}\n".format(
            faker.name(),
            country,
            faker.country(),
        )
        f.write(line)
    f.close()


if __name__ == "__main__":
    generate_fortest()
    # generate_hotel()
    # generate_tours()
    # generate_companies()
    # generate_travel_p()
