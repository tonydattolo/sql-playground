-- data1 dataset for for Assignment2
-- note to grader: professor said I can change attribute name to fit SQL
-- style guide conventions. such as descriptive attributes, non-abbreviated keys, etc.
-- for example, just having an attribute 'name' is bad practice, especially if it's used
-- in two places in the database.
-- https://about.gitlab.com/handbook/business-technology/data-team/platform/sql-style-guide/

create table person (person_id  integer,
                     person_name text,
                     person_city text,
                     birth_year integer,
                     primary key (person_id));

insert into person values
  (1,'Nick','NewYork',1990),
  (2,'Deepa','Indianapolis',1985),
  (3,'Eric','NewYork',1990),
  (4,'Ryan','Indianapolis',1995),
  (5,'Hasan','Indianapolis',1990),
  (6,'Arif','Indianapolis',1980),
  (7,'Ryan','Chicago',1980),
  (8,'Jean','SanFransisco',2000),
  (9,'Aya','SanFransisco',1985),
  (10,'Lisa','NewYork',2000),
  (11,'Arif','Chicago',1990),
  (12,'Deepa','Bloomington',1990),
  (13,'Nick','SanFransisco',1980),
  (14,'Ryan','Indianapolis',1990),
  (15,'Nick','Indianapolis',1990),
  (16,'Anna','Chicago',1980),
  (17,'Lisa','Bloomington',1990),
  (18,'Ryan','Bloomington',1995),
  (19,'Lisa','Chicago',1980),
  (20,'Danielle','Indianapolis',1985),
  (21,'Eric','Chicago',1980),
  (22,'Anna','Indianapolis',1985),
  (23,'Chris','Bloomington',1990),
  (24,'Aya','NewYork',1995),
  (25,'Arif','SanFransisco',1990),
  (26,'Anna','Bloomington',2000),
  (27,'Latha','SanFransisco',2000),
  (28,'Eric','Bloomington',2000),
  (29,'Linda','Bloomington',1990),
  (30,'Aya','NewYork',1995),
  (31,'Aya','NewYork',1996),
  (32,'Anna','Bloomington',1985);


create table knows (person_id1 integer,
                    person_id2 integer,
                    primary key(person_id1, person_id2),
                    foreign key (person_id1) references person(person_id),
                    foreign key (person_id2) references person(person_id));

insert into knows values
  (5,22),
  (15,28),
  (10,27),
  (11,27),
  (13,14),
  (11,14),
  (5,28),
  (1,26),
  (18,24),
  (24,5),
  (6,26),
  (15,7),
  (15,25),
  (19,27),
  (10,5),
  (11,19),
  (20,22),
  (27,23),
  (24,29),
  (4,10),
  (26,12),
  (13,15),
  (19,4),
  (20,10),
  (10,6),
  (1,7),
  (17,23),
  (9,26),
  (3,10),
  (21,29),
  (27,15),
  (12,13),
  (16,3),
  (14,24),
  (14,28),
  (12,4),
  (15,8),
  (4,28),
  (18,11),
  (12,16),
  (30,12),
  (4,9),
  (4,8),
  (29,13),
  (29,20),
  (24,18),
  (16,13),
  (30,17),
  (23,22),
  (7,16),
  (29,22),
  (26,3),
  (28,30),
  (25,10),
  (3,22),
  (22,21),
  (30,3),
  (1,20),
  (19,11),
  (29,15),
  (13,30),
  (11,12),
  (1,5),
  (13,18),
  (24,19),
  (30,10),
  (4,12),
  (24,11),
  (18,22),
  (3,2),
  (4,3),
  (12,23),
  (25,24),
  (17,20),
  (28,10),
  (8,17),
  (15,13),
  (1,9),
  (6,18),
  (3,4),
  (4,19),
  (24,23),
  (27,3),
  (12,5),
  (12,2),
  (26,22),
  (30,15),
  (20,13),
  (28,14),
  (14,5),
  (1,10),
  (7,9),
  (27,22),
  (12,11),
  (16,20),
  (12,3),
  (17,7),
  (2,14),
  (18,25),
  (16,24),
  (16,15),
  (31,14),
  (32,14),
  (32,7),
  (31,7);


create table company(company_name text,
                     company_city text,
                     primary key (company_name, company_city));

insert into company values
  ('Amazon','NewYork'),
  ('IBM','NewYork'),
  ('Amazon','Indianapolis'),
  ('Amazon','Bloomington'),
  ('Intel','NewYork'),
  ('Netflix','Indianapolis'),
  ('Yahoo','Indianapolis'),
  ('Google','Bloomington'),
  ('Apple','Indianapolis'),
  ('Hulu','Chicago'),
  ('Hulu','NewYork'),
  ('Yahoo','Chicago'),
  ('Intel','Bloomington'),
  ('Google','Chicago'),
  ('Zoom','Chicago'),
  ('Yahoo','NewYork'),
  ('Yahoo','Bloomington'),
  ('Netflix','Bloomington'),
  ('Microsoft','Chicago'),
  ('Netflix','NewYork'),
  ('Microsoft','Indianapolis'),
  ('Zoom','SanFransisco'),
  ('Netflix','SanFrancisco'),
  ('Yahoo','SanFrancisco'),
  ('IBM','SanFrancisco'),
  ('Uber','Bloomington');




create table worksfor(person_id    integer,
                      employee_company  text,
                      employee_salary integer,
                      primary key(person_id),
                      foreign key (person_id) references person(person_id));

insert into worksfor values
  (1,'IBM',60000),
  (2,'Hulu',50000),
  (3,'Amazon',45000),
  (4,'Microsoft',60000),
  (5,'Amazon',40000),
  (6,'IBM',50000),
  (7,'IBM',50000),
  (8,'Netflix',45000),
  (9,'Yahoo',50000),
  (10,'Hulu',40000),
  (11,'Apple',40000),
  (12,'Netflix',55000),
  (13,'Apple',40000),
  (14,'IBM',50000),
  (15,'IBM',40000),
  (16,'Apple',55000),
  (17,'Google',45000),
  (18,'Amazon',45000),
  (19,'Zoom',45000),
  (20,'Microsoft',55000),
  (21,'Intel',55000),
  (22,'IBM',40000),
  (23,'Apple',40000),
  (24,'Google',45000),
  (25,'Hulu',50000),
  (26,'Intel',55000),
  (27,'Intel',50000),
  (28,'Intel',50000),
  (29,'Google',60000),
  (30,'Intel',60000),
  (31,'Uber',50000),
  (32,'Uber',60000);


create table jobskill(skill text,
                      primary key(skill));
insert into jobskill values
  ('Programming'),
  ('Databases'),
  ('AI'),
  ('Networks'),
  ('Mathematics'),
  ('Accounting');

create table personskill(person_id integer,
                         skill text,
                         primary key(person_id,skill),
                         foreign key (person_id) references person(person_id),
                         foreign key (skill) references jobskill(skill));

insert into personskill values
  (27,'Programming'),
  (18,'Mathematics'),
  (10,'AI'),
  (29,'Networks'),
  (23,'AI'),
  (4,'AI'),
  (1,'Databases'),
  (10,'Networks'),
  (9,'Programming'),
  (13,'Networks'),
  (9,'AI'),
  (27,'Mathematics'),
  (20,'AI'),
  (29,'Databases'),
  (5,'Programming'),
  (26,'Databases'),
  (1,'Networks'),
  (28,'AI'),
  (15,'Programming'),
  (16,'Mathematics'),
  (12,'Databases'),
  (15,'Databases'),
  (24,'Programming'),
  (14,'AI'),
  (25,'Networks'),
  (13,'AI'),
  (12,'Programming'),
  (22,'Programming'),
  (7,'Mathematics'),
  (10,'Programming'),
  (16,'Databases'),
  (19,'Programming'),
  (7,'Programming'),
  (22,'AI'),
  (5,'Databases'),
  (2,'Mathematics'),
  (14,'Programming'),
  (26,'Networks'),
  (19,'Networks'),
  (21,'Programming'),
  (14,'Mathematics'),
  (19,'AI'),
  (2,'Networks'),
  (8,'Databases'),
  (13,'Mathematics'),
  (29,'Programming'),
  (3,'AI'),
  (16,'Networks'),
  (5,'Networks'),
  (17,'AI'),
  (24,'Databases'),
  (2,'Databases'),
  (27,'Networks'),
  (28,'Databases'),
  (30,'Databases'),
  (4,'Networks'),
  (6,'Networks'),
  (17,'Networks'),
  (23,'Programming'),
  (20,'Programming'),
  (31,'Programming'),
  (32,'Databases'),
  (32,'Accounting'),
  (6, 'Databases');

-- 1. Find the ID and name of each person who works for IBM and whose salary is lower
-- than another person who works for IBM as well and has Programming skill.

-- (a) Formulate this query in SQL without using subqueries and set predicates. You are
-- allowed to use the SQL operators INTERSECT, UNION, and EXCEPT.
(SELECT DISTINCT p.person_id, p.person_name
FROM person p, worksfor w, company c, personskill s
WHERE
    p.person_id = w.person_id
    AND w.employee_company = c.company_name
    AND c.company_name = 'IBM'
    AND p.person_id = s.person_id
    AND s.skill = 'Programming')
EXCEPT
(SELECT DISTINCT p.person_id, p.person_name
FROM person p, worksfor w, company c, personskill s,
     person p2, worksfor w2, company c2, personskill s2
WHERE
    p.person_id = w.person_id
    AND p.person_id = s.person_id
    AND w.employee_company = c.company_name
    AND c.company_name = 'IBM'
    AND s.skill = 'Programming'
    AND p2.person_id = w2.person_id
    AND p2.person_id = s2.person_id
    AND w2.employee_company = c2.company_name
    AND c2.company_name = 'IBM'
    AND s2.skill = 'Programming'
    AND w.employee_salary > w2.employee_salary);
-- (b) Formulate this query in SQL by only using the IN or NOT IN set predicates.
SELECT DISTINCT p.person_id, p.person_name
FROM person p, worksfor w, company c, personskill s, person
WHERE
    p.person_id = w.person_id
    AND w.employee_company = c.company_name
    AND c.company_name = 'IBM'
    AND p.person_id = s.person_id
    AND s.skill = 'Programming'
    AND p.person_id NOT IN (SELECT DISTINCT p.person_id
                            FROM person p, worksfor w, company c, personskill s,
                                 person p2, worksfor w2, company c2, personskill s2
                            WHERE
                                p.person_id = w.person_id
                                AND p.person_id = s.person_id
                                AND w.employee_company = c.company_name
                                AND c.company_name = 'IBM'
                                AND s.skill = 'Programming'
                                AND p2.person_id = w2.person_id
                                AND p2.person_id = s2.person_id
                                AND w2.employee_company = c2.company_name
                                AND c2.company_name = 'IBM'
                                AND s2.skill = 'Programming'
                                AND w.employee_salary > w2.employee_salary)
ORDER BY p.person_id;


-- (c) Formulate this query in SQL by only using the SOME or ALL set predicates.
SELECT DISTINCT p.person_id, p.person_name
FROM person p, worksfor w, company c, personskill s, person
WHERE
    p.person_id = w.person_id
    AND w.employee_company = c.company_name
    AND c.company_name = 'IBM'
    AND p.person_id = s.person_id
    AND s.skill = 'Programming'
    AND w.employee_salary < ALL (SELECT DISTINCT w.employee_salary
                                FROM person p, worksfor w, company c, personskill s,
                                     person p2, worksfor w2, company c2, personskill s2
                                WHERE
                                    p.person_id = w.person_id
                                    AND p.person_id = s.person_id
                                    AND w.employee_company = c.company_name
                                    AND c.company_name = 'IBM'
                                    AND s.skill = 'Programming'
                                    AND p2.person_id = w2.person_id
                                    AND p2.person_id = s2.person_id
                                    AND w2.employee_company = c2.company_name
                                    AND c2.company_name = 'IBM'
                                    AND s2.skill = 'Programming'
                                    AND w.employee_salary > w2.employee_salary);
-- (d) Formulate this query in SQL by only using the EXISTS or NOT EXISTS set
-- predicates.
SELECT DISTINCT p.person_id, p.person_name
FROM person p, worksfor w, company c, personskill s,
     person p2, worksfor w2, company c2, personskill s2
WHERE
    p.person_id = w.person_id
    AND p.person_id = s.person_id
    AND w.employee_company = c.company_name
    AND c.company_name = 'IBM'
    AND s.skill = 'Programming'
    AND p2.person_id = w2.person_id
    AND p2.person_id = s2.person_id
    AND w2.employee_company = c2.company_name
    AND c2.company_name = 'IBM'
    AND s2.skill = 'Programming'
    AND w.employee_salary < w2.employee_salary
    AND EXISTS (SELECT DISTINCT p.person_id, p.person_name
                FROM person p, worksfor w, company c, personskill s, person
                WHERE
                    p.person_id = w.person_id
                    AND w.employee_company = c.company_name
                    AND c.company_name = 'IBM'
                    AND p.person_id = s.person_id
                    AND s.skill = 'Programming');

-- 2. Find the ID and name of each person who knows another person who works for ‘Hulu’,
-- but who does not know a person who works at ‘Intel’ and has the ‘Networks’ skill.

-- (a) Formulate this query in SQL without using subqueries and set predicates. You are
-- allowed to use the SQL operators INTERSECT, UNION, and EXCEPT.
(SELECT DISTINCT p.person_id, p.person_name
FROM person p, knows k, person p2, worksfor w
WHERE
    p.person_id = k.person_id1
    AND p2.person_id = k.person_id2
    AND p2.person_id = w.person_id
    AND w.employee_company = 'Hulu')
EXCEPT
(SELECT DISTINCT p.person_id, p.person_name
FROM person p, person p2, knows k, worksfor w, personskill s
WHERE
    p.person_id = k.person_id1
    AND p2.person_id = k.person_id2
    AND p2.person_id = w.person_id
    AND w.employee_company = 'Intel'
    AND p2.person_id = s.person_id
    AND s.skill = 'Networks')
ORDER BY person_id;

-- (b) Formulate this query in SQL by only using the IN or NOT IN set predicates.
SELECT DISTINCT p.person_id, p.person_name
FROM person p, knows k, person p2, worksfor w
WHERE
    p.person_id = k.person_id1
    AND p2.person_id = k.person_id2
    AND p2.person_id = w.person_id
    AND w.employee_company = 'Hulu'
    AND p.person_id NOT IN (SELECT DISTINCT p.person_id
                            FROM person p, person p2, knows k, worksfor w, personskill s
                            WHERE
                                p.person_id = k.person_id1
                                AND p2.person_id = k.person_id2
                                AND p2.person_id = w.person_id
                                AND w.employee_company = 'Intel'
                                AND p2.person_id = s.person_id
                                AND s.skill = 'Networks');
-- (c) Formulate this query in SQL by only using the SOME or ALL set predicates.
SELECT DISTINCT p.person_id, p.person_name
FROM person p, knows k, person p2, worksfor w
WHERE
    p.person_id = k.person_id1
    AND p2.person_id = k.person_id2
    AND p2.person_id = w.person_id
    AND w.employee_company = 'Hulu'
    AND p.person_id <> ALL (SELECT DISTINCT p.person_id
                            FROM person p, person p2, knows k, worksfor w, personskill s
                            WHERE
                                p.person_id = k.person_id1
                                AND p2.person_id = k.person_id2
                                AND p2.person_id = w.person_id
                                AND w.employee_company = 'Intel'
                                AND p2.person_id = s.person_id
                                AND s.skill = 'Networks');

-- (d) Formulate this query in SQL by only using the EXISTS or NOT EXISTS set
-- predicates.
SELECT DISTINCT p.person_id, p.person_name
FROM person p, knows k, person p2, worksfor w
WHERE
    p.person_id = k.person_id1
    AND p2.person_id = k.person_id2
    AND p2.person_id = w.person_id
    AND w.employee_company = 'Hulu'
    AND NOT EXISTS (SELECT DISTINCT p.person_id
                    FROM person p, person p2, knows k, worksfor w, personskill s
                    WHERE
                        p.person_id = k.person_id1
                        AND p2.person_id = k.person_id2
                        AND p2.person_id = w.person_id
                        AND w.employee_company = 'Intel'
                        AND p2.person_id = s.person_id
                        AND s.skill = 'Networks');

-- 3. Find the name of each company located in Bloomington, but not in Indianapolis, along
-- with the ID, name, and salary of each person who works for that company and who has
-- the next to highest salary (i.e. the second highest salary) at that company.

-- (a) Formulate this query in SQL without using subqueries and set predicates. You are
-- allowed to use the SQL operators INTERSECT, UNION, and EXCEPT.

-- (b) Formulate this query in SQL by only using the IN or NOT IN set predicates.

-- (c) Formulate this query in SQL by only using the SOME or ALL set predicates.

-- (d) Formulate this query in SQL by only using the EXISTS or NOT EXISTS set
-- predicates.

-- Formulate the following queries in Pure SQL augmented with views, and this includes
-- temporary and parameterized views. However, you cannot use GROUP BY and aggregate
-- functions.

-- 1.
-- (a) Define a view SalaryAbove50000 that defines the sub relation of Person consisting of the
-- employees whose salary is strictly above 50000.
-- Test your view

-- (b) Define a view Programmer that returns the set of IDs of persons whose job skill is
-- Programming. Test your view.

-- (c) Using the views SalaryAbove50000 and Programmer, write the following query in SQL:
-- ‘Find the ID and name of each person who (a) works for ‘Netflix’, (b) has a salary which is
-- strictly above 50000, and (c) who does not know any person whose job skill is Programming
-- with a salary strictly above 50000.’

-- 2.
-- (a) Define a parameterized view SalaryAbove(amount integer) that returns, for a given value
-- for the amount parameter, the sub relation of Person consisting of the employees whose salary
-- is strictly above that of this value. Test your view for the parameter values 30000, 50000, and
-- 55000.

-- (b) Define a view KnowsEmployeeAtCompany(cname text) that returns the set of pids of
-- persons who know a person who works at the company given by the value of the parameter
-- cname. Test you view for the parameters ‘Yahoo’, ‘Google’, and ‘Amazon’.

-- queries with expressions and functions; boolean queries
-- 1. Let A(x) be the relation schema for a set of positive integers. (The domain of x is
-- INTEGER.) Write a SQL statement that produces a table which, for each x ∈ A,
-- lists the tuple (x, x 1/3 , x x , 10 x , x! , log 2 x).
-- Ex: A = {4, 8, 12, 16, 20}
-- Reference Table will be given in expected output.