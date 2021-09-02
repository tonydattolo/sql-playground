drop table if exists employeeDetails;
drop table if exists company;
drop table if exists jobskill;
drop table if exists manages;

create table employeeDetails(empid integer, 
							  empname text,
							  empcity text,
							  compname text,
							  empsalary integer);
create table company(compname text, complocation text);
create table jobskill(empid integer, domain text);
create table manages(mid integer, eid integer);

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