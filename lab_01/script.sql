CREATE DATABASE travelpackages;
CREATE SCHEMA Location1;
CREATE SCHEMA Packages;

CREATE TABLE IF NOT EXISTS Location1.Countries(
    CountryId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NameCountry VARCHAR(100) NOT NULL 
);

--copy location1.countries(namecountry) from '/home/kpirap18/db1/lab_01/country.csv' delimiter ';';
--select * from location1.countries

CREATE TABLE IF NOT EXISTS Packages.CategoryHotel(
    CategoryId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TypeCategory VARCHAR(100) NOT NULL
);

--copy Packages.CategoryHotel(TypeCategory) from '/home/kpirap18/db1/lab_01/cathotel.csv' delimiter ';';
--select * from packages.categoryhotel


CREATE TABLE IF NOT EXISTS Packages.Hotels(
    HotelId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NameHotel VARCHAR(100) NOT NULL,
    CountryId INT NOT NULL CHECK (CountryId >= 1 AND CountryId <= 999),
    Region VARCHAR(100) NOT NULL,
    CategoryId  INT NOT NULL CHECK (CategoryId >= 1 AND CategoryId <= 5)
    FOREIGN KEY (CountryId) REFERENCES Location1.Countries(CountryId),
    FOREIGN KEY (CategoryId) REFERENCES Packages.CategoryHotel(CategoryId)
);

--copy Packages.Hotels(NameHotel, CountryId, Region, CategoryId) from '/home/kpirap18/db1/lab_01/hotel.csv' delimiter ';';
--select * from packages.hotels 


CREATE TABLE IF NOT EXISTS Packages.Tours(
    TourId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	NameTour VARCHAR(100) NOT NULL,
	TypeTour VARCHAR(100) NOT NULL,
	CountryId INT NOT NULL CHECK (CountryId >= 1 AND CountryId <= 999),
	TravelOnOff INT NOT NULL CHECK (TravelOnOff = 1 OR TravelOnOff = 0),
    PowerSupply INT NOT NULL,
    Duration INT NOT NULL,
    HotelId INT NOT NULL CHECK (HotelId >= 1 AND HotelId <= 999),
    FOREIGN KEY (CountryId) REFERENCES Location1.Countries(CountryId),
    FOREIGN KEY (HotelId) REFERENCES Packages.Hotels(HotelId)
);

--copy Packages.Tours(NameTour, TypeTour, CountryId, TravelOnOff, PowerSupply, Duration, HotelId) from '/home/kpirap18/db1/lab_01/tour.csv' delimiter ';';
--select * from packages.tours


CREATE TABLE IF NOT EXISTS Packages.Companies(
    CompanyId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	NameCompany VARCHAR(100) NOT NULL,
	City VARCHAR(100) NOT NULL,
	AddressCom VARCHAR(100) NOT NULL,
	Phone VARCHAR(15) NOT NULL,
    Fax VARCHAR(15) NULL,
    Email VARCHAR(100) NULL,
    Director VARCHAR(100) NOT NULL
);

--copy Packages.Companies(NameCompany, City, AddressCom, Phone, Fax, Email, Director) from '/home/kpirap18/db1/lab_01/companies.csv' delimiter ';';
--select * from packages.companies 


CREATE TABLE IF NOT EXISTS Packages.TrPackages(
    TrPackagesId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	TourId INT NOT NULL CHECK (TourId >= 1 AND TourId <= 999),
	CompanyId INT NOT NULL CHECK (TourId >= 1 AND TourId <= 999),
	DataDis DATE NOT NULL,
	Price INT CHECK (Price >= 0),
    NumberPeople INT NULL CHECK (NumberPeople >= 1),
    FOREIGN KEY (TourId) REFERENCES Packages.Tours(TourId),
    FOREIGN KEY (CompanyId) REFERENCES Packages.Companies(CompanyId)
);

--copy Packages.TrPackages(TourId, CompanyId, DataDis, Price, NumberPeople) from '/home/kpirap18/db1/lab_01/travpack.csv' delimiter ';';
--select * from packages.trpackages


