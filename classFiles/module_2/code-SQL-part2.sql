/* SQL code for Lecture SQL_part2 */

/* Find the sids of students who are enrolled in CS courses.*/
SELECT DISTINCT E.Sid
FROM   Enroll E, Course C
WHERE  E.Cno = C.Cno AND C.Dept = 'CS';
/*
 sid 
-----
 s1
 s3
(2 rows)
*/

/* The IN and NOT IN predicates */
SELECT DISTINCT E.Sid
FROM   Enroll E
WHERE  E.Cno IN (SELECT C.Cno
                 FROM   Course C
                 WHERE C.Dept = 'CS');
/*
 sid 
-----
 s1
 s3
(2 rows)
*/

/* A query with the NOT IN predicate:
Find the sids of students who are enrolled in a course that is not 
offered by the CS department.*/
SELECT DISTINCT E.Sid
FROM   Enroll E
WHERE  E.Cno NOT IN (SELECT C.Cno
                     FROM   Course C
                     WHERE  C.Dept = 'CS') order by 1;
/*
 sid 
-----
 s1
 s2
 s3
(3 rows)
*/


/* The above query is not the same as 
“Find the sids of students who take no CS courses.”*/
(SELECT S.Sid
 FROM   Student S)
EXCEPT
(SELECT E.Sid
 FROM   Enroll E, Course C
 WHERE  E.Cno = C.Cno AND C.Dept = 'CS');
/*
 sid 
-----
 s2
 s4
(2 rows)
*/

/* Combining the IN and NOT IN predicates */
/*
"Among the students who take a least one Math course, 
find those who ONLY take Math courses."
*/
(SELECT E.Sid
 FROM   Enroll E
 WHERE  E.Cno IN (SELECT C.Cno
                  FROM   Course C
                  WHERE  C.Dept = 'Math'))
EXCEPT
(SELECT E.Sid
 FROM   Enroll E
 WHERE  E.Cno NOT IN (SELECT C.Cno
                      FROM   Course C
                      WHERE  C.Dept = 'Math'));
/*
 sid 
-----
 s2
(1 row)
*/

/* Tuple in the IN predicate */
/* 
“Find the sids and names of students who take a course in the department 
in which they major.”
*/
SELECT S.Sid, S.Sname
FROM   Student S
WHERE  (S.Sid, S.Major) IN (SELECT E.Sid, C.Dept
                            FROM   Enroll E, Course C
                            WHERE  E.Cno = C.Cno)

/*
 sid | sname 
-----+-------
 s1  | John
 s2  | Ellen
 s3  | Eric
(3 rows)
*/

/* The SOME predicate */
/* "Find the sids of students who are enrolled in a CS course" */
/* <=> 
   "Find the sids of students who are enrolled in SOME CS course" */
SELECT DISTINCT E.Sid
FROM   Enroll E
WHERE  E.Cno IN (SELECT C.Cno 
                 FROM   Course C 
                 WHERE  C.Dept = 'CS');
/*
 sid 
-----
 s1
 s3
(2 rows)
*/

/* using the SOME predicate, this ie equivalent with: */
SELECT DISTINCT E.Sid
FROM   Enroll E
WHERE  E.Cno = SOME (SELECT C.Cno 
                     FROM   Course C 
                     WHERE C.Dept = 'CS');
/*
 sid 
-----
 s1
 s3
(2 rows)
*/

/* The ALL predicate */
CREATE TABLE Person (pid text,
                     age integer);

INSERT INTO Person VALUES ('p1', 10),
                          ('p2',  9),
                          ('p3', 12),
                          ('p4',  9);

TABLE Person;
/*
 pid | age 
-----+-----
 p1  |  10
 p2  |   9
 p3  |  12
 p4  |   9
(4 rows)
*/

/* The ALL predicate */
/*
    "Find the pids of the youngest persons.”  
*/

SELECT P.Pid
FROM   Person P
WHERE  P.Age <= ALL (SELECT P1.Age 
                     FROM Person P1);
/*
 pid 
-----
 p2
 p4
(2 rows)
*/

/* The following SQL is incorrect since it will
   always give an incorrect result */
SELECT P.Pid
FROM   Person P
WHERE  P.Age < ALL (SELECT P1.Age 
                    FROM Person P1);
/*
 pid 
-----
(0 rows)
*/

/* The EXISTS and NOT EXISTS predicates */
/* 
“Find the sids of students whose name is John provided 
 that there exist students who major in CS.”
*/
SELECT S.Sid
FROM   Student S
WHERE  S.Sname = 'John' AND EXISTS (SELECT S1.Sid
                                    FROM   Student S1
                                    WHERE  S1.Major = 'CS');
/*
 sid 
-----
 s1
(1 row)
*/


/* Sub-queries with parameters */
/* 
   “Find the sids of student who are enrolled in a course.”
*/
SELECT S.Sid
FROM   Student S
WHERE  EXISTS (SELECT E.Cno
               FROM   Enroll E
               WHERE  S.Sid = E.Sid); 
/*
 sid 
-----
 s1
 s2
 s3
(3 rows)
*/

/* The NOT EXISTS predicate */
/*
  "Find the sids of students who do not take any courses."
*/
SELECT S.Sid
FROM   Student S
WHERE  NOT EXISTS (SELECT E.Cno
                   FROM   Enroll E
                   WHERE  S.Sid = E.Sid);
/*
 sid 
-----
 s4
(1 row)
*/


/* Putting multiple set predicates to together */
/*
  Find the majors of students named Ellen who do not take any CS course."
*/
SELECT S.Major
FROM   Student S
WHERE  S.Sname = 'Ellen' AND 
       NOT EXISTS (SELECT C.cno
                   FROM   Course C
                   WHERE  C.dept = 'CS' AND
                          C.Cno IN (SELECT E.cno
                                    FROM   Enroll E
                                    WHERE  E.sid = S.sid));
/*
  major 
  -------
  Math
  (1 row)
*/

/*
  "Find the sids of students who take all CS courses.”
  <=>
  "Find the sids of students for whom there does not exist a CS course 
  they are not enrolled in.”
*/
SELECT S.Sid
FROM   Student S
WHERE  NOT EXISTS (SELECT C.Cno
                   FROM   Course C
                   WHERE  C.Dept = 'CS' AND
                          C.Cno NOT IN (SELECT E.Cno
                                        FROM   Enroll E
                                        WHERE  S.Sid = E.Sid));
/*
sid 
-----
 s1
 s3
(2 rows)
*/


/*
  “Find pairs of sids (s1,s2) such that all courses taken by s1 are also taken by s2”
*/
SELECT S1.Sid AS S1, S2.Sid AS S2
FROM   Student S1, Student S2
WHERE  S1.Sid <> S2.Sid AND
       NOT EXISTS (SELECT C1.Cno
                   FROM   Course C1, Enroll E1
                   WHERE  S1.Sid = E1.Sid AND C1.Cno = E1.Cno AND
                          C1.Cno NOT IN (SELECT C2.Cno
                                         FROM   Course C2, Enroll E2
                                         WHERE  S2.Sid = E2.Sid AND C2.Cno = E2.Cno));
/*
 s1 | s2 
----+----
 s1 | s3
 s3 | s1
 s4 | s1
 s4 | s2
 s4 | s3
(5 rows)
*/









