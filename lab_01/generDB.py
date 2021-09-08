from faker import Faker
from random import randint
from random import uniform
from random import choice

MAX_N = 1000

t_tour = ["beach", "excursion", "sports", "quiet", "mobile"]
eat = [1, 2, 3]

cat_hotel = [1, 2, 3, 4, 5]

on_off = [0, 1]


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
    pass


def generate_companies():
    faker = Faker()
    f = open('companies.csv', 'w')
    for i in range(MAX_N):
        week = randint(1, 6)
        hotel = randint(1, 999)

        line = "{0},{1},{2},{3},{4},{5}\n".format(
            faker.name()[:5],
            faker.city(),
            faker.address(),
            faker.phone_number(),
            faker.phone_number()[1:],
            faker.phone_number()[2:8] + "@b.com",
            "Dir " + faker.name(),
        )
        f.write(line)
    f.close()

if __name__ == "__main__":
    generate_hotel()
    generate_tours()