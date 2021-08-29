/* SQL code for Lecture 2: SQL-Part1.pptx */


/* 
Find the sids and names of students who major in CS.
*/
SELECT S.sid, S.sname
FROM   Student S
WHERE  S.major = 'CS';
/*
 sid | sname 
-----+-------
 s1  | John
 s3  | Eric
(2 rows
*/



/* SQL has bag semantics */
SELECT S.major
FROM   Student S;
/*  major  
---------
 CS
 Math
 CS
 Biology
(4 rows)
*/


/* Enforcing set semantics: DISTINCT clause */
SELECT DISTINCT S.major
FROM   Student S;
/*
  major  
---------
 Biology
 Math
 CS
(3 rows)
*/

/* EXPLAIN command in PostgresSQL; notice the difference between 
BAG and SET semantics
 */
EXPLAIN SELECT S.major
        FROM   Student S;
/*
                       QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on student  (cost=0.00..14.20 rows=420 width=48)
(1 row)
*/


EXPLAIN SELECT DISTINCT S.major
        FROM   Student S;
/*
                            QUERY PLAN                             
-------------------------------------------------------------------
 HashAggregate  (cost=15.25..17.25 rows=200 width=48)
   Group Key: major
   ->  Seq Scan on student s  (cost=0.00..14.20 rows=420 width=48)
(3 rows)
*/

EXPLAIN ANALYZE SELECT DISTINCT S.major
        FROM   Student S;
/*
                                               QUERY PLAN                                           
      
-----------------------------------------------------------------------------------------------------
------
 HashAggregate  (cost=15.25..17.25 rows=200 width=48) (actual time=0.325..0.326 rows=3 loops=1)
   Group Key: major
   ->  Seq Scan on student  (cost=0.00..14.20 rows=420 width=48) (actual time=0.306..0.307 rows=4 loo
ps=1)
 Planning time: 3.166 ms
 Execution time: 2.998 ms
(5 rows)
*/


/* Renaming attributes: the AS clause */
SELECT S.sid AS Identifier, S.sname AS Name 
FROM   Student S
WHERE  S.Major = 'CS';
/*
 identifier | name 
------------+------
 s1         | John
 s3         | Eric
(2 rows)
*/

/* Ordering the output: the ORDER BY cluase */
SELECT S.sid, S.sname 
FROM   Student S
WHERE  S.Major = 'CS'
ORDER BY sname;
/*
 sid | sname 
-----+-------
 s3  | Eric
 s1  | John
(2 rows)
*/


SELECT S.sid, S.sname 
FROM   Student S
WHERE  S.Major = 'CS'
ORDER BY 2;
/*
 sid | sname 
-----+-------
 s3  | Eric
 s1  | John
(2 rows)
*/


/* It is possible to randomly order the output of a query */
SELECT *
FROM   Student S
ORDER  BY RANDOM();
/*  sid | sname |  major  | byear 
-----+-------+---------+-------
 s2  | Ellen | Math    |  1995
 s1  | John  | CS      |  1990
 s4  | Ann   | Biology |  2001
 s3  | Eric  | CS      |  1990
(4 rows)
*/

/* Executing the same query may affect the order of the output */
SELECT *
FROM   Student S
ORDER  BY RANDOM();
/* sid | sname |  major  | byear 
-----+-------+---------+-------
 s3  | Eric  | CS      |  1990
 s2  | Ellen | Math    |  1995
 s1  | John  | CS      |  1990
 s4  | Ann   | Biology |  2001
(4 rows)
*/



/* Queries involving multiple relations */
SELECT S.sname, E.cno
FROM   Student S, Enroll E
WHERE  S.sid = E.sid AND E.grade = 'B';
/*
 sname | cno 
-------+-----
 John  | c1
 Ellen | c3
(2 rows)
*/

/* Sub-queries in the FROM clause */
SELECT S.sname, C.cno
FROM   Student S, (SELECT E.sid, E.cno
                   FROM   Enroll E
                   WHERE  E.grade = 'B') C
WHERE S.sid = C.Sid;
/*
 sname | cno 
-------+-----
 John  | c1
 Ellen | c3
(2 rows)
*/


/* Multiple variables ranging over the same relation 
Find the sid and name of each student enrolled in at least 2 courses.
*/
SELECT DISTINCT S.sid, S.sname
FROM   Student S, Enroll E1, Enroll E2
WHERE  S.sid = E1.sid AND S.sid = E2.Sid AND E1.cno <> E2.cno;
/* sid | sname 
-----+-------
 s1  | John
 s3  | Eric
(2 rows)
*/

/* Consider the same query but without DISTINCT */
SELECT S.sid, S.sname
FROM   Student S, Enroll E1, Enroll E2
WHERE  S.sid = E1.sid AND S.sid = E2.Sid AND E1.cno <> E2.cno;
/* 
 sid | sname 
-----+-------
 s1  | John
 s1  | John
 s3  | Eric
 s3  | Eric
(4 rows)
*/


/* Query with sub-query:  DISTINCT is NOT NECESSARY */
SELECT S.sid, S.sname
FROM   Student S
WHERE  S.sid IN (SELECT E1.sid
                 FROM   Enroll E1, Enroll E2
                 WHERE  E1.sid = E2.sid AND E1.cno <> E2.cno);
/* sid | sname 
-----+-------
 s1  | John
 s3  | Eric
(2 rows)
*/


/* Queries with set operations: UNION, INTERSECT, EXCEPT*/

/*Find the sids and names of all students who major in CS OR who major in Math.”
*/
(SELECT S.Sid, S.Sname
 FROM   Student S
 WHERE  S.Major = 'CS')
UNION
(SELECT S.Sid, S.Sname
 FROM   Student S
 WHERE  S.Major = 'Math');
/*
 sid | sname 
-----+-------
 s2  | Ellen
 s3  | Eric
 s1  | John
(3 rows)
*/

/* An equivalent version using OR in WHERE clause */
SELECT S.Sid, S.Sname
FROM   Student S
WHERE  S.Major = 'CS' OR S.major = 'Math';
/*
 sid | sname 
-----+-------
 s2  | Ellen
 s3  | Eric
 s1  | John
(3 rows)
*/

/*Find the sid of all student who are enrolled in course c1 and course c2
*/
(SELECT E.Sid
 FROM   Enroll E
 WHERE  E.Cno = 'c1')
INTERSECT
(SELECT E.Sid
 FROM   Enroll E
 WHERE  E.Cno = 'c2');
/* sid 
-----
 s1
 s3
(2 rows)
*/

/* Wrong alternative for the INTERSECT query*/
SELECT E.Sid
FROM   Enroll E
WHERE  E.cno = 'c1' AND E.cno = 'c2';
/* sid 
-----
(0 rows)
*/

/*Query with set difference: EXCEPT
Find the sids of all students who are enrolled in no courses.
*/
(SELECT S.Sid
 FROM   Student S)
EXCEPT
(SELECT E.Sid
 FROM   Enroll E);
/* sid 
-----
 s4
(1 row)
*/


/* Set operations use set semantics */
SELECT E.Sid
FROM   Enroll E;
/*
 sid 
-----
 s1
 s1
 s2
 s3
 s3
(5 rows)
*/
/* Notice that this result is a bag */

/* Now consider the following query using UNION;
   the result is a set, not a bag 
*/
(SELECT E.sid
 FROM   Enroll E)
UNION
(SELECT E.Sid
 FROM   Enroll E);
/*
 sid 
-----
 s1
 s2
 s3
(3 rows)
*/

