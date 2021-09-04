drop table if exists employeeDetails;
drop table if exists company;
drop table if exists jobskill;
drop table if exists manages;

create table employeeDetails(
    employee_id integer,
	employee_name text,
	employee_city text,
	company_name text,
	employee_salary integer,
    primary key (employee_id)
);
create table company(
    company_name text,
    company_location text,
    primary key (company_name,company_location)
);
create table jobskill(
    employee_id integer,
    domain text,
    primary key (employee_id,domain)
);
create table manages(
    manager_id integer,
    employee_id integer,
    primary key (manager_id, employee_id),
    foreign key (manager_id) references employeeDetails(employee_id),
    foreign key (employee_id) references employeeDetails(employee_id)
);

-- Data for the employee relation.
INSERT INTO employeeDetails VALUES
(9001,'Jean','Bloomington','Adobe',60000),
(9002,'Vidya', 'Indianapolis', 'Adobe', 45000),
(9003,'Anna', 'Chicago', 'Facebook', 55000),
(9004,'Qin', 'Denver', 'Facebook', 55000),
(9005,'Aya', 'Chicago', 'SAP', 60000),
(9006,'Ryan', 'Chicago', 'Facebook', 55000),
(9007,'Danielle','Indianapolis', 'HBO', 50000),
(9008,'Emma', 'Bloomington', 'Facebook', 50000),
(9009,'Hasan', 'Bloomington','Adobe',60000),
(9010,'Linda', 'Chicago', 'Facebook', 55000),
(9011,'Nick', 'NewYork', 'SAP', 55000),
(9012,'Eric', 'Indianapolis', 'Adobe', 50000),
(9013,'Lisa', 'Indianapolis', 'HBO', 55000),
(9014,'Deepa', 'Bloomington', 'Adobe', 50000),
(9015,'Chris', 'Denver', 'Facebook', 60000),
(9016,'YinYue', 'Chicago', 'Facebook', 55000),
(9017,'Latha', 'Indianapolis', 'HBO', 60000),
(9018,'Arif', 'Bloomington', 'Adobe', 50000);

-- Data for the company relation.
INSERT INTO company VALUES
('Adobe', 'Bloomington'),
('Facebook', 'Chicago'),
('Facebook', 'Denver'),
('Facebook', 'Columbus'),
('SAP', 'NewYork'),
('HBO', 'Indianapolis'),
('HBO', 'Chicago'),
('eBay', 'Bloomington');

-- Data for the jobskill relation.
INSERT INTO jobskill VALUES
(9001,'Programming'),
(9001,'AI'),
(9002,'Programming'),
(9002,'AI'),
(9004,'AI'),
(9004,'Programming'),
(9005,'AI'),
(9005,'Programming'),
(9005,'Networks'),
(9006,'Programming'),
(9006,'OperatingSystems'),
(9007,'OperatingSystems'),
(9007,'Programming'),
(9008,'Programming'),
(9009,'OperatingSystems'),
(9009,'Networks'),
(9010,'Networks'),
(9011,'Networks'),
(9011,'OperatingSystems'),
(9011,'AI'),
(9011,'Programming'),
(9012,'AI'),
(9012,'OperatingSystems'),
(9012,'Programming'),
(9013,'Programming'),
(9013,'AI'),
(9013,'OperatingSystems'),
(9013,'Networks'),
(9014,'OperatingSystems'),
(9014,'AI'),
(9014,'Programming'),
(9014,'Networks'),
(9015,'Programming'),
(9015,'AI'),
(9016,'Programming'),
(9016,'OperatingSystems'),
(9016,'AI'),
(9017,'Networks'),
(9017,'Programming'),
(9018,'AI');

-- Data for the manages  relation.
INSERT INTO manages VALUES
(9001, 9002),
(9001, 9009),
(9001, 9012),
(9009, 9018),
(9009, 9014),
(9012, 9014),
(9003, 9004),
(9003, 9006),
(9003, 9015),
(9015, 9016),
(9006, 9008),
(9006, 9016),
(9016, 9010),
(9005, 9011),
(9013, 9007),
(9013, 9017);

SELECT *
FROM company;

SELECT *
FROM employeeDetails;

SELECT *
FROM  jobskill;

SELECT *
FROM manages;

-- 1. Find the id, name, company name and salary of each employee who lives
-- in Indianapolis and whose salary is in the range [45000; 60000].
SELECT DISTINCT e.employee_id, e.employee_name, e.company_name, e.employee_salary
FROM employeeDetails e
WHERE e.employee_salary
    BETWEEN 45000 AND 60000;
-- 2. Find the id and name of each employee who works in a city located in
-- Indianapolis, whose job domain is OperatingSystems and a salary greater
-- than 40000.
SELECT DISTINCT e.employee_id, e.employee_name
FROM employeeDetails e, jobskill j
WHERE
    e.employee_id = j.employee_id
    AND j.domain = 'OperatingSystems'
    AND e.employee_city = 'Indianapolis'
    AND e.employee_salary > 40000;

-- 3. Find the id and name of each employee who lives in the same city as at
-- least one of his or her managers.
SELECT DISTINCT employees.employee_id, employees.employee_name
FROM
    employeeDetails employees,
    employeeDetails managers,
    manages m
WHERE
    managers.employee_id = m.manager_id
    AND employees.employee_id = m.employee_id
    AND employees.employee_city = managers.employee_city
ORDER BY 1 ASC;


-- 4. Find the names of Employees who doesn’t stay in the same city as that of
-- their company locations.
SELECT DISTINCT e.employee_name
FROM employeeDetails e, company c
WHERE
    NOT EXISTS (SELECT *
                FROM company c
                WHERE (e.company_name, e.employee_city) = c);

-- 5. Find the id, name, and salary of each manager who manages an employee
-- who manages at least one other employee whose job domain is
-- OperatingSystems.

-- 6. Find the common manager for the pairs (id1, id2) of different employees.

-- 7. Find the name, location of each company that does not have employees
-- who live in Chicago or Bloomington.

-- 8. For each company, list its name, location along with the ids of its
-- employees who have the lowest salary.

-- 9. Find id and name of each employee who does not have a manager with a
-- salary higher than that of the employee.

-- 10. Find the id and name of employee who works for company Facebook
-- whose job domain is Programming and whose manager works at a different
-- location.