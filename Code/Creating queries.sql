-- Get info about employees that have email at gmail
SELECT CONCAT(emp.first_name, ' ', emp.middle_name, ' ', emp.last_name) AS full_name, emp.phone_number, emp.email, position, salary, signed_date, date_active_to, work_experience
FROM employee_contracts
JOIN employees emp ON emp.employee_id = employee_contracts.employee
WHERE emp.email LIKE '%gmail%';

-- Get info about employees and vehicles that have vehicle associated with them
SELECT CONCAT(first_name, ' ', middle_name, ' ', last_name) AS full_name, phone_number, email, ec.position, veh.vehicle_number, veh.vehicle_condition, vt.type_name
FROM Employees
JOIN Employee_contracts ec ON Employees.employee_id = ec.employee
JOIN Vehicles veh ON ec.vehicle = veh.vehicle_id
JOIN Vehicles_types vt ON vt.type_id = veh.vehicle_type;

-- Get All info about vehicles and their types ordered by manufacture year
SELECT vehicle_number, manufacture_year, vehicle_condition, Vehicles_types.type_name
FROM Vehicles
JOIN Vehicles_types ON Vehicles.vehicle_type = Vehicles_types.type_id
ORDER BY manufacture_year;

-- Get info about terms and cost of tehnical maintenance that had vehicles with "Average" condition
SELECT vehicle_number, tm.start_date, tm.end_date, tm.cost, tm.company
FROM Vehicles
JOIN Tehnical_maintenance tm ON Vehicles.vehicle_id = tm.vehicle
WHERE vehicle_condition = 'Average';

-- Get total amount of money spend on vehicles that had tehnical maintenance
SELECT Vehicles.vehicle_number, manufacture_year, SUM(Tehnical_maintenance.cost) AS total_maintenance_cost
FROM Vehicles
JOIN Tehnical_maintenance ON Vehicles.vehicle_id = Tehnical_maintenance.vehicle
GROUP BY Vehicles.vehicle_id
ORDER BY total_maintenance_cost DESC;

-- Get vehicles that stores in depots with "Good" condition
SELECT veh.vehicle_number, veh.manufacture_year, depot_name, location, depot_condition
FROM depots
JOIN vehicles veh ON veh.depot = depots.depot_id
WHERE depot_condition = 'Good';

-- Get amount of vehicles in each depot
SELECT depot_id, depot_name, COUNT(veh.vehicle_id) AS vehicle_count
FROM depots
LEFT JOIN vehicles veh ON depots.depot_id = veh.depot
GROUP BY depot_id
ORDER BY vehicle_count DESC;

-- Get all info about vehicles and depots they are stored in, ordered by depot name
SELECT vehicle_number, manufacture_year, vehicle_condition, Vehicles_types.type_name, dep.depot_name, dep.location AS depot_location, dep.depot_condition
FROM Vehicles
JOIN Vehicles_types ON Vehicles.vehicle_type = Vehicles_types.type_id
JOIN Depots dep ON dep.depot_id = Vehicles.depot
ORDER BY dep.depot_name;

-- Find routes that are served by vehicles that were manufactured in certain year
SELECT route_number, length, duration, veh.vehicle_number, veh.manufacture_year
FROM Routes
JOIN Route_vehicles rv ON rv.route_id = Routes.route_id
JOIN Vehicles veh ON veh.vehicle_id = rv.vehicle_id
WHERE veh.manufacture_year = 2020;

-- Get all info about routes number and vehicle numbers with schedule days - "Weekends"
SELECT rt.route_number, veh.vehicle_number, veh.vehicle_condition, start_time, end_time, frequency, stop_waiting_time, week_days
FROM Schedules
JOIN Route_vehicles rv ON rv.schedule_id = Schedules.schedule_id
JOIN Routes rt ON rt.route_id = rv.route_id
JOIN Vehicles veh ON veh.vehicle_id = rv.vehicle_id
WHERE week_days = 'Weekends';

-- Get info about employees that have salary between 2100 and 3000 descending order
SELECT CONCAT(emp.first_name, ' ', emp.middle_name, ' ', emp.last_name) AS full_name, emp.phone_number, emp.email position, salary, signed_date, date_active_to, work_experience
FROM employee_contracts
JOIN employees emp ON emp.employee_id = employee_contracts.employee
WHERE salary BETWEEN 2100 AND 3000
ORDER BY salary DESC;

-- Find amount of vehicles for each vehicle type
SELECT type_name, COUNT(*) AS vehicle_count
FROM Vehicles
JOIN Vehicles_types ON vehicle_type = type_id
GROUP BY type_id
ORDER BY vehicle_count DESC;

-- Get all info about vehicles that have not undergone any maintenance
SELECT vehicle_id, vehicle_number, manufacture_year, vehicle_condition
FROM Vehicles
LEFT JOIN Tehnical_maintenance ON Vehicles.vehicle_id = Tehnical_maintenance.vehicle
WHERE Tehnical_maintenance.vehicle IS NULL;

-- Find starting and ending stops for each rote
SELECT rs1.route_id, s1.stop_name AS starting_stop, s2.stop_name AS ending_stop
FROM Route_stops rs1
JOIN Stops s1 ON rs1.stop_id = s1.stop_id AND rs1.stop_type = 'Starting'
JOIN Route_stops rs2 ON rs1.route_id = rs2.route_id AND rs2.stop_type = 'Ending'
JOIN Stops s2 ON rs2.stop_id = s2.stop_id;

-- Get all info about employees and their contracts who has salary higger than average
SELECT CONCAT(emp.first_name, ' ', emp.middle_name, ' ', emp.last_name) AS full_name, emp.phone_number, emp.email, position, salary, signed_date, date_active_to, work_experience
FROM Employee_contracts
JOIN Employees emp ON emp.employee_id = Employee_contracts.employee
WHERE salary > (SELECT AVG(salary) FROM Employee_contracts)
ORDER BY salary;

-- Get info about vehicles number, manufacture year that had cost of tehnical maintenance higger than average
SELECT veh.vehicle_number, veh.manufacture_year, cost
FROM Tehnical_maintenance
JOIN vehicles veh ON veh.vehicle_id = Tehnical_maintenance.vehicle
WHERE cost > (SELECT AVG(cost) FROM Tehnical_maintenance);

-- Get amount of routes that goes through for each stop
SELECT stop_name, stop_address, COUNT(rs.route_id) AS route_count
FROM Stops
LEFT JOIN Route_stops rs ON Stops.stop_id = rs.stop_id
GROUP BY Stops.stop_id
ORDER BY route_count DESC;

-- Find routes that have duration bigger than average
SELECT route_id, route_number, length, duration
FROM Routes
WHERE duration > (
    SELECT AVG(duration)
    FROM Routes
);

-- Find routes that goes through difined stop
SELECT route_id, route_number, length, duration
FROM Routes
WHERE route_id IN (
    SELECT route_id
    FROM Route_stops
    WHERE stop_id = 3
);

-- Find the longest route by duration
SELECT route_id, route_number, duration
FROM Routes
WHERE duration = (
    SELECT MAX(duration)
    FROM Routes
);