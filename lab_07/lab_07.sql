CREATE TABLE IF NOT EXISTS hotels_json
(
    doc JSON
);

COPY
(
	SELECT row_to_json(c) RESULT FROM packages.hotels  c
)
TO '/home/kpirap18/sem5/db/lab_07/hotel.json';

SELECT * FROM packages.hotels


COPY hotels_json FROM '/home/kpirap18/sem5/db/lab_07/hotel.json';

SELECT * FROM hotels_json;

-- потом все в таблицу 
INSERT INTO hotel_json (NameCompany, City, AddressCom, Phone, Fax, Email, Director)
SELECT doc->>'namehotel', doc->>'countryid', doc->>'region', doc->>'categoryid' FROM hotels_import;

SELECT * FROM companies_copy;









CREATE TABLE Cities(
    CityId  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NameCity VARCHAR(100) NOT NULL,
    CountryId INT NOT NULL
);

copy cities(NameCity, CountryId) from '/home/kpirap18/sem5/db/lab_01/country.csv' delimiter ';';
select * from cities

CREATE TABLE IF NOT EXISTS CategoryHotel(
    CategoryId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TypeCategory VARCHAR(100) NOT NULL
);

copy CategoryHotel(TypeCategory) from '/home/kpirap18/sem5/db/lab_01/cathotel.csv' delimiter ';';
select * from categoryhotel

CREATE TABLE IF NOT EXISTS Hotels(
    HotelId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NameHotel VARCHAR(100) NOT NULL,
    CountryId INT NOT NULL CHECK (CountryId >= 1 AND CountryId <= 999),
    Region VARCHAR(100) NOT NULL,
    CategoryId  INT NOT NULL CHECK (CategoryId >= 1 AND CategoryId <= 5)
);

copy Hotels(NameHotel, Cityd, Region, CategoryId) from '/home/kpirap18/sem5/db/lab_01/hotel.csv' delimiter ';';
select * from hotels 


SELECT change_star(2,3)




alter table packages.hotels drop constraint hotels_countryid_fkey







