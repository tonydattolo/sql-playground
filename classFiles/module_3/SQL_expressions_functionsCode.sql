/* Code for Lecture SQL expressions and functions */

/* Expressions in SELECT clause */
/* Notice that there are no FROM nor WHERE clauses */

SELECT 1 AS one;

/*
 one 
-----
   1
(1 row)
*/

SELECT sqrt(2), 'John '||'Smith', 2=3;

/*
      sqrt       |  ?column?  | ?column? 
-----------------+------------+----------
 1.4142135623731 | John Smith | f
(1 row)
*/

/* SELECT expressions returns a relation and can
therefore be used in the FROM clause of other queries
*/

SELECT q.one
FROM   (SELECT 1 AS one) q;

/* one 
-----
   1
(1 row)
*/


/* To use SELECT expression as values in other expression
you need to place parentheses around the SELECT expression */

/* The following is incorrect: */

SELECT SELECT 1 AS result;
/*ERROR:  syntax error at or near "SELECT"
LINE 1: SELECT SELECT 1;*/

/* We must place parentheses around SELECT 1 */
/* The following is correct: */

SELECT (SELECT 1) AS result;

/*
 result 
--------
      1
(1 row)
*/

/* The following is also a correct example */

SELECT (SELECT 2)*(SELECT 3) AS result;

/*
 result 
--------
      6
(1 row)
*/


/* Boolean queries */
/* A boolean query returns either true or false */

/* Are there CS students who take courses? */

SELECT EXISTS(SELECT  S.Sid
              FROM    student S, enroll E
              WHERE   S.Major = 'CS' AND S.Sid = E.Sid); 

/* 
 exists 
--------
 t
(1 row)
*/

/* Are there Biology students who take courses? */

SELECT EXISTS(SELECT  S.Sid
              FROM    student S, enroll E
              WHERE   S.Major = 'Biology' AND S.Sid = E.Sid); 

/* 
 exists 
--------
 f
(1 row)
*/

/* 
Checking for primary key constraint:
Is Major a primary key for the student relation? */

SELECT NOT EXISTS(SELECT 1
                  FROM   student S1, student S2
                  WHERE  S1.Sid <> S2.Sid AND
                         S1.Major = S2.Major) AS IsKey;

/*
 iskey 
-------
 f
(1 row)
*/

/*
Checking for foreign key constraint:
“Is Sid a foreign key in the enroll relation referencing the primary
kea Sid in the student relation?”
*/

SELECT NOT EXISTS (SELECT E.Sid
                   FROM   enroll E
                   WHERE  E.Sid NOT IN (SELECT S.Sid
                                        FROM   student S)) AS iSFK;

/*
 isfk 
------
 t
(1 row)
*/

/* The CASE expression */
DELETE FROM employee;

INSERT INTO employee VALUES ('p1', 25000), ('p2', 9000), ('p3', 105000);

TABLE employee;
/*
 eid | salary 
-----+--------
 p1  |  25000
 p2  |   9000
 p3  | 105000
(3 rows)
*/

SELECT E.Eid, 
       CASE WHEN E.Salary > 100000 THEN 'high'
            WHEN E.Salary < 10000  THEN 'low' 
            ELSE 'medium'
       END AS SalaryRange
FROM employee E;

/*
 eid | salaryrange 
-----+-------------
 p1  | medium
 p2  | low
 p3  | high
(3 rows)
*/


/* Expressions with parameterized sub-queries */

/*
“Report whether or not a student takes a course in the department in
which he or she majors.”
*/

SELECT S.Sid, S.Major IN (SELECT C.Dept
                          FROM    course C, enroll E
                          WHERE E.Sid = S.Sid AND E.Cno = C.Cno)
FROM   student S;

/*
 sid | ?column? 
-----+----------
 s1  | t
 s2  | t
 s3  | t
 s4  | f
(4 rows)
*/

/* Expressions in the WHERE clause */
CREATE TABLE Point(Pid text, X float, Y float);

INSERT INTO Point VALUES ('p1', 0, 0), ('p2', 1, 0), ('p3', 2, 1), ('p4', 5, 3);

TABLE Point;
/*
 pid | x | y 
-----+---+---
 p1  | 0 | 0
 p2  | 1 | 0
 p3  | 2 | 1
 p4  | 5 | 3
(4 rows)
*/

/*
 Find the pairs of points that are withing distance 3."
*/

SELECT P1.Pid AS P1, P2.Pid AS P2
FROM   Point P1, Point P2
WHERE  sqrt(power(P1.X-P2.X,2)+power(P1.Y-P2.Y,2)) <= 3;

/*
 p1 | p2 
----+----
 p1 | p1
 p1 | p2
 p1 | p3
 p2 | p1
 p2 | p2
 p2 | p3
 p3 | p1
 p3 | p2
 p3 | p3
 p4 | p4
(10 rows)
*/

/* 
Raise the salary of an employee by 5% provided that the raise is less
than $1000.”
*/
DELETE FROM employee;
INSERT INTO employee VALUES ('p1', 10000), ('p2', 10000), ('p3', 20000);

(SELECT  E.Eid, E.Salary*1.05 AS NewSalary
  FROM    employee E
  WHERE E.Salary*0.05< 1000)
UNION
(SELECT  E.Eid, E.Salary AS NewSalary
  FROM    employee E
  WHERE E.Salary*0.05 >= 1000) order by 1;

/*
 eid | newsalary 
-----+-----------
 p1  |  10500.00
 p2  |  10500.00
 p3  |     20000
(3 rows)
*/

/* Application: polynomials */
/* Representation of a poltynomial by
   a binary relation Polynomial(coefficient int, degree, int)
*/

CREATE TABLE Polynomial(coefficient int, degree int);

INSERT INTO Polynomial VALUES (3,3), (-5,1), (7,0);

TABLE Polynomial;

/* coefficient | degree 
-------------+--------
           3 |      3
          -5 |      1
           7 |      0
(3 rows)*/

/* This relation represent the polynomial 3x^3 -5x + 7 */

/* Derivative of a polynomial
   derivative(a*x^n) = a*n*x^(n-1) 
*/

/* The derivative of the above polynomial is
   9x^2 - 5
*/

SELECT t.degree*t.coefficient AS coefficient, t.degree-1 AS degree
FROM   Polynomial t
WHERE  t.degree >= 1;

/*
 coefficient | degree 
-------------+--------
           9 |      2
          -5 |      0
(2 rows)
*/
 

/* User-defined functions */

CREATE FUNCTION increment (n INTEGER)
    RETURNS INTEGER AS
    $$
        SELECT n+1;
    $$ LANGUAGE SQL;

SELECT increment(5) AS Value;

/* increment 
-----------
         6
(1 row)
*/


/* Alternative in PL/PGSQL */

/* We first need to drop the increment function */

DROP FUNCTION increment(integer);

CREATE FUNCTION increment(n integer) 
     RETURNS integer AS 
     $$ 
     BEGIN 
        RETURN n + 1; 
      END;
      $$ LANGUAGE plpgsql;


SELECT increment(5);

/*
 increment 
-----------
         6
(1 row)
*/


/* User-defined functions; the distance function
   between two points */

CREATE FUNCTION distance(x1 FLOAT, y1 FLOAT, x2 FLOAT, y2 FLOAT)
     RETURNS FLOAT AS
     $$
          SELECT sqrt(power(x1-x2,2)+power(y1-y2,2));
     $$  LANGUAGE SQL;

SELECT distance(0,0,1,1);
/*
    distance     
-----------------
 1.4142135623731
(1 row)
*/

TABLE Point;
/*
 pid | x | y 
-----+---+---
 p1  | 0 | 0
 p2  | 1 | 0
 p3  | 2 | 1
 p4  | 5 | 3
(4 rows)
*/


/* Find the pair of points that are within distance 3" */

SELECT P1.Pid AS P1, P2.Pid AS P2
FROM   Point P1, Point P2
WHERE  distance(P1.X,P1.Y,P2.X,P2.Y) <= 3;

/*
 p1 | p2 
----+----
 p1 | p1
 p1 | p2
 p1 | p3
 p2 | p1
 p2 | p2
 p2 | p3
 p3 | p1
 p3 | p2
 p3 | p3
 p4 | p4
(10 rows)
*/


/* Functions with output parameters */

CREATE FUNCTION sum_and_product(x int, y int, OUT sum int, OUT product int)
AS 
$$
     SELECT x+y, x*y;
$$  LANGUAGE SQL;


SELECT t.sum, t.product
FROM   sum_and_product(3,4) t;

/*
 sum | product 
-----+---------
   7 |      12
(1 row)
*/

/* Contrast this with the following */

SELECT sum_and_product(3,4);

/* The function returns a record (tuple) */

/*
 sum_and_product 
-----------------
 (7,12)
(1 row)
*/

SELECT (sum_and_product(3,4)).sum, (sum_and_product(3,4)).product;

/*
 sum | product 
-----+---------
   7 |      12
(1 row)
*/

/* Record (tuple) types */

CREATE TYPE edge AS (source INT, target INT); 

CREATE FUNCTION printEdge(x INT, y INT) RETURNS edge
AS $$ 
      SELECT x, y;
   $$ LANGUAGE SQL;


SELECT * FROM printEdge(1,2);

/*
 source | target 
--------+--------
      1 |      2
(1 row)
*/

SELECT source FROM printEdge(1,2);

/*
 source 
--------
      1
(1 row)
*/



/* The following will not work */
SELECT printEdge(1,2).source;
/*ERROR:  syntax error at or near "."
  LINE 1: SELECT printEdge(1,2).source;*/

/*Instead, you need to put a record with 
  pararentheses () as follows: */

SELECT (printEdge(1,2)).source;
/*
 source 
--------
      1
(1 row)
*/


/* Functions returning sets (relations) */

CREATE TABLE Pair(x int, y int);

INSERT INTO Pair VALUES (0,0), (0,1), (3,4);

CREATE FUNCTION sum_and_product(OUT sum int, OUT product int)
RETURNS SETOF RECORD
AS $$ 
     SELECT P.x+P.y, P.x*P.y FROM Pair P;
$$ LANGUAGE SQL;


SELECT * 
FROM   sum_and_product();

/* 
 sum | product 
-----+---------
   0 |       0
   1 |       0
   7 |      12
(3 rows)
*/

/* Alternative RETURNS TABLE */

DROP FUNCTION sum_and_product();

CREATE FUNCTION sum_and_product()
RETURNS TABLE (sum INTEGER, product INTEGER)
AS $$ 
     SELECT P.x+P.y, P.x*P.y FROM Pair P;
$$ LANGUAGE SQL;


DELETE FROM Pair;

INSERT INTO Pair VALUES (1,2), (3,-4);

TABLE Pair;
/*
 x | y  
---+----
 1 |  2
 3 | -4
(2 rows
*/

SELECT t.sum, t.product 
FROM   sum_and_product() t;

/*
 sum | product 
-----+---------
   3 |       2
  -1 |     -12
(2 rows)
*/

/* Caution: non determinism
Functions returning a record return a single record even if the body
of the function computes a set of record.
 */

DROP FUNCTION sum_and_product();

CREATE FUNCTION sum_and_product(OUT sum int, OUT product int)
RETURNS RECORD
AS $$ 
     SELECT P.x+P.y, P.x*P.y FROM Pair P ORDER BY RANDOM();
$$ LANGUAGE SQL;


SELECT * FROM sum_and_product();
/*
 sum | product 
-----+---------
   3 |       2
(1 row)
*/

SELECT * FROM sum_and_product();

/* sum | product 
-----+---------
  -1 |     -12
(1 row)
*/
















