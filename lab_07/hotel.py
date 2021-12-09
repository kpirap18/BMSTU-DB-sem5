class hotel():
    # Структура полностью соответствует таблице hotel
    id = int()
    namehotel = str()
    countryid = int()
    region = str()
    categoryid = int()

    def __init__(self, id, namehotel, countryid, region, categoryid):
        self.id = id
        self.namehotel = namehotel
        self.countryid = countryid
        self.region = region
        self.categoryid = categoryid

    def get(self):
        return {'id': self.id, 'namehotel': self.namehotel, 'countryid': self.countryid,
                'region': self.region, 'categoryid': self.categoryid}

    def __str__(self):
        return f"{self.id:<2} {self.namehotel:<20} {self.countryid:<5} {self.region:<5} {self.categoryid:<15}"



def create_hotels(file_name):
    # Содает коллекцию объектов.
    # Загружая туда данные из файла file_name.
    file = open(file_name, 'r')
    hotels = list()

    for line in file:
        arr = line.split(',')
        arr[0], arr[2], arr[4] = int(
            arr[0]), int(arr[2]), int(arr[4])
        hotels.append(hotel(*arr).get())

    return hotels

class country():
    # Структура полностью соответствует таблице hotel
    id = int()
    namecountry = str()

    def __init__(self, id, namecountry):
        self.id = id
        self.namecountry = namecountry

    def get(self):
        return {'id': self.id, 'name': self.namecountry}

    def __str__(self):
        return f"{self.id:<2} {self.namecountry:<20}"


def create_country(file_name):
    # Содает коллекцию объектов.
    # Загружая туда данные из файла file_name.
    file = open(file_name, 'r')
    counties = list()
    k = 0
    for line in file:
        arr = [0, 0]
        arr[1] = line
        arr[0] = int(k)
        k += 1
        counties.append(country(*arr).get())
    
    return counties