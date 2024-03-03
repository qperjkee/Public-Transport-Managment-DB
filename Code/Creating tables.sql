CREATE DATABASE public_transport_routes;

USE public_transport_routes;

CREATE TABLE Vehicles_types(
type_id INT PRIMARY KEY AUTO_INCREMENT,
type_name VARCHAR(50) CHECK (type_name IN ('Metro', 'Bus', 'Tram', 'Trolleybus', 'Minibus', 'Express Tram')),
capacity INT CHECK (capacity > 0)
);

CREATE TABLE Stops_types(
type_id INT PRIMARY KEY AUTO_INCREMENT,
type_name VARCHAR(50) CHECK (type_name IN ('Metro Station', 'Express Tram Stop', 'Tram Stop', 'Public Transit')),
passangers_count INT CHECK(passangers_count > 0),
area INT CHECK(area > 0),
location VARCHAR(50) NOT NULL
);

CREATE TABLE Employees(
employee_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30)NOT NULL,
middle_name VARCHAR(30),
last_name VARCHAR(30)NOT NULL,
birth_date DATE,
phone_number VARCHAR(20) UNIQUE NOT NULL,
email VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE Depots(
depot_id INT PRIMARY KEY AUTO_INCREMENT,
depot_name VARCHAR(50),
location VARCHAR(40),
capacity INT CHECK (capacity > 0),
depot_condition VARCHAR(30) CHECK (depot_condition IN ('Good', 'Average', 'Poor'))
);

CREATE TABLE Routes(
route_id INT PRIMARY KEY AUTO_INCREMENT,
route_number INT,
length INT CHECK(length > 0),
duration TIME NOT NULL
);

CREATE TABLE Vehicles(
vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
vehicle_type INT,
depot INT,
vehicle_number INT NOT NULL UNIQUE,
manufacture_year YEAR,
vehicle_condition VARCHAR(17) CHECK (vehicle_condition IN ('Brand New', 'Average', 'Need to be fixed')),
FOREIGN KEY(vehicle_type) REFERENCES Vehicles_types(type_id),
FOREIGN KEY(depot) REFERENCES Depots(depot_id)
);

CREATE TABLE Tehnical_maintenance(
maintenance_id INT PRIMARY KEY AUTO_INCREMENT,
vehicle INT,
maintenance_type VARCHAR(30) CHECK (maintenance_type IN ('Routine', 'Repair', 'Major')),
start_date DATE,
end_date DATE,
company VARCHAR(40),
cost DECIMAL(10,2) CHECK(cost > 0),
FOREIGN KEY(vehicle) REFERENCES Vehicles(vehicle_id)
);

CREATE TABLE Employee_contracts(
contract_id INT PRIMARY KEY AUTO_INCREMENT,	
employee INT,
vehicle INT,
position VARCHAR(30) CHECK (position IN ('Manager', 'Engineer', 'Technician', 'Driver')),
salary DECIMAL(10,2) CHECK(salary > 0),
signed_date DATE,
date_active_to DATE,
work_experience TINYINT UNSIGNED,
FOREIGN KEY(employee) REFERENCES Employees(employee_id),
FOREIGN KEY(vehicle) REFERENCES Vehicles(vehicle_id)
);

CREATE TABLE Schedules(
schedule_id INT PRIMARY KEY AUTO_INCREMENT,
start_time TIME,
end_time TIME,
frequency TIME CHECK(frequency > '00:00:00'),
stop_waiting_time TIME CHECK(stop_waiting_time > '00:00:00' AND stop_waiting_time < '00:10:00'),
week_days VARCHAR(20) CHECK (week_days IN ('Weekends', 'Week', 'Working days'))
);

CREATE TABLE Route_vehicles(
route_vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
route_id INT,
vehicle_id INT,
schedule_id INT,
FOREIGN KEY(route_id) REFERENCES Routes(route_id),
FOREIGN KEY(vehicle_id) REFERENCES Vehicles(vehicle_id),
FOREIGN KEY(schedule_id) REFERENCES Schedules(schedule_id)
);

CREATE TABLE Stops(
stop_id INT PRIMARY KEY AUTO_INCREMENT,
stop_type INT,
stop_name VARCHAR(30) NOT NULL UNIQUE,
stop_address VARCHAR(30) NOT NULL,
FOREIGN KEY(stop_type) REFERENCES Stops_types(type_id)
);

CREATE TABLE Route_stops(
route_stop_id INT PRIMARY KEY AUTO_INCREMENT,
route_id INT,
stop_id INT,
stop_type VARCHAR(30) CHECK (stop_type IN ('Starting', 'Mid', 'Ending')),
FOREIGN KEY(route_id) REFERENCES Routes(route_id),
FOREIGN KEY(stop_id) REFERENCES Stops(stop_id)
);
