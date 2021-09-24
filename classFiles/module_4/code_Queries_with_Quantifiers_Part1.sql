/* Code for lecture on Queries with Quantifiers (Part 1)*/

INSERT INTO ENROLL VALUES 
 ('s100','c200', 'A'),
 ('s100','c201', 'B'),
 ('s100','c202', 'A'),
 ('s101','c200', 'B'),
 ('s101','c201', 'A'),
 ('s102','c200', 'B'),
 ('s103','c201', 'A'),
 ('s101', 'c301', 'C'),
 ('s101', 'c302', 'A'),
 ('s102','c202', 'A'),
 ('s102', 'c301', 'B'),
 ('s104','c201', 'D'),
 ('s101','c202', 'A'),
 ('s105','c200', 'A'),
 ('s105','c202', 'A');


INSERT INTO Student VALUES
('s100','Eric','CS', 1987),
('s101','Nick','Math', 1990),
('s102','Chris','Biology', 1976),
('s103','Dinska','CS', 1977),
('s104','Zanna','Math', 2000),
('s105','Vince','CS', 2000),
('s106','Linda','Biology', 1990);


INSERT INTO Course VALUES
('c200', 'PL' ,'CS'),
('c201','Calculus','Math'),
('c202','Dbs','CS'),
('c301','AI','CS'),
('c302','Logic','Philosophy');

INSERT INTO Department VALUES
('CS', 'Luddy Hall'),
('Math', 'Swain Hall'),
('Biology', 'Lindley Hall'),



/* SOME quantifier */
/* Find the sid of each student who takes SOME CS courses */

/* EXISTS (A INTERSECT B) pattern */

SELECT S.sid
FROM   Student S
WHERE  EXISTS ((SELECT E.cno
                FROM   Enroll E
                WHERE  E.sid = S.sid)
                INTERSECT
               (SELECT C.cno
                FROM   Course C
                WHERE  C.dept = 'CS'));
/*
 sid  
------
 s100
 s101
 s102
 s105
(4 rows)
*/

/* EXISTS (A IN B) pattern */

SELECT S.sid
FROM   Student S
WHERE  EXISTS (SELECT E.cno
               FROM   Enroll E
               WHERE E.sid = S.sid AND
                         E.cno IN (SELECT C.cno
                                   FROM    Course C
                                   WHERE C.dept = 'CS'));
/*
 sid  
------
 s100
 s101
 s102
 s105
(4 rows)
*/


/* SOME is a very special case; we can solve it with join condition: */

SELECT DISTINCT E.Sid
FROM   Enroll E, Course C
WHERE  E.Cno = C.Cno AND C.Dept = 'CS';

/*
 sid  
------
 s101
 s100
 s105
 s102
(4 rows)
*/


/* Create appropriate views and parameterized views */


CREATE VIEW CS_courses AS
  (SELECT C.cno AS cno
   FROM   Course C
   WHERE  C.dept = 'CS');

TABLE CS_courses;

/*
 cno  
------
 c200
 c202
 c301
(3 rows)
*/


CREATE OR REPLACE FUNCTION CoursesEnrolledIn(sid TEXT)
  RETURNS TABLE (cno TEXT) AS
  $$
    SELECT E.cno
    FROM   Enroll E
    WHERE  E.sid = CoursesEnrolledIn.sid;
  $$ LANGUAGE SQL;

/* SOME Using views  
   EXISTS (A INTERSECT B) template  
*/

SELECT sid
FROM   Student
WHERE  EXISTS (SELECT cno
               FROM   CoursesEnrolledIn(sid)
                INTERSECT
               SELECT cno
               FROM   CS_Courses);

/*
 sid  
------
 s100
 s101
 s102
 s105
(4 rows)
*/


/* SOME Using views 
   EXISTS (A IN B) template
*/

SELECT sid
FROM   Student
WHERE  EXISTS (SELECT cno
               FROM   CoursesEnrolledIn(sid)
               WHERE  cno IN (SELECT cno

/*
 sid  
------
 s100
 s101
 s102
 s105
(4 rows)
*/


/* NO quantifier  Using Views*/
/* Find the sid of each student who takes NO CS courses */

/* NOT EXISTS (A INTERSECT B) pattern */

SELECT sid
FROM   Student
WHERE  NOT EXISTS (SELECT cno
                   FROM   CoursesEnrolledIn(sid)
                     INTERSECT
                   SELECT cno
                   FROM   CS_Courses);

/* sid  
------
 s103
 s104
 s106
(3 rows)
*/


/* NOT EXISTS (A IN B) pattern */

SELECT sid
FROM   Student
WHERE  NOT EXISTS (SELECT cno
                   FROM   CoursesEnrolledIn(sid)
                   WHERE  cno IN (SELECT cno
                                  FROM   CS_courses));
/*
 sid  
------
 s103
 s104
 s106
(3 rows)
*/



/* NOT ONLY quantifier (Using views)*/
/* Find the sid of each student who takes NOT ONLY CS courses */

/* EXISTS (A EXCEPT B) pattern */

SELECT sid
FROM   Student
WHERE  EXISTS (SELECT cno
               FROM   CoursesEnrolledIn(sid)
                EXCEPT
               SELECT cno
               FROM   CS_Courses);

/* sid  
------
 s100
 s101
 s103
 s104
(4 rows)
*/


/* EXISTS (A NOT IN B) pattern */

SELECT sid
FROM   Student
WHERE  EXISTS (SELECT cno
               FROM   CoursesEnrolledIn(sid)
               WHERE  cno NOT IN (SELECT cno
                                  FROM   CS_courses));

/*
 sid  
------
 s100
 s101
 s103
 s104
(4 rows)
*/


/* ONLY quantifier (Using views) */
/* Find the sid of each student who takes ONLY CS courses */

/* NOT EXISTS (A EXCEPT B) pattern */

SELECT sid
FROM   Student
WHERE  NOT EXISTS (SELECT cno
                   FROM   CoursesEnrolledIn(sid)
                     EXCEPT
                   SELECT cno
                   FROM   CS_Courses);

/*
 sid  
------
 s102
 s105
 s106
(3 rows)
*/

/* NOT EXISTS (A NOT IN B) pattern */

SELECT sid
FROM   Student
WHERE  NOT EXISTS (SELECT cno
                   FROM   CoursesEnrolledIn(sid)
                   WHERE  cno NOT IN (SELECT cno
                                      FROM   CS_courses));

/*
 sid  
------
 s102
 s105
 s106
(3 rows)
*/



/* NOT ALL quantifier (Using views)*/
/* Find the sid of each student who takes NOT ALL CS courses */

/* The EXISTS ( B EXCEPT A) pattern */

SELECT sid
FROM   Student
WHERE  EXISTS (SELECT cno
               FROM   CS_courses
                 EXCEPT
               SELECT cno
               FROM   CoursesEnrolledIn(sid));

/*
 sid  
------
 s100
 s103
 s104
 s105
 s106
(5 rows)
*/

/* The EXISTS (B NOT IN A) template */

SELECT sid
FROM   Student
WHERE  EXISTS (SELECT cno
               FROM   CS_courses
               WHERE  cno NOT IN (SELECT cno
                                  FROM   CoursesEnrolledIn(sid)));
/*
 sid  
------
 s100
 s103
 s104
 s105
 s106
(5 rows)
*/


/* ALL quantifier (Using views) */
/* Find the sid of each student who takes ALL CS courses */

/* The NOT EXISTS ( B EXCEPT A) pattern */

SELECT sid
FROM   Student
WHERE  NOT EXISTS (SELECT cno
                   FROM   CS_courses
                    EXCEPT
                   SELECT cno
                   FROM   CoursesEnrolledIn(sid));


/*
 sid  
------
 s101
 s102
(2 rows)
*/


/* The NOT EXISTS (B NOT IN A) template */

SELECT sid
FROM   Student
WHERE  NOT EXISTS (SELECT cno
                   FROM   CS_courses
                   WHERE  cno NOT IN (SELECT cno
                                      FROM   CoursesEnrolledIn(sid)));


/*
 sid  
------
 s101
 s102
(2 rows)
*/


/* ALL and ONLY quantifier */
/* Find the sid of each student who takes ALL AND ONLY CS courses */

/* The ALL template AND
       ONLY template */

SELECT sid
FROM   Student
WHERE  NOT EXISTS (SELECT cno
                   FROM   CS_courses
                    EXCEPT
                   SELECT cno
                   FROM   CoursesEnrolledIn(sid))
       AND 
       NOT EXISTS (SELECT cno
                   FROM   CoursesEnrolledIn(sid)
                    EXCEPT
                   SELECT cno
                   FROM   CS_courses);


/*
 sid  
------
 s102
(1 row)
*/


/* The ALL template AND
       ONLY template */

SELECT sid
FROM   Student
WHERE  NOT EXISTS (SELECT cno
                   FROM   CS_courses
                   WHERE  cno NOT IN (SELECT cno
                                      FROM   CoursesEnrolledIn(sid)))
       AND
       NOT EXISTS (SELECT cno
                   FROM   CoursesEnrolledIn(sid)
                   WHERE  cno NOT IN (SELECT cno
                                      FROM   CS_courses));

/*
 sid  
------
 s102
(1 row)
*/


/* The AT LEAST two quantifier */
/* Find the sid of each student who takes AT LEAST TWO  CS courses */

SELECT  sid
FROM    Student
WHERE   EXISTS (SELECT 1
                FROM   CoursesEnrolledIn(sid) C1,
                       CoursesEnrolledIn(sid) C2
                WHERE  C1.cno <> C2.cno AND
                       C1.cno IN (SELECT cno 
                                  FROM   CS_courses) AND
                       C2.cno IN (SELECT cno 
                                  FROM   CS_courses));
/*
 sid  
------
 s100
 s101
 s102
 s105
(4 rows)
*/


/* The AT LEAST two quantifier */
/* Find the sid of each student who takes FEWER THAN TWO  CS courses */

SELECT  sid
FROM    Student
WHERE   NOT EXISTS (SELECT 1
                    FROM   CoursesEnrolledIn(sid) C1,
                           CoursesEnrolledIn(sid) C2
                     WHERE  C1.cno <> C2.cno AND
                           C1.cno IN (SELECT cno 
                                      FROM   CS_courses) AND
                           C2.cno IN (SELECT cno 
                                      FROM   CS_courses));
/*
 sid  
------
 s100
 s101
 s102
 s105
(4 rows)
*/

/*
 sid  
------
 s103
 s104
 s106
(3 rows)
*/
