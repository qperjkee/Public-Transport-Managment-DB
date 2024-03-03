-- Creating Admin role and assigning it to user 
CREATE ROLE 'Admin';

GRANT ALL
ON public_transport_routes.* TO 'Admin';

CREATE USER 'James'@'localhost'
IDENTIFIED BY 'jamespassword';

GRANT 'Admin' TO 'James'@'localhost';

-- Creating Inspector role and assigning it to user 
CREATE ROLE 'Inspector';

GRANT SELECT, INSERT, UPDATE ON public_transport_routes.vehicles TO 'Inspector';
GRANT SELECT, INSERT, UPDATE ON public_transport_routes.tehnical_maintenance TO 'Inspector';
GRANT SELECT ON public_transport_routes.vehicles_types TO 'Inspector';
GRANT SELECT ON public_transport_routes.depots TO 'Inspector';

CREATE USER 'Anna'@'localhost'
IDENTIFIED BY 'annapassword';

GRANT 'Inspector' TO 'Anna'@'localhost';

-- Creating Manager role and assigning it to user 
CREATE ROLE 'Manager';

GRANT SELECT, INSERT, UPDATE ON public_transport_routes.employees TO 'Manager';
GRANT SELECT, INSERT, UPDATE ON public_transport_routes.employee_contracts TO 'Manager';
GRANT SELECT ON public_transport_routes.vehicles TO 'Manager';
GRANT SELECT ON public_transport_routes.vehicles_types TO 'Manager';

CREATE USER 'Alex'@'localhost'
IDENTIFIED BY 'alexpassword';

GRANT 'Manager' TO 'Alex'@'localhost';

-- Creating Driver role and assigning it to user 
CREATE ROLE 'Driver';

GRANT SELECT ON public_transport_routes.employees TO 'Driver';
GRANT SELECT ON public_transport_routes.employee_contracts TO 'Driver';
GRANT SELECT ON public_transport_routes.vehicles TO 'Driver';
GRANT SELECT ON public_transport_routes.vehicles_types TO 'Driver';
GRANT SELECT ON public_transport_routes.route_vehicles TO 'Driver';
GRANT SELECT ON public_transport_routes.schedules TO 'Driver';
GRANT SELECT ON public_transport_routes.routes TO 'Driver';
GRANT SELECT ON public_transport_routes.route_stops TO 'Driver';
GRANT SELECT ON public_transport_routes.stops TO 'Driver';

CREATE USER 'Oscar'@'localhost'
IDENTIFIED BY 'oscarpassword';

GRANT 'Driver' TO 'Oscar'@'localhost';

