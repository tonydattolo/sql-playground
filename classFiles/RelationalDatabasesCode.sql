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
                    primary key(sid,cno));
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


