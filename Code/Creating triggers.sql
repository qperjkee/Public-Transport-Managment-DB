-- Checks whether employee age > 18
DELIMITER //
CREATE TRIGGER birth_date_restriction
BEFORE INSERT ON Employees
FOR EACH ROW
BEGIN
  IF NEW.birth_date > NOW() - INTERVAL 18 YEAR THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Birth date must be at least 18 years ago.';
  END IF;
END//
DELIMITER ;

INSERT INTO Employees (first_name, middle_name, last_name, birth_date, phone_number, email) VALUES 
('Lindon', 'Levensky', 'Becarra', '2018-10-07', '504-243-1295', 'lindonbecarra0@dagondesign.com');

-- Checks whether start date of maintenance < current date and checks whether start date of maintenance < end date of maintenance
DELIMITER //
CREATE TRIGGER maintenance_date_restriction
BEFORE INSERT ON Tehnical_maintenance
FOR EACH ROW
BEGIN
  IF NEW.start_date > NOW() THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Start date must be before the current date.';
  ELSEIF NEW.end_date < NEW.start_date THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'End date must be after the start date.';
  END IF;
END//
DELIMITER ;

INSERT INTO Tehnical_maintenance (vehicle, maintenance_type, start_date, end_date, company, cost) VALUES
(4, 'Routine', '2022-12-05', '2021-01-05', 'Quick Lube', 39.95);

-- Checks whether year of manufacture < current year
DELIMITER //
CREATE TRIGGER manufacture_year_restriction
BEFORE INSERT ON Vehicles
FOR EACH ROW
BEGIN
  IF NEW.manufacture_year > YEAR(NOW()) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Manufacture year must be the current year or earlier.';
  END IF;
END//
DELIMITER ;

INSERT INTO Vehicles(vehicle_type, depot, vehicle_number, manufacture_year, vehicle_condition) VALUES
(1, 1, 101, 2025, 'Brand New');

-- Checks whether date of contract signature < current date and checks whether date of contract signature < end date of contract
DELIMITER //
CREATE TRIGGER contract_dates_restriction
BEFORE INSERT ON Employee_contracts
FOR EACH ROW
BEGIN
  IF NEW.signed_date > NOW() THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Signing date must be before the current date.';
  ELSEIF NEW.date_active_to < NEW.signed_date THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'End date must be after the signing date.';
  END IF;
END //
DELIMITER ;

INSERT INTO Employee_contracts (employee, vehicle, position, salary, signed_date, date_active_to, work_experience)
VALUES
(1, 1, 'Driver', 2800.00, '2022-01-15', '2021-01-15', 5);

-- Checks whether assigning vehicle to route should be repaired
DELIMITER //
CREATE TRIGGER ensure_vehicle_availability
BEFORE INSERT ON Route_vehicles
FOR EACH ROW
BEGIN
  IF (SELECT COUNT(*) FROM Vehicles WHERE vehicle_id = NEW.vehicle_id AND vehicle_condition = 'Need to be fixed') > 0 THEN
    SIGNAL SQLSTATE '45000' 
	  SET MESSAGE_TEXT = 'Cannot assign a vehicle that needs to be repaired to a route.';
  END IF;
END //
DELIMITER ;

INSERT INTO Route_vehicles (route_id, vehicle_id, schedule_id) VALUES
(10, 15, 8);

-- Updating vehcile condition depending on maintenance type
DELIMITER //
CREATE TRIGGER update_vehicle_condition
AFTER UPDATE ON Tehnical_maintenance
FOR EACH ROW
BEGIN
  IF NEW.maintenance_type = 'Major' THEN
    UPDATE Vehicles SET vehicle_condition = 'Brand New' WHERE vehicle_id = NEW.vehicle;
  ELSEIF NEW.maintenance_type = 'Repair' THEN
    UPDATE Vehicles SET vehicle_condition = 'Average' WHERE vehicle_id = NEW.vehicle;
  END IF;
END //
DELIMITER ;

UPDATE tehnical_maintenance
SET maintenance_type = 'Major'
WHERE maintenance_id = 7;

-- Updatign employee salary by increasing it by 15% if employee has work experience 5 years or more
DELIMITER //
CREATE TRIGGER salary_increase_for_experience
BEFORE UPDATE ON Employee_contracts
FOR EACH ROW
BEGIN
  IF NEW.work_experience >= 5 AND NEW.work_experience >= OLD.work_experience THEN
    SET NEW.salary = NEW.salary * 1.15; 
  END IF;
END //
DELIMITER ;

UPDATE employee_contracts
SET work_experience = 6
WHERE contract_id = 1;
