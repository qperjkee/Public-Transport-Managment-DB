-- Getting contracts by pos  
DELIMITER //
CREATE PROCEDURE GetEmployeeContractsByPosition(IN pos VARCHAR(30))
BEGIN
    SELECT contract_id, CONCAT(emp.first_name, ' ', emp.middle_name, ' ', emp.last_name) AS full_name, emp.birth_date, emp.phone_number,
    vehicle, position, salary, signed_date, date_active_to, work_experience
    FROM Employee_contracts
    JOIN employees emp ON emp.employee_id = Employee_contracts.employee
    WHERE position = pos;
END//
DELIMITER ;

CALL GetEmployeeContractsByPosition('Manager');

-- Getting Vehicles that are currently in maintenance
DELIMITER //
CREATE PROCEDURE GetVehiclesInMaintenance()
BEGIN
    SELECT veh.vehicle_number, veh.manufacture_year, vt.type_name, maintenance_type, start_date, end_date, company, cost
    FROM Tehnical_maintenance
    JOIN vehicles veh ON veh.vehicle_id = Tehnical_maintenance.vehicle
    JOIN vehicles_types vt ON vt.type_id = veh.vehicle_type
    WHERE end_date > curdate();
END//
DELIMITER ;

CALL GetVehiclesInMaintenance();

-- Calculating Max passanger amount of route
DELIMITER //
CREATE FUNCTION CalculateRouteMaxPassangerAmount(rout INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_capacity INT;

    SELECT SUM(st.passangers_count) INTO total_capacity
    FROM Routes AS r
    JOIN Route_stops AS rs ON r.route_id = rs.route_id
    JOIN Stops AS s ON rs.stop_id = s.stop_id
    JOIN Stops_types AS st ON s.stop_type = st.type_id
    WHERE r.route_id = rout;

    RETURN total_capacity;
END//
DELIMITER ;

SELECT CalculateRouteMaxPassangerAmount(2) AS Total_passanger_amount;

-- Get routes info that goes through direct stop
DELIMITER //
CREATE PROCEDURE GetRoutesByStop(IN st_id INT)
BEGIN
    SELECT Routes.route_id, Routes.route_number, Routes.length, Routes.duration
    FROM Routes
    JOIN Route_stops ON Routes.route_id = Route_stops.route_id
    WHERE Route_stops.stop_id = st_id;
END//
DELIMITER ;

CALL GetRoutesByStop(10);

-- Get vehicles maintenance history
DELIMITER //
CREATE PROCEDURE GetVehicleMaintenanceHistory(IN veh_id INT)
BEGIN
	SELECT veh.vehicle_number, vt.type_name, maintenance_type, start_date, end_date, company, cost
    FROM Tehnical_maintenance
    JOIN vehicles veh ON veh.vehicle_id = Tehnical_maintenance.vehicle
    JOIN vehicles_types vt ON vt.type_id = veh.vehicle_type
    WHERE vehicle_id = veh_id;
END//
DELIMITER ;

CALL GetVehicleMaintenanceHistory(1);

-- Get maintenance report of direct year and month
DELIMITER //
CREATE PROCEDURE GenerateMonthlyMaintenanceReport(IN year_ VARCHAR(4), IN month_ VARCHAR(2))
BEGIN
    SELECT year_ AS maintenance_year, month_ AS maintenance_month, SUM(cost) AS total_cost, COUNT(*) AS number_of_vehicles, COUNT(DISTINCT maintenance_type) AS number_of_types
    FROM ( SELECT year_, month_, vehicle, maintenance_type, cost
			FROM Tehnical_maintenance
			WHERE MONTH(start_date) = month_
            AND YEAR(start_date) = year_
    ) AS maintenance_records
    GROUP BY year_, month_;
END//
DELIMITER ;

CALL GenerateMonthlyMaintenanceReport('2023', '12');

-- Getting employees contracts by employee id
DELIMITER //
CREATE PROCEDURE GetEmployeeContracts(IN emp_id INT)
BEGIN
	SELECT contract_id, CONCAT(emp.first_name, ' ', emp.middle_name, ' ', emp.last_name) AS full_name, emp.birth_date, emp.phone_number, emp.email,
    vehicle, position, salary, signed_date, date_active_to, work_experience
    FROM Employee_contracts
    JOIN employees emp ON emp.employee_id = Employee_contracts.employee
    WHERE employee_id = emp_id;
END //
DELIMITER ;

CALL GetEmployeeContracts(32);

-- Get depots avaliable amount of capacity
DELIMITER //
CREATE FUNCTION GetDepotCapacity(dep_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_vehicles INT;
	DECLARE depot_capacity INT;

    SELECT COUNT(*) INTO total_vehicles
    FROM Vehicles
    WHERE depot = dep_id;

    SELECT capacity INTO depot_capacity
    FROM Depots
    WHERE depot_id = dep_id;

    RETURN depot_capacity - total_vehicles;
END //
DELIMITER ;

SELECT GetDepotCapacity(2) AS Capacity_amount;

-- Update Contract Info of employee
DELIMITER //
CREATE PROCEDURE UpdateEmployeeContractInformation(IN employee_id INT, IN new_position VARCHAR(30), IN new_salary DECIMAL(10,2), IN new_date_active_to DATE, IN new_work_experience TINYINT UNSIGNED)
BEGIN
    UPDATE Employee_contracts
    SET salary = new_salary,
		position = new_position,
        work_experience = new_work_experience,
        date_active_to = new_date_active_to
    WHERE employee = employee_id;
END //
DELIMITER ;

CALL UpdateEmployeeContractInformation(1, 'Driver', 4300.00, '2025-07-13', 2);

-- Udpate Contact ino of employee
DELIMITER //
CREATE PROCEDURE UpdateEmployeeContactInformation(IN empl_id INT, IN new_phone_number VARCHAR(20), new_email VARCHAR(30))
BEGIN
    UPDATE Employees
    SET phone_number = new_phone_number,
		email = new_email
    WHERE employee_id = empl_id;
END //
DELIMITER ;

CALL UpdateEmployeeContactInformation(1, '782-543-981', 'jovanisad@gmail.com');

-- Adjust Schedule Time Forward
DELIMITER //
CREATE PROCEDURE AdjustScheduleTimeForward(IN sched_id INT,IN hours INT, IN minutes INT)
BEGIN
    DECLARE new_start_time TIME;
	DECLARE new_end_time TIME;

    SELECT start_time, end_time
    INTO new_start_time, new_end_time
    FROM Schedules
    WHERE schedule_id = sched_id;

    UPDATE Schedules
    SET start_time = new_start_time + INTERVAL hours HOUR + INTERVAL minutes MINUTE,
        end_time = new_end_time + INTERVAL hours HOUR + INTERVAL minutes MINUTE
    WHERE schedule_id = sched_id;
END //
DELIMITER ;

CALL AdjustScheduleTimeForward(25, 1, 10);

-- Adjust Schedule Time Backward
DELIMITER //
CREATE PROCEDURE AdjustScheduleTimeBackward(IN sched_id INT, IN hours INT, IN minutes INT)
BEGIN
  DECLARE new_start_time TIME;
  DECLARE new_end_time TIME;

  SELECT start_time, end_time
  INTO new_start_time, new_end_time
  FROM Schedules
  WHERE schedule_id = sched_id;

  UPDATE Schedules
  SET start_time = new_start_time - INTERVAL hours HOUR - INTERVAL minutes MINUTE,
      end_time = new_end_time - INTERVAL hours HOUR - INTERVAL minutes MINUTE
  WHERE schedule_id = sched_id;
END //
DELIMITER ; 

CALL AdjustScheduleTimeBackward(8, 1, 0);