/* Code for Lecture on Quantifiers Using Count function */

/* We use the same data as in Lectures on Queries with Quantifiers
   and we consider many of the same queries discussed there */

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

/* Using COUNT function */

SELECT sid
FROM   Student S
WHERE (SELECT COUNT(1)
       FROM   (SELECT  cno
               FROM    CoursesEnrolledIn(sid) 
                 INTERSECT
               SELECT cno
               FROM   CS_Courses) q) >= 1;


/*
 sid  
------
 s100
 s101
 s102
 s105
(4 rows)
*/


/* NO quantifier */
/* Find the sid of each student who takes NO CS courses */

/* Using COUNT function */

SELECT sid
FROM   Student S
WHERE (SELECT COUNT(1)
       FROM   (SELECT  cno
               FROM    CoursesEnrolledIn(sid) 
                 INTERSECT
               SELECT cno
               FROM   CS_Courses) q) = 0;


/* sid  
------
 s103
 s104
 s106
(3 rows)
*/


/* NOT ONLY quantifier */
/* Find the sid of each student who takes NOT ONLY CS courses */


/* Using COUNT function */

SELECT sid
FROM   Student S
WHERE (SELECT COUNT(1)
       FROM   (SELECT  cno
               FROM    CoursesEnrolledIn(sid) 
                 EXCEPT
               SELECT cno
               FROM   CS_Courses) q) >= 1;

/* sid  
------
 s100
 s101
 s103
 s104
(4 rows)
*/


/* ONLY quantifier */
/* Find the sid of each student who takes ONLY CS courses */

/* Using COUNT Function */

SELECT sid
FROM   Student S
WHERE (SELECT COUNT(1)
       FROM   (SELECT  cno
               FROM    CoursesEnrolledIn(sid) 
                 EXCEPT
               SELECT cno
               FROM   CS_Courses) q) = 0;


/*
 sid  
------
 s102
 s105
 s106
(3 rows)
*/



/* NOT ALL quantifier */
/* Find the sid of each student who takes NOT ALL CS courses */

/* Using COUNT function */

SELECT sid
FROM   Student S
WHERE (SELECT COUNT(1)
       FROM   (SELECT  cno
               FROM    CS_courses
                 EXCEPT
               SELECT cno
               FROM   CoursesEnrolledIn(sid)) q)  >= 1;

/* ALL quantifier */
/* Find the sid of each student who takes ALL CS courses */

/* Using COUNT function */

SELECT sid
FROM   Student S
WHERE (SELECT COUNT(1)
       FROM   (SELECT  cno
               FROM    CS_courses
                 EXCEPT
               SELECT cno
               FROM   CoursesEnrolledIn(sid)) q)  = 0;

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

/* Using COUNT function */

SELECT sid
FROM   Student S
WHERE (SELECT COUNT(1)
       FROM   (SELECT  cno
               FROM    CS_courses
                 EXCEPT
               SELECT cno
               FROM   CoursesEnrolledIn(sid)) q)  = 0
       AND
       (SELECT COUNT(1)
        FROM   (SELECT  cno
                FROM   CoursesEnrolledIn(sid)
                 EXCEPT
                SELECT cno
                FROM   CS_courses) q)  = 0;


/* The AT LEAST two quantifier */
/* Find the sid of each student who takes AT LEAST TWO  CS courses */

/* Using COUNT function */

SELECT sid
FROM   Student S
WHERE (SELECT COUNT(1)
       FROM   (SELECT  cno
               FROM    CoursesEnrolledIn(sid) 
                 INTERSECT
               SELECT cno
               FROM   CS_Courses) q) >= 2;

/*
 sid  
------
 s100
 s101
 s102
 s105
(4 rows)
*/


/* ALL BUT ONE quantifier */
/* Find the sid of each student who takes ALL BUT ONE CS courses */

/* Using COUNT function */

SELECT sid
FROM   Student S
WHERE (SELECT COUNT(1)
       FROM   (SELECT  cno
               FROM    CS_courses
                 EXCEPT
               SELECT cno
               FROM   CoursesEnrolledIn(sid)) q)  = 1;

/*
 sid  
------
 s100
 s105
(2 rows)
*/





/* At least half of Quantifier */
/* Find the sid of each student who takes take at least
half of the CS courses */

/* Using COUNT function */

SELECT sid
FROM   Student S
WHERE  2*(SELECT COUNT(1)
          FROM   (SELECT  cno
                  FROM    CoursesEnrolledIn(sid)
                    INTERSECT
                  SELECT cno
                  FROM   CS_courses) q) 
       >=  (SELECT COUNT(1)
            FROM   CS_courses);

/*
sid  
------
 s100
 s101
 s102
 s105
(4 rows)
*/


