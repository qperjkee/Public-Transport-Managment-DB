-- Getting detailed information about every route
CREATE VIEW detailed_route_info AS
SELECT Routes.route_id, route_number, length, duration, 
       GROUP_CONCAT(DISTINCT Stops.stop_name ORDER BY Route_stops.stop_type) AS stops_names,
       GROUP_CONCAT(DISTINCT Vehicles.vehicle_number ORDER BY Vehicles.vehicle_type) AS vehicles_numbers,
       GROUP_CONCAT(DISTINCT Schedules.start_time, ' - ', Schedules.end_time ORDER BY Schedules.week_days) AS schedules
FROM Routes
JOIN Route_stops ON Routes.route_id = Route_stops.route_id
JOIN Stops ON Route_stops.stop_id = Stops.stop_id
JOIN Route_vehicles ON Routes.route_id = Route_vehicles.route_id
JOIN Vehicles ON Route_vehicles.vehicle_id = Vehicles.vehicle_id
JOIN Schedules ON Route_vehicles.schedule_id = Schedules.schedule_id
GROUP BY Routes.route_id;

SELECT * FROM detailed_route_info;

-- Get employee and contract infromation for renewal
CREATE VIEW contracts_for_renewal AS
SELECT contract_id, CONCAT(emp.first_name, ' ', emp.middle_name, ' ', emp.last_name) AS full_name, emp.birth_date, emp.phone_number, emp.email, vehicle, position, salary, signed_date, date_active_to, work_experience
FROM Employee_contracts
JOIN employees emp ON emp.employee_id = employee_contracts.employee
WHERE date_active_to - INTERVAL 30 DAY < NOW()
ORDER BY date_active_to;

SELECT * FROM contracts_for_renewal;

-- Getting top 10 busiest routes by amount of stops
CREATE VIEW top_10_busiest_routes AS
SELECT Routes.route_id, route_number, length, duration,
       COUNT(*) AS stops_amount
FROM Routes
JOIN Route_stops ON Routes.route_id = Route_stops.route_id
JOIN Stops ON Route_stops.stop_id = Stops.stop_id
GROUP BY Routes.route_id
ORDER BY stops_amount DESC
LIMIT 10;

SELECT * FROM top_10_busiest_routes;

-- Getting all info about depot and vehicles in it
CREATE VIEW depot_vehicles AS
SELECT depot_id, depot_name, location, depots.capacity, depot_condition, veh.vehicle_number, vt.type_name, manufacture_year, vehicle_condition
FROM Depots
JOIN Vehicles veh ON Depots.depot_id = veh.depot
JOIN vehicles_types vt ON vt.type_id = veh.vehicle_type
ORDER BY veh.vehicle_number;

SELECT * FROM depot_vehicles;

-- Getting all info about vehicles and employees that maintain them
CREATE VIEW vehicles_with_employees AS
SELECT v.vehicle_id, v.vehicle_number, v.manufacture_year, v.vehicle_condition, vt.type_name, vt.capacity, e.employee_id, 
CONCAT(e.first_name, ' ', e.middle_name, ' ', e.last_name) AS full_name, ec.position
FROM vehicles v
JOIN vehicles_types vt ON v.vehicle_type = vt.type_id
JOIN employee_contracts ec ON v.vehicle_id = ec.vehicle
JOIN employees e ON ec.employee = e.employee_id
ORDER BY v.vehicle_number;

SELECT * FROM vehicles_with_employees;
