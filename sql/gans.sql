DROP DATABASE IF EXISTS gans;
CREATE DATABASE gans;
USE gans;

CREATE TABLE cities (
    city_id    INT AUTO_INCREMENT,
    city_name  VARCHAR(255) NOT NULL,
    country    VARCHAR(255),
    latitude   DECIMAL(9,6),
    longitude  DECIMAL(9,6),
    PRIMARY KEY (city_id)
);

CREATE TABLE populations (
    population_id        INT AUTO_INCREMENT,
    city_id              INT NOT NULL,
    population           INT,
    year_data_retrieved  INT,
    PRIMARY KEY (population_id),
    FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

CREATE TABLE weathers (
    id             INT AUTO_INCREMENT,
    city_id        INT NOT NULL,
    forecast_time  DATETIME,
    outlook        VARCHAR(200),
    temperature    DECIMAL(5,2),
    feels_like     DECIMAL(5,2),
    wind_speed     DECIMAL(5,2),
    rain_prob      DECIMAL(4,2),
    PRIMARY KEY (id),
    FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

CREATE TABLE airports (
    airport_icao  VARCHAR(5),
    airport_name  VARCHAR(255),
    PRIMARY KEY (airport_icao)
);

CREATE TABLE cities_airports (
    city_id       INT,
    airport_icao  VARCHAR(5),
    PRIMARY KEY (city_id, airport_icao),
    FOREIGN KEY (city_id) REFERENCES cities(city_id),
    FOREIGN KEY (airport_icao) REFERENCES airports(airport_icao)
);

CREATE TABLE flights (
    flight_id       INT AUTO_INCREMENT,
    flight_num      VARCHAR(25),
    departure_icao  VARCHAR(25),
    arrival_icao    VARCHAR(25),
    arrival_time    DATETIME,
    PRIMARY KEY (flight_id),
    FOREIGN KEY (arrival_icao) REFERENCES airports(airport_icao)
);