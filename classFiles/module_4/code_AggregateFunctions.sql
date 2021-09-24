/* SQL code for Lecture Aggregrate Functions */


table student;

/*
 sid | sname |  major  | byear 
-----+-------+---------+-------
 s1  | John  | CS      |  1990
 s2  | Ellen | Math    |  1995
 s3  | Eric  | CS      |  1990
 s4  | Ann   | Biology |  2001
(4 rows)
*/

table course;

/*
 cno | cname | dept 
-----+-------+------
 c1  | Dbs   | CS
 c2  | Calc1 | Math
 c3  | Calc2 | Math
 c4  | AI    | CS
(4 rows)
*/

table enroll;

/*
 sid | cno | grade 
-----+-----+-------
 s1  | c1  | B
 s1  | c2  | A
 s2  | c3  | B
 s3  | c4  | A
 s3  | c2  | C
(5 rows)
*/

SELECT COUNT(*)
FROM   R r;


/* For example:
*/

SELECT COUNT(*)
FROM   Student s;

/*
 count 
-------
     4
(1 row)
*/

SELECT COUNT(1)
FROM   R r;

/* For example */

SELECT COUNT(1)
FROM   Student s;

/*
 count 
-------
     4
(1 row)
*/

/* Of course we can restrict the COUNT function to apply to a subset
of R by applying a WHERE clause.
*/

SELECT COUNT(*) 
FROM   Enroll E
WHERE  E.sid = 's3';

/*
 count 
-------
     2
(1 row)
*/

/* Other example */

SELECT COUNT(*) 
FROM   Enroll E
WHERE  E.sid = 's4';

/*
 count 
-------
     0
(1 row)
*/


SELECT COUNT(*) 
FROM   Student S
WHERE  S.Sid NOT IN (SELECT E.Sid
                     FROM   Enroll E, Course C
                     WHERE  E.Cno = C.Cno AND C.Dept = 'CS');


/* Indeed since s2, s4 are not enrolled in any CS courses. */

SELECT S.sid
FROM   Student S
WHERE  S.Sid NOT IN (SELECT E.Sid
                     FROM   Enroll E, Course C
                     WHERE  E.Cno = C.Cno AND C.Dept = 'CS');

/*
 sid 
-----
 s2
 s4
(2 rows)
*/

/* Let R and S be two relations, then the following query will return
|R X S| i.e. the size of the cartesian (cross) product of R and S.*/

/* For example:
*/

SELECT COUNT(*)
FROM   Student S, Enroll E;

/*
 count 
-------
    20
(1 row)
*/


CREATE TABLE R(A text, B integer);

INSERT INTO R values ('a',1), ('a',2), ('b',1);

TABLE R;

/*
 a | b 
---+---
 a | 1
 a | 2
 b | 1
(3 rows)
*/

SELECT COUNT(r1.A) AS Total
FROM    R r1, R r2;

/*
 total 
-------
     9
(1 row)
*/


SELECT COUNT(DISTINCT r1.A) AS Total
FROM   R r1, R r2;

/*
 total 
-------
     2
(1 row)
*/

SELECT SUM(1)
FROM   R r;

/*
 sum 
-----
   3
(1 row)
*/

/* The SUM aggregate function */

DROP TABLE R;

CREATE TABLE R(A text);

INSERT INTO R values ('a'), ('b'), ('c');

TABLE R;

/*
a 
---
 a
 b
 c
(3 rows)
*/

SELECT SUM(1)
FROM   R r;


/* sum 
-----
   3
(1 row)
*/

SELECT SUM(2)
FROM   R r;

/*
 sum 
-----
   6
(1 row)
*/


DELETE FROM R;

SELECT COUNT(1)
FROM   R r;

/*
 count 
-------
     0
(1 row)
*/

SELECT SUM(1)
FROM   R r;

/*
 sum 
-----
    
(1 row)


The invisible row is the NULL value.  So the result
can be represented by

 sum 
-----
NULL    
(1 row)

*/

/* The MIN and MAX aggregate function */

/* MIN and MAX can be simulated with <= ALL and >= ALL */

/* Example */

SELECT MIN(e.sid)
FROM   enroll e;

/*
 min 
-----
 s1
(1 row)
*/


SELECT   DISTINCT e.sid AS MIN
FROM     Enroll E
WHERE    e.sid <= ALL (SELECT e.sid
                       FROM   enroll e);

/* A more general MIN and MAX that applies to 
tuple can be implemented with ALL */

/* For MIN */

SELECT   DISTINCT e.sid, e.cno
FROM     Enroll E
WHERE    (e.sid, e.cno) <= ALL (SELECT e.sid, e.cno 
                                FROM   enroll e);
/*
 sid | cno 
-----+-----
 s1  | c1
(1 row)
*/

/* For MAX */

SELECT   DISTINCT e.sid, e.cno
FROM     Enroll E
WHERE    (e.sid, e.cno) >= ALL (SELECT e.sid, e.cno 
                                FROM   enroll e);

/*
 sid | cno 
-----+-----
 s3  | c4
(1 row)
*/

/* Aggregate function MIN and MAX applied empty set
gives NULL values.
*/


TABLE R;

/*
 a 
---
(0 rows)
*/

SELECT MIN(r.A) AS smallest
FROM   R r;

/*
 smallest
----------
 
(1 row)
*/

/* However we have */


SELECT r.A AS smallest 
FROM   R r 
WHERE  r.A <= ALL(SELECT r1.A 
                  FROM   R r1);

/*
 smallest 
----------
(0 rows)
*/


/* Partitioning and counting */

CREATE TABLE Enroll (sid text,
                     cno text);

INSERT INTO Enroll VALUES ('s1', 'c1'), ('s2', 'c1'), ('s1', 'c2'), 
                          ('s3', 'c3'), ('s3', 'c4'), ('s1', 'c3');


TABLE Enroll;

/*
 sid | cno 
-----+-----
 s1  | c1
 s2  | c1
 s1  | c2
 s3  | c3
 s3  | c4
 s1  | c3
(6 rows)
*/


TABLE Student;
/*
 sid | sname |  major  | byear 
-----+-------+---------+-------
 s1  | John  | CS      |  1990
 s2  | Ellen | Math    |  1995
 s3  | Eric  | CS      |  1990
 s4  | Ann   | Biology |  2001
(4 rows)*/




/*
Determine for each student the number of courses taken by that
student.
*/

/* Partition on the basis of equality on sid
and then map the COUNT function on each of
the cells in the partition */

/* The GROUP BY method */

SELECT E.Sid, COUNT(*) AS No_Courses
FROM   Enroll E
GROUP BY(E.Sid) ORDER BY E.Sid;

/*
 sid | no_courses 
-----+------------
 s1  |          3
 s2  |          1
 s3  |          2
(3 rows)
*/

/* The user-defined COUNT FUNCTION method */


CREATE FUNCTION NumberOfCourses (s text) RETURNS bigint
AS $$
    SELECT COUNT(*) 
    FROM    Enroll E
    WHERE E.Sid = s;
$$ LANGUAGE SQL;

/*
Determine for each student the number of courses taken by that
student.
*/

SELECT  S.Sid, NumberOfCourses(S.Sid) AS No_Courses 
FROM    Student S;





/*
 sid | no_courses 
-----+------------
 s1  |          3
 s2  |          1
 s3  |          2
 s4  |          0
(4 rows)
*/

/* Notice the tuple (s4, 0) */
/* This tuple should be there since 
student s4 take 0 courses */

/* So the GROUP BY method is less accurate
than the user-defined COUNT FUNCTION method */


/* The SELECT COUNT-expressions method */

SELECT S.sid, (SELECT COUNT(E.Cno) AS NumberCourses 
               FROM   Enroll E
               WHERE  E.Sid = S.Sid)
FROM    Student S;

/*
 sid | numbercourses 
-----+---------------
 s1  |             3
 s2  |             1
 s3  |             2
 s4  |             0
(4 rows)
*/


/* The COUNT bug:  the following two querier
omit students who are not enrolled on courses
and therefore does not give the result that is
expected, i.e., the such a student takes 0
courses
*/

SELECT E.Sid, COUNT(E.Cno)
FROM   Enroll E
GROUP BY (E.Sid);

/*
 sid | count 
-----+-------
 s1  |     3
 s2  |     1
 s3  |     2
(3 rows)
*/

SELECT S.Sid, Count(E.Cno)
FROM   Student S, Enroll E
WHERE  S.Sid = E.Sid
GROUP BY(S.Sid);

/* sid | count 
-----+-------
 s1  |     3
 s2  |     1
 s3  |     2
(3 rows)
*/

/* The following query uses GROUP BY and
fixes the COUNT BUG */

(SELECT E.Sid, COUNT(E.Cno) AS No_Courses
 FROM   Enroll E
 GROUP BY (E.Sid))
UNION
(SELECT S.Sid, 0 AS No_Courses
 FROM   Student S
 WHERE  S.Sid NOT IN (SELECT E.Sid
                      FROM   Enroll E));


/*
 sid | no_courses 
-----+------------
 s1  |          3
 s2  |          1
 s3  |          2
 s4  |          0
(4 rows)
*/

/* Application:
“Find the sid of each students who take the most courses.”
*/

/* Using the GROUP BY method */

WITH 
   NumberOfCoursesbyStudent AS (SELECT E.Sid, COUNT(E.Cno) NumberOfCourses
                                FROM   Enroll E
                                GROUP BY(E.Sid))
   SELECT P.sid
   FROM   NumberOfCoursesbyStudent P
   WHERE  P.NumberOfCourses >= ALL (SELECT P1.NumberOfCourses
                                    FROM   NumberOfCoursesbyStudent P1);


/* Using the user-defined COUNT FUNCTION method */

SELECT S.Sid
FROM   Student S
WHERE  NumberOfCourses(S.Sid) >= ALL (SELECT NumberOfCourses(S1.Sid)
                                      FROM   Student S1);

/*
 sid 
-----
 s1
(1 row)
*/


/* Using the COUNT expression method */

SELECT S.Sid
FROM   Student S
WHERE  (SELECT COUNT(E.cno)
        FROM   Enroll E
        WHERE  E.sid = S.sid) >= ALL (SELECT (SELECT COUNT(E.cno)
                                              FROM   Enroll E
                                              WHERE  E.sid = S1.sid)
                                      FROM   Student S1);

/*
 sid 
-----
 s1
(1 row)
*/

/* Partitioning on different dimension  */

TABLE Enroll;

/*
 sid | cno 
-----+-----
 s1  | c1
 s2  | c1
 s1  | c2
 s3  | c3
 s3  | c4
 s1  | c3
(6 rows)
*/

SELECT COUNT(*)
FROM   Enroll
GROUP BY ();

/*
 count 
-------
     6
(1 row)
*/


SELECT E.Sid, COUNT(*)
FROM   Enroll E
GROUP BY (E.Sid);

/*
 sid | count 
-----+-------
 s1  |     3
 s2  |     1
 s3  |     2
(3 rows)
*/


SELECT E.Sid, E.Cno, COUNT(*)
FROM   Enroll E
GROUP BY (E.Sid, E.Cno);

/*
 sid | cno | count 
-----+-----+-------
 s1  | c1  |     1
 s1  | c2  |     1
 s1  | c3  |     1
 s2  | c1  |     1
 s3  | c3  |     1
 s3  | c4  |     1
(6 rows)
*/


/* What can appear in the GROUP BY clause?
Any valid expression over the tuple in the 
FROM clause */

CREATE TABLE S(X integer, Y integer);

INSERT INTO S VALUES (2,3), (1,3), (2,1), (0,3);

TABLE S;

/*
 x | y 
---+---
 2 | 3
 1 | 3
 2 | 1
 0 | 3
(4 rows)
*/

SELECT s.x + s.y AS sum, COUNT(*) as cell_size
FROM   S s
GROUP BY (s.x + s.y) order by 1;

/*
 sum | cell_size 
-----+-----------
   3 |         2
   4 |         1
   5 |         1
(3 rows)
*/

/* Another example */

TABLE Person;

SELECT   p.age > 10 AS OlderThanTen, COUNT(*) 
FROM     Person p 
GROUP BY (p.age > 10);

/*
 olderthanten | count 
--------------+-------
 f            |     3
 t            |     1
(2 rows)
*/

/* There are restrictions on the the
SELECT clause in GROUP BY query:

In a GROUP BY query, the SELECT clause may only contain aggregate
expressions that returns a single value for each cell of the partition
induced by the GROUP BY clause.

*/

SELECT s.x+s.y AS sum, SUM(s.x*s.y) AS sum_of_products
FROM   S s
GROUP BY (s.x+s.y) order by 1;

/*
 sum | sum_of_products 
-----+-----------------
   3 |               2
   4 |               3
   5 |               6
(3 rows)
*/

/* The following query will raise an error since s.x
is not necessarily unique in cell defined by s.x+s.y
*/

SELECT s.x
FROM   S s
GROUP BY (s.x+s.y);

/*
ERROR: column "s.x" must appear in the GROUP BY clause or be used in
an aggregate function 
LINE 1: SELECT s.x
*/

CREATE TABLE Trials(Tid text, dice1 integer, dice2 integer);

INSERT INTO Trials VALUES 
   ('t1', 1, 3),
   ('t2', 2, 3),
   ('t3', 1, 1),
   ('t4', 1, 6),
   ('t5', 2, 5),
   ('t6', 1, 6),
   ('t7', 6, 5),
   ('t8', 6, 1),
   ('t9', 4, 1);

TABLE Trials;

 tid | dice1 | dice2 
-----+-------+-------
 t1  |     1 |     3
 t2  |     2 |     3
 t3  |     1 |     1
 t4  |     1 |     6
 t5  |     2 |     5
 t6  |     1 |     6
 t7  |     6 |     5
 t8  |     6 |     1
 t9  |     4 |     1
(9 rows)

/* The random variable we consider is the
sum of the 2 dice values */

SELECT tid, dice1 + dice2 AS randomVariableValue
FROM   trials;

/*
 tid | randomvariablevalue 
-----+---------------------
 t1  |                   4
 t2  |                   5
 t3  |                   2
 t4  |                   7
 t5  |                   7
 t6  |                   7
 t7  |                  11
 t8  |                   7
 t9  |                   5
(9 rows)
*/

/* Frequency of RandomVariableValues
Suppose that we now want to determine the number of trials that
have the same random variable value
*/

SELECT t.Dice1 + t.Dice2 AS RV, COUNT(t.Tid) AS Frequency
FROM   Trials t
GROUP BY (t.Dice1 + t.Dice2) order by 1;

/*
 rv | frequency 
----+-----------
  2 |         1
  4 |         1
  5 |         2
  7 |         4
 11 |         1
(5 rows)
*/

/* Computing the EXPECTATION of the randomvariable dice1+dice2
*/

SELECT SUM(Q.RV * Q.NTrials)/(SELECT COUNT(1) FROM Trials) AS Expectation
FROM  (SELECT t.Dice1 + t.Dice2 AS RV, COUNT(t.Tid) AS  Ntrials
       FROM Trials t
       GROUP BY(t.Dice1 + t.Dice2)) AS Q;

/*
    expectation     
--------------------
 6.1111111111111111
(1 row)
*/


/* The Having clause in GROUP By queries */

/* For each student who majors in CS determine 
the number of courses taken by that student, 
provided that this number is at least 2.” */


SELECT E.Sid, COUNT(E.Cno) 
FROM   Enroll E, Student S
WHERE  E.Sid = S.Sid AND S.Major = 'CS'
GROUP BY (E.Sid)
HAVING COUNT(E.Cno) >= 2;

/*
 sid | count 
-----+-------
 s1  |     3
 s3  |     2
(2 rows)
*/


/* The same query with user-defined COUNT function */

SELECT  S.Sid AS Sid, NumberOfCourses(S.Sid)
FROM    Student S
WHERE   S.major = 'CS' AND NumberOfCourses(S.Sid) >= 2;

/*
 sid | numberofcourses 
-----+-----------------
 s1  |               3
 s3  |               2
(2 rows)
*/


/* Spreadsheets: The DATA CUBE */


/* GROUPING SETS */
/* Simulatneous grouping on multiple dimensions */

TABLE Enroll;

/*
 sid | cno 
-----+-----
 s1  | c1
 s1  | c2
 s1  | c3
 s2  | c1
 s2  | c2
 s3  | c2
 s4  | c1
(7 rows)
*/



SELECT Sid, Cno, COUNT(*)
FROM    Enroll
GROUP BY
  GROUPING SETS((Sid),(Cno)) order by 1,2;

/*
 sid | cno | count 
-----+-----+-------
 s1  |     |     3
 s2  |     |     2
 s3  |     |     1
 s4  |     |     1
     | c1  |     3
     | c2  |     3
     | c3  |     1
(7 rows)
*/


/* DATA CUBE Operation:  GROUPING SETS
are all subsets of the relation schema.
So if relation has n attributes then
there are 2^n grouping sets */

SELECT Sid, Cno, COUNT(*)
FROM   Enroll 
GROUP BY GROUPING SETS ((Sid,Cno),(Sid),(Cno),());

/*
 sid | cno | count 
-----+-----+-------
     |     |     7
 s1  | c3  |     1
 s1  | c1  |     1
 s4  | c1  |     1
 s3  | c2  |     1
 s2  | c1  |     1
 s1  | c2  |     1
 s2  | c2  |     1
 s3  |     |     1
 s4  |     |     1
 s2  |     |     2
 s1  |     |     3
     | c3  |     1
     | c1  |     3
     | c2  |     3
(15 rows)
*/


/* The DATA CUBE operation */
SELECT Sid, Cno, COUNT(*)
FROM   Enroll 
GROUP BY CUBE(Sid,Cno)


/*
 sid | cno | count 
-----+-----+-------
     |     |     7
 s1  | c3  |     1
 s1  | c1  |     1
 s4  | c1  |     1
 s3  | c2  |     1
 s2  | c1  |     1
 s1  | c2  |     1
 s2  | c2  |     1
 s3  |     |     1
 s4  |     |     1
 s2  |     |     2
 s1  |     |     3
     | c3  |     1
     | c1  |     3
     | c2  |     3
(15 rows)
*/

/* DATA CUBE over a subset of the schema */

SELECT Sid, COUNT(*)
FROM   Enroll 
GROUP BY CUBE(Sid);

/*
 sid | count 
-----+-------
     |     7
 s3  |     1
 s4  |     1
 s2  |     2
 s1  |     3
(5 rows)
*/

SELECT Cno, COUNT(*)
FROM   Enroll 
GROUP BY CUBE(Cno);

/*
 cno | count 
-----+-------
     |     7
 c3  |     1
 c1  |     3
 c2  |     3
(4 rows)
*/

/* WINDOW functions */

CREATE TABLE Product(Name text, Type text, Price integer);

INSERT INTO Product VALUES
  ('bag', 'accessory', 30),
  ('footliner', 'socks', 10),
  ('slippers', 'housewear', 15),
  ('leggings', 'socks', 7),
  ('pijamas', 'housewear', 25),
  ('necklace', 'accessory', 7),
  ('hat', 'accessory', 15),
  ('watch', 'accessory', 15);

TABLE Product;

/*
   name    |   type    | price 
-----------+-----------+-------
 bag       | accessory |    30
 footliner | socks     |    10
 slippers  | housewear |    15
 leggings  | socks     |     7
 pijamas   | housewear |    25
 necklace  | accessory |     7
 hat       | accessory |    15
 watch     | accessory |    15
(8 rows)
*/

/* 
Associate with each product the average price of all the products
of that product’s type.”
*/

SELECT name, type, price, AVG(price) OVER (PARTITION BY type)
FROM    product;


/*
   name    |   type    | price |         avg         
-----------+-----------+-------+---------------------
 bag       | accessory |    30 | 16.7500000000000000
 necklace  | accessory |     7 | 16.7500000000000000
 hat       | accessory |    15 | 16.7500000000000000
 watch     | accessory |    15 | 16.7500000000000000
 pijamas   | housewear |    25 | 20.0000000000000000
 slippers  | housewear |    15 | 20.0000000000000000
 footliner | socks     |    10 |  8.5000000000000000
 leggings  | socks     |     7 |  8.5000000000000000
(8 rows)
*/

/* Equivalent formulation */

SELECT p.name, p.type, p.price, 
                            (SELECT AVG(p1.price)
                             FROM    product p1
                             WHERE p1.type = p.type)
FROM   product p order by 2;

/*
   name    |   type    | price |         avg         
-----------+-----------+-------+---------------------
 bag       | accessory |    30 | 16.7500000000000000
 necklace  | accessory |     7 | 16.7500000000000000
 hat       | accessory |    15 | 16.7500000000000000
 watch     | accessory |    15 | 16.7500000000000000
 pijamas   | housewear |    25 | 20.0000000000000000
 slippers  | housewear |    15 | 20.0000000000000000
 footliner | socks     |    10 |  8.5000000000000000
 leggings  | socks     |     7 |  8.5000000000000000
(8 rows)
*/

/* List the rank order of the price of each product
amon the tuples of its type */

SELECT name, type, price,
               rank() OVER (PARTITION BY type ORDER BY price)
FROM   Product;

/*
   name    |   type    | price | rank 
-----------+-----------+-------+------
 necklace  | accessory |     7 |    1
 watch     | accessory |    15 |    2
 hat       | accessory |    15 |    2
 bag       | accessory |    30 |    4
 slippers  | housewear |    15 |    1
 pijamas   | housewear |    25 |    2
 leggings  | socks     |     7 |    1
 footliner | socks     |    10 |    2
(8 rows)
*/

/* Equivalent formulation */

SELECT p.name, p.type, p.price, 
                            (SELECT COUNT(1)
                             FROM    product p1
                             WHERE p1.type = p.type AND
                                   p1.price < p.price) + 1 AS rank
FROM   product p order by 2,4;

/*
   name    |   type    | price | rank 
-----------+-----------+-------+------
 necklace  | accessory |     7 |    1
 watch     | accessory |    15 |    2
 hat       | accessory |    15 |    2
 bag       | accessory |    30 |    4
 slippers  | housewear |    15 |    1
 pijamas   | housewear |    25 |    2
 leggings  | socks     |     7 |    1
 footliner | socks     |    10 |    2
(8 rows)
/*















   