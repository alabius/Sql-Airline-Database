-- SQL TO CREATE AIRLINE TABLE

CREATE TABLE airline(
	AirlineID INTEGER PRIMARY KEY,
	AirlineName VARCHAR(20)
);

-- SQL TO CREATE COUNTRY TABLE

CREATE TABLE country(
	CountryID INTEGER PRIMARY KEY,
	CountryName CHAR(50)
);

-- SQL TO CREATE PASSENGER TABLE

CREATE TABLE passenger(
	PassengerID INTEGER PRIMARY KEY,
	PassengerFirstName CHAR(20),
	PassengerLastName CHAR(20)
);

-- SQL TO CREATE AIRLINECLASS TABLE

CREATE TABLE airlineClass(
  AirlineClassID INTEGER PRIMARY KEY,
  AirlineID INTEGER,
  EconomyClassMinPrice INTEGER,
  EconomyClassMaxPrice INTEGER,
  BusinessClassMinPrice INTEGER,
  BusinessClassMaxPrice INTEGER,
  FirstClassMinPrice INTEGER,
  FirstClassMaxPrice INTEGER,
  FOREIGN KEY(AirlineID) REFERENCES Airline(AirlineID)
);

-- SQL TO CREATE TICKET TABLE

CREATE TABLE ticket(
  TicketID INTEGER PRIMARY KEY,
  AirlineID INTEGER,
  PassengerID INTEGER,
  TicketDate TEXT(11),
  TicketPrice INTEGER,
  TicketVolume INTEGER,
  DestinationCountry INTEGER,
  ExitCountry INTEGER,
	CONSTRAINT diff_Destination_Exit_Country CHECK(DestinationCountry != ExitCountry),
  FOREIGN KEY(AirlineID) REFERENCES Airline(AirlineID),
  FOREIGN KEY(PassengerID) REFERENCES Passenger(PassengerID),
  FOREIGN KEY(ExitCountry) REFERENCES  	Country(CountryID),
  FOREIGN KEY(DestinationCountry) REFERENCES 	Country(CountryID)
);
