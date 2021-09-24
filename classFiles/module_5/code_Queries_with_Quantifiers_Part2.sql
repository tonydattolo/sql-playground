/* Queries with quantifiers returning pairs */

/* Find each (s,d) pair such that student s
   takes 'quantifier' courses offered by department d */


CREATE OR REPLACE FUNCTION CoursesOfferedBy(dept TEXT) 
  RETURNS TABLE (cno TEXT) AS
  $$
   SELECT C.cno
   FROM   Course C
   WHERE  C.dept = CoursesOfferedBy.dept;
  $$ LANGUAGE SQL;


/* SOME quantifier */

/* Find each (s,d) pair such that student s
   takes SOME courses offered by department d */

/* The EXISTS (A INTERSECT B) template */

SELECT  sid, dept
FROM    Student, Department
WHERE   EXISTS ( SELECT cno
                 FROM   CoursesEnrolledIn(sid)
                  INTERSECT
                 SELECT cno
                 FROM   CoursesOfferedBy(dept)) order by 1;

/*
 sid  |    dept    
------+------------
 s100 | CS
 s100 | Math
 s101 | Math
 s101 | Philosophy
 s101 | CS
 s102 | CS
 s103 | Math
 s104 | Math
 s105 | CS
(9 rows)
*/

/* The EXISTS (A IN B) template */
SELECT sid, dept
FROM   Student, Department
WHERE  EXISTS (SELECT cno
               FROM   CoursesEnrolledIn(sid)
               WHERE  cno IN (SELECT cno
                              FROM   CoursesOfferedBy(dept))) order by 1;

/*
 sid  |    dept    
------+------------
 s100 | CS
 s100 | Math
 s101 | Math
 s101 | Philosophy
 s101 | CS
 s102 | CS
 s103 | Math
 s104 | Math
 s105 | CS
(9 rows)
*/

/* NO quantifier */

/* Find each (s,d) pair such that student s
   takes NO courses offered by department d */

/* The NOT EXISTS (A INTERSECT B) template */

SELECT  sid, dept
FROM    Student, Department
WHERE   NOT EXISTS ( SELECT cno
                     FROM   CoursesEnrolledIn(sid)
                      INTERSECT
                     SELECT cno
                     FROM   CoursesOfferedBy(dept)) order by 1;

/*
 sid  |    dept    
------+------------
 s100 | Biology
 s100 | Philosophy
 s101 | Biology
 s102 | Philosophy
 s102 | Math
 s102 | Biology
 s103 | CS
 s103 | Biology
 s103 | Philosophy
 s104 | Philosophy
 s104 | CS
 s104 | Biology
 s105 | Math
 s105 | Biology
 s105 | Philosophy
 s106 | Philosophy
 s106 | Biology
 s106 | Math
 s106 | CS
(19 rows)
*/


/* The NOT EXISTS (A IN B) template */

SELECT sid, dept
FROM   Student, Department
WHERE  NOT EXISTS (SELECT cno
                   FROM   CoursesEnrolledIn(sid)
                   WHERE  cno IN (SELECT cno
                                  FROM   CoursesOfferedBy(dept))) order by 1;

/*
 sid  |    dept    
------+------------
 s100 | Biology
 s100 | Philosophy
 s101 | Biology
 s102 | Philosophy
 s102 | Math
 s102 | Biology
 s103 | CS
 s103 | Biology
 s103 | Philosophy
 s104 | Philosophy
 s104 | CS
 s104 | Biology
 s105 | Math
 s105 | Biology
 s105 | Philosophy
 s106 | Philosophy
 s106 | Biology
 s106 | Math
 s106 | CS
(19 rows)
*/


/* NOT ONLY quantifier */

/* Find each (s,d) pair such that student s
   takes NOT ONLY courses offered by department d */

/* The EXISTS (A EXCEPT B) template */

SELECT  sid, dept
FROM    Student, Department
WHERE   EXISTS ( SELECT cno
                 FROM   CoursesEnrolledIn(sid)
                  EXCEPT
                 SELECT cno
                 FROM   CoursesOfferedBy(dept)) order by 1;

/*
 sid  |    dept    
------+------------
 s100 | CS
 s100 | Philosophy
 s100 | Math
 s100 | Biology
 s101 | CS
 s101 | Biology
 s101 | Philosophy
 s101 | Math
 s102 | Biology
 s102 | Math
 s102 | Philosophy
 s103 | Biology
 s103 | CS
 s103 | Philosophy
 s104 | CS
 s104 | Philosophy
 s104 | Biology
 s105 | Philosophy
 s105 | Math
 s105 | Biology
(20 rows)
*/

/* The EXISTS (A NOT IN B) template */

SELECT sid, dept
FROM   Student, Department
WHERE  EXISTS (SELECT cno
               FROM   CoursesEnrolledIn(sid)
               WHERE  cno NOT IN (SELECT cno
                                  FROM   CoursesOfferedBy(dept))) order by 1;

/*
 sid  |    dept    
------+------------
 s100 | CS
 s100 | Philosophy
 s100 | Math
 s100 | Biology
 s101 | CS
 s101 | Biology
 s101 | Philosophy
 s101 | Math
 s102 | Biology
 s102 | Math
 s102 | Philosophy
 s103 | Biology
 s103 | CS
 s103 | Philosophy
 s104 | CS
 s104 | Philosophy
 s104 | Biology
 s105 | Philosophy
 s105 | Math
 s105 | Biology
(20 rows)
*/


/* ONLY quantifier */

/* Find each (s,d) pair such that student s
   takes ONLY courses offered by department d */

/* The NOT EXISTS (A EXCEPT B) template */

SELECT  sid, dept
FROM    Student, Department
WHERE   NOT EXISTS ( SELECT cno
                     FROM   CoursesEnrolledIn(sid)
                      EXCEPT
                     SELECT cno
                     FROM   CoursesOfferedBy(dept)) order by 1;

/*
 sid  |    dept    
------+------------
 s102 | CS
 s103 | Math
 s104 | Math
 s105 | CS
 s106 | CS
 s106 | Math
 s106 | Biology
 s106 | Philosophy
(8 rows)
*/

/* The NOT EXISTS (A NOT IN B) template */

SELECT sid, dept
FROM   Student, Department
WHERE  NOT EXISTS (SELECT cno
                   FROM   CoursesEnrolledIn(sid)
                   WHERE  cno NOT IN (SELECT cno
                                      FROM   CoursesOfferedBy(dept))) order by 1;
/*
 sid  |    dept    
------+------------
 s102 | CS
 s103 | Math
 s104 | Math
 s105 | CS
 s106 | CS
 s106 | Math
 s106 | Biology
 s106 | Philosophy
(8 rows)
*/

/* NOT ALL quantifier */

/* Find each (s,d) pair such that student s
   takes NOT ALL courses offered by department d */

/* The EXISTS (B EXCEPT A) template */

SELECT  sid, dept
FROM    Student, Department
WHERE   EXISTS ( SELECT cno
                 FROM   CoursesOfferedBy(dept)
                   EXCEPT
                 SELECT cno
                 FROM   CoursesEnrolledIn(sid)) order by 1;

/*
 sid  |    dept    
------+------------
 s100 | CS
 s100 | Philosophy
 s102 | Philosophy
 s102 | Math
 s103 | Philosophy
 s103 | CS
 s104 | CS
 s104 | Philosophy
 s105 | Math
 s105 | CS
 s105 | Philosophy
 s106 | Philosophy
 s106 | CS
 s106 | Math
(14 rows)
*/


/* The EXISTS (B NOT IN A) template */

SELECT  sid, dept
FROM    Student, Department
WHERE   EXISTS ( SELECT cno
                 FROM   CoursesOfferedBy(dept)
                 WHERE  cno NOT IN (SELECT cno
                                    FROM   CoursesEnrolledIn(sid))) order by 1;

/*
 sid  |    dept    
------+------------
 s100 | CS
 s100 | Philosophy
 s102 | Philosophy
 s102 | Math
 s103 | Philosophy
 s103 | CS
 s104 | CS
 s104 | Philosophy
 s105 | Math
 s105 | CS
 s105 | Philosophy
 s106 | Philosophy
 s106 | CS
 s106 | Math
(14 rows)
*/


/* ALL quantifier */

/* Find each (s,d) pair such that student s
   takes ALL courses offered by department d */

/* The NOT EXISTS (B EXCEPT A) template */

SELECT  sid, dept
FROM    Student, Department
WHERE   NOT EXISTS ( SELECT cno
                     FROM   CoursesOfferedBy(dept)
                      EXCEPT
                     SELECT cno
                     FROM   CoursesEnrolledIn(sid)) order by 1;


/* The NOT EXISTS (B NOT IN A) template */

SELECT  sid, dept
FROM    Student, Department
WHERE   NOT EXISTS ( SELECT cno
                     FROM   CoursesOfferedBy(dept)
                     WHERE  cno NOT IN (SELECT cno
                                        FROM   CoursesEnrolledIn(sid))) order by 1;
/*
 sid  |    dept    
------+------------
 s100 | Math
 s100 | Biology
 s101 | Philosophy
 s101 | Math
 s101 | Biology
 s101 | CS
 s102 | CS
 s102 | Biology
 s103 | Math
 s103 | Biology
 s104 | Math
 s104 | Biology
 s105 | Biology
 s106 | Biology
(14 rows)
*/




