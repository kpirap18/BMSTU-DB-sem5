USE TravelPackages;

CREATE TABLE IF NOT EXISTS Location1.Countries(
    CountryId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NameCountry VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Packages.CategoryHotel(
    CategoryId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TypeCategory VARCHAR(100) NOT NULL
);
 

CREATE TABLE IF NOT EXISTS Packages.Hotels(
    HotelId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NameHotel VARCHAR(100) NOT NULL,
    CountryId INT NOT NULL,
    Region VARCHAR(100) NOT NULL,
    CategoryId  INT NOT NULL,
    FOREIGN KEY (CountryId) REFERENCES Location.Countries(CountryId),
    FOREIGN KEY (CategoryId) REFERENCES Packages.CategoryHotel(CategoryId)
);

CREATE TABLE IF NOT EXISTS Packages.Tours(
    TourId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	NameTour VARCHAR(100) NOT NULL,
	TypeTour VARCHAR(100) NOT NULL,
	CountryId INT NOT NULL,
	TravelOnOff INT NOT NULL,
    PowerSupply INT NOT NULL,
    Duration INT NOT NULL,
    HotelId INT NOT NULL,
    FOREIGN KEY (CountryId) REFERENCES Location.Countries(CountryId),
    FOREIGN KEY (HotelId) REFERENCES Packages.Hotels(HotelId)
);

CREATE TABLE IF NOT EXISTS Packages.Companies(
    CompanyId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	NameCompany VARCHAR(100) NOT NULL,
	City VARCHAR(100) NOT NULL,
	AddressCom VARCHAR(100) NOT NULL,
	Phone VARCHAR(20) NOT NULL,
    Fax INT NULL,
    Email VARCHAR(100) NULL,
    Director VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Packages.TrPackages(
    TrPackagesId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	TourId INT NOT NULL,
	CompanyId INT NOT NULL,
	DataDis DATE NOT NULL,
	Price INT CHECK (Price >= 0),
    NumberPeople INT NULL,
    FOREIGN KEY (TourId) REFERENCES Packages.Tours(TourId),
    FOREIGN KEY (CompanyId) REFERENCES Packages.Companies(CompanyId)

);

copy location1.countries(namecountry) from '/home/kpirap18/db1/lab_01/country.csv' delimiter ';';
copy Packages.CategoryHotel(TypeCategory) from '/home/kpirap18/db1/lab_01/cathotel.csv' delimiter ';';
copy Packages.Companies(NameCompany, City, AddressCom, Phone, Fax, Email, Director) from '/home/kpirap18/db1/lab_01/companies.csv' delimiter ';';
copy Packages.Hotels(NameHotel, CountryId, Region, CategoryId) from '/home/kpirap18/db1/lab_01/hotel.csv' delimiter ',';
copy Packages.Tours(NameTour, TypeTour, CountryId, TravelOnOff, PowerSupply, Duration, HotelId) from '/home/kpirap18/db1/lab_01/tour.csv' delimiter ';';
copy Packages.TrPackages(TourId, CompanyId, DataDis, Price, NumberPeople) from '/home/kpirap18/db1/lab_01/travpack.csv' delimiter ';';




