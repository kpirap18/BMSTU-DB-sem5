

from faker import Faker
from random import randint, choice
import datetime
import time
import json


class hotel():
	# Структура полностью соответствует таблице device.
	id = int()
	namehotel = str()
	cityd = int()
	region = str()
	categoryid = int()

	def __init__(self, id, namehotel, cityd, region, categoryid):
		self.id = id
		self.namehotel = namehotel
		self.cityd = cityd
		self.region = region
		self.categoryid = categoryid

	def get(self):
		return {'id': self.id, 'namehotel': self.namehotel, 'cityd': self.cityd,
				'region': self.region, 'categoryid': self.categoryid}

	def __str__(self):
		return f"{self.id:<2} {self.namehotel:<20} {self.cityd:<5} {self.region:<5} {self.categoryid:<15}"



def main():
	faker = Faker()  # faker.name()
	i = 0


	while True:
		obj = hotel(i, faker.name(), randint(1, 999), faker.country() + "Region", randint(1, 5))
		
		# print(obj)
		# print(json.dumps(obj.get()))
		
		file_name = "hotel_" + str(i) + "_" + \
			str(datetime.datetime.now().strftime("%d_%m_%Y_%H_%M_%S")) + ".json"

		print(file_name)
		
		with open(file_name, "w") as f:
			print(json.dumps(obj.get()), file=f)

		i += 1
		time.sleep(10)


if __name__ == "__main__":
	main()