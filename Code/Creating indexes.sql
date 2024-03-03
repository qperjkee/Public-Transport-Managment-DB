-- last name, first name, middle name index
EXPLAIN SELECT * FROM employees
WHERE last_name = 'Greenwood';

CREATE INDEX last_first_middle_names_idx
ON employees(last_name, first_name, middle_name);

ALTER TABLE employees
DROP INDEX last_first_middle_names_idx;

-- position, salary index
EXPLAIN SELECT * FROM employee_contracts
WHERE salary BETWEEN 2400 AND 2800 AND position = 'Driver';

CREATE INDEX position_salary_idx
ON employee_contracts(position, salary);

ALTER TABLE employee_contracts
DROP INDEX position_salary_idx;

-- vehicle number index
EXPLAIN SELECT * FROM vehicles
WHERE vehicle_number = '132';

CREATE INDEX vehicle_number_idx
ON vehicles(vehicle_number);

ALTER TABLE vehicles
DROP INDEX vehicle_number_idx;