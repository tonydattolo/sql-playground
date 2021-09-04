/* SQL code used for Lecture 1 "The Relational Model" */

/* Creating a database */

CREATE DATABASE lectures;

/* Creating relational schemas */

CREATE TABLE student(sid text NOT NULL,
                     sname varchar(30),
                     major varchar(15),
                     byear integer,
                     primary key(sid));


CREATE TABLE course(cno text NOT NULL,
                    cname varchar(20),
                    dept varchar(15),
                    primary key(cno));


CREATE TABLE enroll(sid text,
                    cno text,
                    grade varchar(2),
                    primary key(sid,cno),
                    foreign key(sid) references student(sid),
                    foreign key(cno) references course(cno));


/* Populating relations by inserting tuples */

INSERT INTO Student VALUES('s1', 'John', 'CS', 1990);
INSERT INTO Student VALUES('s2', 'Ellen','Math', 1995);
INSERT INTO Student VALUES('s3', 'Eric', 'CS', 1990);
INSERT INTO Student VALUES('s4', 'Ann', 'Biology', 2001); 


INSERT INTO Course VALUES ('c1', 'Dbs', 'CS'), 
                          ('c2', 'Calc1', 'Math'),
                          ('c3', 'Calc2', 'Math'),
                          ('c4', 'AI', 'Info');

 

INSERT INTO Enroll VALUES ('s1', 'c1', 'B'),
                          ('s1', 'c2', 'A'),
                          ('s2', 'c3', 'B'),
                          ('s3', 'c1', 'A'),
                          ('s3', 'c2', 'C');


/* An insertion that will be rejected since 's1' is already a primary key
value */

INSERT INTO Student VALUES ('s1', 'Linda', 'CS', 1990);
/* 
ERROR:  duplicate key value violates unique constraint "student_pkey"
DETAIL:  Key (sid)=(s1) already exists.
*/


/* We can not insert a tuple with a sid value that is NULL */
insert into student VALUES (NULL, 'John', 'DataScience', 19080);
/*
ERROR:  null value in column "sid" violates not-null constraint
DETAIL:  Failing row contains (null, John, DataScience, 19080).
*/



/* Retrieving relation instance */

SELECT * FROM Student;
/*  sid | sname |  major  | byear 
-----+-------+---------+-------
 s1  | John  | CS      |  1990
 s2  | Ellen | Math    |  1995
 s3  | Eric  | CS      |  1990
 s4  | Ann   | Biology |  2001
(4 rows)
*/

SELECT * FROM Course;
/*  cno | cname | dept 
-----+-------+------
 c1  | Dbs   | CS
 c2  | Calc1 | Math
 c3  | Calc2 | Math
 c4  | AI    | Info
(4 rows)
*/

SELECT * FROM Enroll;
/*
 sid | cno | grade 
-----+-----+-------
 s1  | c1  | B
 s1  | c2  | A
 s2  | c3  | B
 s3  | c1  | A
 s3  | c2  | C
(5 rows)
*/

/* Query: "Find the sid and sname of each student majoring in CS */

SELECT S.sid, S.sname 
FROM   Student S
WHERE  S.Major = 'CS';
/*sid | sname 
-----+-------
 s1  | John
 s3  | Eric
(2 rows)
*/

/* Query involving multiple relations
   "Find each (sid, sname, cno) tuple  and cno such that the corresponding
    student obtained a B grade in the corresponding course"
*/

SELECT S.sid, E.cno 
FROM   Student S, Enroll E
WHERE  S.sid = s.sid AND E.grade = 'B';
/* sid | cno 
-----+-----
 s1  | c1
 s2  | c3
(2 rows) 
*/

/* Find the sid of each student who did not receive a
A grade in any of their courses
*/
(SELECT S.sid FROM Student S)
EXCEPT
(SELECT E.sid FROM Enroll E WHERE E.Grade = 'A');
/* sid 
-----
 s2
 s4
(2 rows)
*/


DROP TABLE Enroll;

/* Addition foreign key constraints to the Enroll relation*/

CREATE TABLE enroll(sid text,
                    cno text,
                    grade varchar(2),
                    PRIMARY KEY(sid,cno),
                    FOREIGN KEY(sid) REFERENCES student(sid),
                    FOREIGN KEY(cno) REFERENCES course(cno));


INSERT INTO Enroll VALUES ('s1', 'c1', 'B'),
                          ('s1', 'c2', 'A'),
                          ('s2', 'c3', 'B'),
                          ('s3', 'c1', 'A'),
                          ('s3', 'c2', 'C');

TABLE Enroll;

/* Dropping the table Student (or Course) will not succeed since
Enroll depends on it via a foreign key*/
DROP TABLE Student;
/*ERROR:  cannot drop table student because other objects depend on it
  DETAIL:  constraint enroll_sid_fkey on table enroll depends on table student
  HINT:  Use DROP ... CASCADE to drop the dependent objects too.
*/



/* Inserting a tuple in Enroll with a referential integrity violation;
   Notice that sid s5 does not appear in the Student relation.
*/
INSERT INTO Enroll VALUES ('s5','c1','A');
/* ERROR:  insert or update on table "enroll" violates foreign key constraint "enroll_sid_fkey"
DETAIL:  Key (sid)=(s5) is not present in table "student".
*/



/* Deleting a tuple in Student may be disallowed (ON DELETE RESTRICT)
   or may side effect the Enroll relation (ON DELETE RESTRICT)
*/
DROP TABLE Enroll;

CREATE TABLE Enroll
      (sid     TEXT,
       cno     TEXT,
       grade   VARCHAR(2),
       PRIMARY KEY (sid, cno),
       FOREIGN KEY (sid) REFERENCES Student(sid) ON DELETE CASCADE,
       FOREIGN KEY (cno) REFERENCES Course(cno) ON DELETE RESTRICT
      );

DELETE FROM Student WHERE sid = 's1';
TABLE  Student;
TABLE  Enroll;
/*DELETE 1
lectures=# TABLE  Student;
 sid | sname |  major  | byear 
-----+-------+---------+-------
 s2  | Ellen | Math    |  1995
 s3  | Eric  | CS      |  1990
 s4  | Ann   | Biology |  2001
(3 rows)

lectures=# TABLE  Enroll;
 sid | cno | grade 
-----+-----+-------
 s2  | c3  | B
 s3  | c1  | A
 s3  | c2  | C
(3 rows)
*/

DELETE FROM Course WHERE cno = 'c1';
/* ERROR:  update or delete on table "course" violates foreign key constraint "enroll_cno_fkey" on table "enroll"
DETAIL:  Key (cno)=(c1) is still referenced from table "enroll".*/




SELECT S.major FROM student S;
-- DISTINCT to get a set vs a bag
SELECT DISTINCT S.major FROM student S;
-- EXPLAIN generates access plan that says if it uses hashing or sorting
EXPLAIN SELECT DISTINCT S.major FROM student S;
-- EXPLAIN ANALYZE to see predictive time/space complexity of query
EXPLAIN ANALYZE SELECT DISTINCT S.major from student S;

-- use AS to display SELECT clauses with specific attribute name
SELECT S.sid AS StudentID, S.sname as StudentName
FROM student S
WHERE S.major = 'CS';

-- ORDER BY, does ordering by column. Can use col name or col number
SELECT S.sid, S.sname
FROM student S
ORDER BY 2;

-- ORDER BY RANDOM() for random output order
SELECT * FROM student
ORDER BY random();

INSERT INTO enroll VALUES ('s1','c1','B');

-- S.sid = E.sid is a join condition
-- E.grade = 'B' is a constant comparison
SELECT S.sname, E.cno
FROM student S, enroll E
WHERE S.sid = E.sid AND E.grade = 'B'
ORDER BY 2;

-- Subqueries
SELECT S.sname, C.cno
FROM student S, (SELECT E.sid, E.cno
                 FROM enroll E
                 WHERE E.grade = 'B') C
WHERE S.sid = C.sid;

SELECT DISTINCT S.sid, S.sname
FROM student S, enroll E1, enroll E2
WHERE S.sid = E1.sid AND S.sid = E2.sid AND E1.cno <> E2.cno;

-- UNION, INTERSECT, EXCEPT (difference)
-- UNION example
-- "find the sids and names of all students who major in CS or Math"
(SELECT sid,sname
 FROM student
 WHERE major = 'CS')
UNION
(SELECT sid, sname
 FROM student
 WHERE major = 'Math');
-- Equivalent statement using OR operator
SELECT sid, sname
 FROM student
 WHERE major = 'Math' OR major = 'CS';

-- INTERSECTION
-- "find the sids of all students who are enrolled in course c1 and course c2"
(SELECT sid
    FROM enroll
    WHERE cno = 'c1')
INTERSECT
(SELECT sid
    FROM enroll
    WHERE cno = 'c2');

-- difference
-- "find the sids of all students who are enrolled in no courses"
(SELECT S.sid
    from student S)
EXCEPT
(SELECT E.sid
    FROM enroll E);

-- UNION, INTERSECT, EXCEPT are all sets, even if inputs are bags
-- to retain bags, all ALL operator
-- so, UNION ALL, INTERSECTION ALL, EXCEPT ALL

-- CROSS JOIN is the equivalent of product (R x S) in relational algebra
SELECT * FROM student CROSS JOIN enroll;

/* SQL code for Views lecture */
DELETE FROM Student;

DELETE FROM Course;

DELETE FROM Enroll;

INSERT INTO Student VALUES  ('s1', 'John'  , 'CS'      ,  1990),
                            ('s2', 'Ellen' , 'Math'    ,  1995),
                            ('s3', 'Eric'  , 'CS'      ,  1990),
                            ('s4', 'Ann'   , 'Biology' ,  2001);

INSERT INTO course VALUES ('c1', 'Dbs'   , 'CS'),
                          ('c2', 'Calc1' , 'Math'),
                          ('c3', 'Calc2' , 'Math'),
                          ('c4', 'AI'    , 'CS');



INSERT INTO enroll VALUES ('s1', 'c1', 'B'),
                          ('s1', 'c2', 'A'),
                          ('s2', 'c3', 'B'),
                          ('s3', 'c4', 'A'),
                          ('s3', 'c2', 'C');


/* View definition */
CREATE VIEW CS_Course AS
       SELECT C.Cno, C.Cname
       FROM   Course C
       WHERE  C.Dept = 'CS';
/* CREATE VIEW */

TABLE CS_course;

/*
 cno | cname 
-----+-------
 c1  | Dbs
 c4  | AI
(2 rows)
*/

/* Using view(s) in a query */
/* Find the names of CS courses */
SELECT C.Cname
FROM   CS_Course C;
/*  
cname 
-------
 AI
 Dbs
(1 row)
*/

/* Using view(s) in a query */
/* 
“Find the names of students enrolled in CS courses.”
*/
SELECT DISTINCT S.Sname
FROM   Student S, Enroll E, CS_Course C
WHERE  S.Sid = E.Sid AND E.Cno = C.Cno;
/*  
sname 
-------
 Eric
 John
(2 rows)
*/

/* View defined using other views */
/* "View showing all information on students taking CS courses.*/
CREATE VIEW Student_enrolled_in_CS_course AS
       SELECT S.Sid, S.Sname, S.Major, S.Byear
       FROM   Student S
       WHERE  S.Sid IN (SELECT E.Sid
                        FROM   Enroll E
                        WHERE  E.Cno IN (SELECT C.Cno
                                         FROM   CS_Course C));
/* CREATE VIEW */
TABLE Student_enrolled_in_CS_course;
/*
 sid | sname | major | byear 
-----+-------+-------+-------
 s1  | John  | CS    |  1990
 s3  | Eric  | CS    |  1990
(2 rows)
*/

CREATE VIEW CS_Enroll_Info AS
       SELECT E.Sid, E.Cno, E.Grade
       FROM   Enroll E
       WHERE  E.Sid IN (SELECT C.Sid
                        FROM   Student_enrolled_in_CS_course C);



/* View growth does not affected view definition */
ALTER TABLE Student
ADD COLUMN Matriculation_Year INTEGER;

TABLE CS_course;
/*
 cno | cname 
-----+-------
 c1  | Dbs
(1 row)
*/

TABLE Student_enrolled_in_CS_course;
/*
 sid | sname | major | byear 
-----+-------+-------+-------
 s1  | John  | CS    |  1990
 s3  | Eric  | CS    |  1990
(2 rows)
/*

/* Views: Restructuring */
CREATE TABLE Student_Info (Sid text,
                           Sname text,
                           Byear integer,
                           PRIMARY KEY (Sid));

CREATE TABLE Student_Major (Sid text,
                            Major text,
                            PRIMARY KEY (Sid, Major),
                            FOREIGN KEY (Sid) REFERENCES Student_Name (Sid));

INSERT INTO Student_Info SELECT Sid, Sname, Byear 
                         FROM   Student;

INSERT INTO Student_Major SELECT Sid, Major
                          FROM   Student;

TABLE Student_Info;
/*
 sid | sname | byear 
-----+-------+-------
 s1  | John  |  1990
 s2  | Ellen |  1995
 s3  | Eric  |  1990
 s4  | Ann   |  2001
(4 rows)
*/

TABLE Student_Major;
/*
 sid |  major  
-----+---------
 s1  | CS
 s2  | Math
 s3  | CS
 s4  | Biology
(4 rows)
*/

DROP TABLE Student CASCADE
/* This will drop the views CS_Courses and Student_enrolled_in_CS_Course */
/*
NOTICE:  drop cascades to 2 other objects
DETAIL:  drop cascades to constraint enroll_sid_fkey on table enroll
drop cascades to view student_enrolled_in_cs_course
DROP TABLE
*/

CREATE VIEW Student AS
         SELECT S.Sid AS Sid, S.Sname AS Sname, S.Byear AS Byear, Sm.Major AS Major
         FROM   Student_Name S, Student_Major Sm
         WHERE  S.Sid = Sm. Sid;

TABLE Student;
/*
 sid | sname | byear |  major  
-----+-------+-------+---------
 s1  | John  |  1990 | CS
 s2  | Ellen |  1995 | Math
 s3  | Eric  |  1990 | CS
 s4  | Ann   |  2001 | Biology
(4 rows)
*/

/* We can now the Student_enrolled_in_CS_course
   using the same definition
*/

/* View defined using other views */
/* "View showing all information on students taking CS courses.*/
CREATE VIEW Student_enrolled_in_CS_course AS
       SELECT S.Sid, S.Sname, S.Major, S.Byear
       FROM   Student S
       WHERE  S.Sid IN (SELECT E.Sid
                        FROM   Enroll E
                        WHERE  E.Cno IN (SELECT C.Cno
                                         FROM   CS_Course C));
/* CREATE VIEW */
TABLE Student_enrolled_in_CS_course;
/*
 sid | sname | major | byear 
-----+-------+-------+-------
 s1  | John  | CS    |  1990
 s3  | Eric  | CS    |  1990
(2 rows)
/*

/* View expansion rewriting */
/* Consider the following query: */
SELECT  C.Cname
FROM    CS_Course C
/* This query is rewritten to the following query */
SELECT C.Cname
FROM    (SELECT C.Cno, C.Cname
         FROM   Course C
         WHERE  C.Dept = 'CS') C;
/* cname 
-------
 Dbs
 AI
(1 row)
*/

/* View updates */
/* Insertion in views */
/* Consider the view CS_course with
   definition 
 
CREATE VIEW CS_Course AS
       SELECT C.Cno, C.Cname
       FROM   Course C
       WHERE C.Dept = ‘CS’;

*/

/* Suppose we want to add the CS course 'c6' */
INSERT INTO CS_Course VALUES('c6', 'Networks');

TABLE Course;

/*
 cno |  cname   | dept 
-----+----------+------
 c1  | Dbs      | CS
 c2  | Calc1    | Math
 c3  | Calc2    | Math
 c4  | AI       | CS
 c6  | Networks | 
(5 rows)
*/
/* Notice how a NULL value is inserted
   for the dept of course 'c6' */

TABLE CS_course;
/*
 cno | cname 
-----+-------
 c1  | Dbs
 c4  | AI
(1 row)
*/

/* Since course ‘c6’ does not appear in the CS_course view, 
   the following deletion will not remove course ‘c6’ 
   from the Course relation */
DELETE FROM CS_course WHERE Cno = 'c6';
/*
 DELETE 0
*/
TABLE Course;
/*
 cno |  cname   | dept 
-----+----------+------
 c1  | Dbs      | CS
 c2  | Calc1    | Math
 c3  | Calc2    | Math
 c4  | AI       | CS
 c6  | Networks | 
(5 rows)
*/

/* We can of course delete course 'c6' from the 
   Course base relation */
DELETE FROM Course WHERE Cno = 'c6';
/*
DELETE 1
*/
TABLE Course;
/*
 cno | cname | dept 
-----+-------+------
 c1  | Dbs   | CS
 c2  | Calc1 | Math
 c3  | Calc2 | Math
 c4  | AI    | Info
(4 rows)
*/

/* View materialization on view with NOT EXISTS clause */
CREATE VIEW foo AS 
    SELECT  Cno
    FROM    Course
    WHERE NOT EXISTS (SELECT 1
                      FROM   Course 
                      WHERE  cname = 'Java');
SELECT * FROM foo;
/* 
 cno 
-----
 c1
 c2
 c3
 c4
(4 rows)
*/

/* After the following insertion, no cno are returned
since there then exists a course with name 'Java' */

INSERT INTO Course VALUES ('c5','Java','CS');

SELECT * FROM foo;
/*  
cno 
-----
(0 rows)
*/

/* Materialized views in PostgreSQL */
CREATE MATERIALIZED VIEW CS_Course AS
     SELECT C.cno
     FROM   Course C
     WHERE  C.dept = 'CS';

TABLE CS_course;
/*
 cno 
-----
 c1
 c4
(1 row)
*/

INSERT INTO Course VALUES ('c5', 'Java', 'CS');
TABLE  Course;
/*
 cno | cname | dept 
-----+-------+------
 c1  | Dbs   | CS
 c2  | Calc1 | Math
 c3  | Calc2 | Math
 c4  | AI    | Info
 c5  | Java  | CS
(5 rows)
*/
/* Observe that c1 and c5 are CS courses so the CS_course
view would need to list them.   However, since the CS_course
view was not refreshed, the old value for CS_course has not
changed */
TABLE CS_course;
/*
 cno 
-----
 c1
 c4
(1 row)
*/

/* We need to refresh the value for CS_course using the
   REFRESH clause */

REFRESH MATERIALIZED VIEW CS_course;

TABLE CS_course;
/*
 cno 
-----
 c1
 c4
 c5
(2 rows)
*/

DELETE FROM Course WHERE cno = 'c5';
TABLE Course;
/*
 cno | cname | dept 
-----+-------+------
 c1  | Dbs   | CS
 c2  | Calc1 | Math
 c3  | Calc2 | Math
 c4  | AI    | CS
(4 rows)
*/

/* Even though the course 'c5' has been deleted from Course,
   this does not affect the value of CS_course, so we have the
   following:
*/
TABLE CS_course;
/* 
 cno 
-----
 c1
 c4
 c5
(2 rows)
*/

/* To get the most up to date value for CS_course, we need
   to do a REFRESH operation on the CS_course view */

REFRESH MATERIALIZED VIEW CS_course;
TABLE CS_course;

/*
 cno 
-----
 c1
 c4
(1 row)
*/

/* "Find the sids of student enrolled in CS courses" */
SELECT E.Sid
FROM   Enroll E
WHERE  E.Cno IN (SELECT C.Cno
                 FROM   CS_Course C);
/*
 sid 
-----
 s1
 s3
(2 rows)
*/

/* Temporary views:  the WITH clause */
/* Find the sid and name of each student who takes a  
   Math course and who majors in CS” */

WITH Math_Course AS (SELECT Cno, Cname
                     FROM   Course
                     WHERE  Dept = 'Math'),
     Student_enrolled_in_Math_course AS (SELECT Sid, Sname, Major, Byear
                                         FROM   Student 
                                         WHERE  Sid IN (SELECT E.Sid
                                                        FROM   Enroll E, Math_Course C
                                                        WHERE  E.Cno = C.Cno))
SELECT Sid, Sname
FROM   Student_enrolled_in_Math_course
WHERE  Major = 'CS';
/*
 sid | sname 
-----+-------
 s1  | John
 s3  | Eric
(2 rows)
*/

/* The view Math_course and Student_enrolled_in_Math_course
   are temporary: the do not persist after the evaluation of the query  */

TABLE Math_Course;
/*
ERROR:  relation "math_course" does not exist
LINE 1: TABLE Math_Course;
*/
TABLE Student_enrolled_in_Math_course;
/*
ERROR:  relation "student_enrolled_in_math_course" does not exist
LINE 1: TABLE Student_enrolled_in_Math_course;
*/


/* Not all subqueries define SQL views:
   Motivating example */
/* "Find the sids of all students enrolled in some course 
    offered by the department in which he or she majors. */

SELECT E.Sid
FROM   Student S, Enroll E
WHERE  S.Sid = E.Sid AND E.Cno IN (SELECT C.Cno
                                   FROM   Course C
                                   WHERE  C.Dept = S.Major);

/* Observe that 
      SELECT C.Cno
      FROM   Course C
      WHERE  C.Dept = S.Major
   is not a view since it as parameter S.Major */

/* Parameterized view:  CREATE and function with
   a deptname as parameter that returns the cnos of
   courses offered by that the department with that 
   deptname 
*/

CREATE FUNCTION coursesOfferedByDept(deptname TEXT)
          RETURNS TABLE(Cno TEXT) AS
          $$
             SELECT C.Cno
             FROM   Course C
             WHERE  C.Dept = deptname;
          $$ LANGUAGE SQL;

SELECT C.Cno 
FROM   coursesOfferedByDept('Math') C;
/*
 cno 
-----
 c2
 c3
(2 rows)
*/

SELECT * FROM coursesOfferedByDept('CS');
/*
 cno 
-----
 c1
 c4
(1 row)
*/

/* 

/* "Find the sids of all students enrolled in some course 
    offered by the department in which he or she majors. 

    We can write this query now as follows:*/

SELECT E.Sid
FROM   Student S, Enroll E
WHERE  S.Sid = E.Sid AND 
               E.Cno IN (SELECT C.Cno
                         FROM   coursesOfferedByDept(S.Major) C);
/*
 sid 
-----
 s1
 s2
 s3
(3 rows)
*/

/* Recursive views in SQL */
CREATE TABLE Graph (source INT,
                    target INT);

INSERT INTO Graph VALUES (1,2), (2,3), (3,1), (2,4);

TABLE Graph;
/*
 source | target 
--------+--------
      1 |      2
      2 |      3
      3 |      1
      2 |      4
(4 rows)
*/

/* Find the pairs of nodes (s,t) that are connected
   by a path in Graph 
*/

/* Inductive rules:
  Base rule:         If Graph(s,t) then Path(s,t)
  Inductive rule:    If Graph(s,u) and Path(u,t) then Path(s,t)
*/

WITH RECURSIVE Path(source, target) AS
   (
      SELECT E.source, E.target            /* Base rule */
      FROM   Graph E

      UNION

      SELECT  E.source, P.target            /* Inductive rule */
      FROM    Graph E, Path P
      WHERE   E.target = P.source
   )

   SELECT * FROM Path order by 1,2; 

/* 
 source | target 
--------+--------
      1 |      1
      1 |      2
      1 |      3
      1 |      4
      2 |      1
      2 |      2
      2 |      3
      2 |      4
      3 |      1
      3 |      2
      3 |      3
      3 |      4
(12 rows)
*/

