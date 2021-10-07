-- data for Assignment3

drop table if exists person;
create table person (person_id  integer,
                     person_name text,
                     person_city text,
                     person_birthYear integer,
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
  (30,'Aya','NewYork',1995);



drop table if exists knows;
create table knows (person_id1 integer,
                    person_id2 integer,
                    primary key (person_id1, person_id2),
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
  (16,24);


drop table if exists company;
create table company(company_name text,
                     company_city  text,
                     primary key (company_name,company_city));

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
  ('IBM','SanFrancisco');



drop table if exists worksfor;
create table worksfor(person_id integer,
                      company_name text,
                      employee_salary integer,
                      primary key (person_id),
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
  (30,'Intel',60000);


drop table if exists jobskill;
create table jobskill(skill text,
                      primary key (skill));
insert into jobskill values 
  ('Programming'), 
  ('Databases'), 
  ('AI'), 
  ('Networks'), 
  ('Mathematics');

drop table if exists personskill;
create table personskill(person_id integer,
                         skill text,
                         foreign key (person_id) references person(person_id),
                         foreign key (skill)references jobskill(skill));

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
  (20,'Programming');





---For question 1
CREATE TABLE P(coefficient integer, degree integer);

INSERT INTO P VALUES 
 (3, 4),
  (4, 3),
 (2,2),
 (-5, 1),
 (5, 0);

CREATE TABLE Q(coefficient integer, degree integer);

INSERT INTO Q VALUES 
 (1,5),
 (2, 4),
 (10, 3),
 (-1, 1),
 (9, 0);


---- For Question 2
CREATE TABLE X(index integer, value integer);

INSERT INTO X VALUES 
 (1, -8),
 (2, -3),
 (3, 4),
 (4, 9);

CREATE TABLE Y(index integer, value integer);

INSERT INTO Y VALUES 
 (1, 3),
 (2, -1),
 (3, 9),
 (4, -3);


-- Assignment 3 Questions:

-- 1.
create or replace function multiplicationPandQ()
    returns table (p_times_q_coefficient bigint, p_times_q_degree integer) as
    $$
        SELECT
            SUM(p.coefficient * q.coefficient) AS p_times_q_coefficient,
            p.degree + q.degree AS p_times_q_degree
        FROM P p, Q q
        GROUP BY p_times_q_degree
        ORDER BY p_times_q_degree DESC;
    $$ language sql;

select *
from multiplicationPandQ();

-- 2.
create or replace function dotProductXandY()
    returns bigint as
    $$
        SELECT SUM(x.value * y.value) AS dotproductxandy
        FROM X x, Y y
        WHERE x.index = y.index
    $$ language sql;

select *
from dotProductXandY();

-- 3.
create or replace function findChicagoKnows3()
    returns table (pid int, name text) as
    $$
        SELECT DISTINCT p.person_id, p.person_name
        FROM person p, person p2, knows k
        WHERE
            p.person_city = 'Chicago'
            AND p.person_id = k.person_id1
            AND k.person_id2 IN (SELECT has3skills.person_id
                                 FROM person has3skills, personskill s
                                 WHERE
                                    has3skills.person_id = s.person_id
                                 GROUP BY has3skills.person_id
                                 HAVING COUNT(s.skill) >= 3)
        ORDER BY p.person_id;
    $$ language sql;

select *
from findChicagoKnows3();

-- 4.
create or replace function allBut4SkillIndy()
    returns table (pid int, name text) as
    $$
        SELECT p.person_id, p.person_name
        FROM person p, personskill s
        WHERE
            p.person_city = 'Indianapolis'
            AND p.person_id = s.person_id
        GROUP BY p.person_id, p.person_name
        HAVING COUNT(s.skill) <= ((SELECT COUNT(1) FROM jobskill) - 4);
    $$ language sql;

select *
from allBut4SkillIndy();

-- 5. Find the pid and name of each person who knows all the persons who (a)
-- work at Apple, (b) make at most 60000, and (c) are born before 2000.
create or replace function knowsSomebody(pid int)
    returns table (pid int) as
    $$
        SELECT k.person_id2
        FROM knows k
        WHERE k.person_id1 = knowsSomebody.pid;
    $$ language sql;

create view conditionsFor5 as
    select p.person_id, p.person_name
    from person p, worksfor w
    where
        p.person_id = w.person_id
        and w.company_name = 'Apple'
        and w.employee_salary <= 60000
        and p.person_birthyear < 2000;

SELECT p.person_id, p.person_name
FROM person p
WHERE NOT EXISTS ((SELECT conditionsFor5.person_id
                   FROM conditionsFor5)
                   EXCEPT
                  (SELECT kk.pid
                   FROM knowsSomebody(p.person_id) kk));

-- 6. Find  the  cname  of  each  company  who  only  employs  persons  who  make
-- less than 50000

create view conditionsFor6 as
    select distinct w.company_name
    from person p, worksfor w
    where
        p.person_id = w.person_id
        and w.employee_salary < 50000;

create or replace function companyEmploys(cname text)
    returns table (cname text) as
    $$
        select distinct ww.company_name
        from worksfor ww
        where
            ww.company_name = companyEmploys.cname;
    $$ language sql;


SELECT DISTINCT c.company_name
FROM company c
WHERE NOT EXISTS ((SELECT * FROM companyEmploys(c.company_name))
                    EXCEPT
                  (SELECT * FROM conditionsFor6));

-- quantifiers with count
-- 7. Find the cname of each company that employs an even number of persons
-- whose salary is at most 60000.

create function evenNoOfEmployees(cname text)
    returns table (cname text) as
    $$
        select w.company_name
        from worksfor w
        where w.company_name = evenNoOfEmployees.cname
        group by w.company_name
        having count(w.person_id) % 2 = 0;
    $$ language sql;

create view salaryMost60000 as
    SELECT w.company_name
    FROM worksfor w
    WHERE w.employee_salary <= 60000;

SELECT DISTINCT w.company_name
FROM worksfor w
WHERE (SELECT COUNT(1)
       FROM(SELECT w.company_name
            FROM salaryMost60000 s
            INTERSECT
            SELECT e.cname
            FROM evenNoOfEmployees(w.company_name) e) countNumber) >= 1;


-- 8. Find the pid and name of each person who knows at most 3 people who
-- each have at least 2 job skills.

SELECT DISTINCT p.person_id, p.person_name
FROM person p
WHERE exists((select distinct p.person_id, p.person_name
                from person p, knows k, personskill s
                where
                    p.person_id = k.person_id1
                    and s.person_id = k.person_id2
                group by p.person_id
                having count(s.skill) >= 2 and count(k.person_id1) <= 3))
ORDER BY p.person_id;


-- SELECT DISTINCT p1.person_id
-- FROM person p1, personskill s
-- WHERE
--     p1.person_id = s.person_id
-- GROUP BY s.person_id
-- HAVING COUNT(s.skill) >= 2
-- UNION
-- SELECT DISTINCT k.person_id1
-- FROM knows k, person pp
-- WHERE pp.person_id = k.person_id1
-- GROUP BY k.person_id1
-- HAVING COUNT(k.person_id1) <= 3;

-- 9. Find the pairs (  p1, p2) of different person pids such that the person with pid
-- p1 and the person with pid p2 knows the s  ame number of persons.

SELECT DISTINCT k.person_id1, k.person_id2
FROM knows k
WHERE EXISTS(
        SELECT k.person_id1, COUNT(*)
        FROM knows k
        GROUP BY k.person_id1
        HAVING cast(COUNT(k.person_id1) as int) = cast(COUNT(k.person_id2) as int)
        ORDER BY k.person_id1);
--
-- create or replace function numberKnows(pid int)
--     returns table (pid bigint) as
--     $$
--         SELECT COUNT(1)
--         FROM knows k
--         WHERE k.person_id1 = pid;
--     $$ language sql;
