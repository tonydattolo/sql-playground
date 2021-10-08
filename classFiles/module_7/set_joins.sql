/* The following are the queries for set joins developped in the
Lecture on Setjoins */

table student;

/*
 sid  | sname  |   major    | byear 
------+--------+------------+-------
 s100 | Eric   | CS         |  1987
 s101 | Nick   | Math       |  1990
 s102 | Chris  | Biology    |  1976
 s103 | Dinska | CS         |  1977
 s104 | Zanna  | Math       |  2000
 s105 | Vince  | CS         |  2000
 s106 | Linda  | Biology    |  1990
 s107 | Yvonne | Philosophy |  1960
(8 rows)
*/

table course;

/*
 cno  |      cname      |    dept    
------+-----------------+------------
 c200 | PL              | CS
 c201 | Calculus        | Math
 c202 | Dbs             | CS
 c301 | AI              | CS
 c302 | Logic           | Philosophy
 c400 | MachineLearning | 
(6 rows)
*/

table professor;

/*
 pid |     pname     
-----+---------------
 p1  | MemoDalkilic
 p2  | FundaErgun
 p3  | HaixuTang
 p4  | SuzanneMenzel
 p5  | MelanieWu
 p6  | DirkVanGucht
(6 rows)
*/


table enroll;

/*
 sid  | cno  | grade 
------+------+-------
 s100 | c200 | A
 s100 | c201 | B
 s100 | c202 | A
 s101 | c200 | B
 s101 | c201 | A
 s102 | c200 | B
 s103 | c201 | A
 s101 | c301 | C
 s101 | c302 | A
 s102 | c202 | A
 s102 | c301 | B
 s104 | c201 | D
 s101 | c202 | A
 s105 | c200 | A
 s105 | c202 | A
 s107 | c400 | B
(16 rows)
*/


table taughtby;

/*
 pid | cno  
-----+------
 p1  | c200
 p1  | c201
 p1  | c202
 p1  | c301
 p2  | c200
 p2  | c202
 p3  | c301
 p3  | 302
 p4  | c301
 p4  | 302
 p4  | 200
 p5  | c301
 p6  | c400
 p6  | c200
(14 rows)
*/

create or replace view S AS
  (select sid from student);

table s;

/*
 sid  
------
 s100
 s101
 s102
 s103
 s104
 s105
 s106
 s107
(8 rows)
*/

create or replace view P AS
  (select pid from professor);

table p;

/*
 pid 
-----
 p1
 p2
 p3
 p4
 p5
 p6
(6 rows)
*/



/* SOME set join */

select  distinct sid, pid
from    enroll NATURAL JOIN taughtby order by 1,2;

/*
 sid  | pid 
------+-----
 s100 | p1
 s100 | p2
 s100 | p6
 s101 | p1
 s101 | p2
 s101 | p3
 s101 | p4
 s101 | p5
 s101 | p6
 s102 | p1
 s102 | p2
 s102 | p3
 s102 | p4
 s102 | p5
 s102 | p6
 s103 | p1
 s104 | p1
 s105 | p1
 s105 | p2
 s105 | p6
 s107 | p6
(21 rows)
*/

/* NO set join */

select sid, pid
from   S cross join P
except 
select  distinct sid, pid
from    enroll NATURAL JOIN taughtby;

/*
 sid  | pid 
------+-----
 s100 | p4
 s100 | p5
 s100 | p3
 s103 | p4
 s103 | p5
 s103 | p2
 s103 | p3
 s106 | p6
 s104 | p3
 s104 | p4
 s104 | p5
 s104 | p2
 s106 | p3
 s103 | p6
 s106 | p1
 s106 | p4
 s106 | p2
 s106 | p5
 s105 | p3
 s105 | p4
 s104 | p6
 s105 | p5
 s107 | p1
 s107 | p3
 s107 | p5
 s107 | p2
 s107 | p4
(27 rows)
*/

/* NOT ONLY set join */

SELECT distinct sid, pid
FROM   (SELECT sid, cno, pid
        FROM   Enroll CROSS JOIN P
        EXCEPT
        SELECT sid, cno, pid
        FROM   Enroll NATURAL JOIN Taughtby) q order by 1,2;


/*
 sid  | pid 
------+-----
 s100 | p2
 s100 | p3
 s100 | p4
 s100 | p5
 s100 | p6
 s101 | p1
 s101 | p2
 s101 | p3
 s101 | p4
 s101 | p5
 s101 | p6
 s102 | p2
 s102 | p3
 s102 | p4
 s102 | p5
 s102 | p6
 s103 | p2
 s103 | p3
 s103 | p4
 s103 | p5
 s103 | p6
 s104 | p2
 s104 | p3
 s104 | p4
 s104 | p5
 s104 | p6
 s105 | p3
 s105 | p4
 s105 | p5
 s105 | p6
 s107 | p1
 s107 | p2
 s107 | p3
 s107 | p4
 s107 | p5
(35 rows)
*/

/* ONLY set join */

SELECT sid, pid
FROM   S CROSS JOIN P
EXCEPT
SELECT distinct sid, pid
FROM   (SELECT sid, cno, pid
        FROM   Enroll CROSS JOIN P
        EXCEPT
        SELECT sid, cno, pid
        FROM   Enroll NATURAL JOIN Taughtby) q order by 1,2;

/*
 sid  | pid 
------+-----
 s100 | p1
 s102 | p1
 s103 | p1
 s104 | p1
 s105 | p1
 s105 | p2
 s106 | p1
 s106 | p2
 s106 | p3
 s106 | p4
 s106 | p5
 s106 | p6
 s107 | p6
(13 rows)
*/

/* NOT ALL set join */

SELECT distinct sid, pid
FROM   (SELECT sid, cno, pid
        FROM   S CROSS JOIN TaughtBy
        EXCEPT
        SELECT sid, cno, pid
        FROM   Enroll NATURAL JOIN TaughtBy) q order by 1,2;

/*
 sid  | pid 
------+-----
 s100 | p1
 s100 | p3
 s100 | p4
 s100 | p5
 s100 | p6
 s101 | p3
 s101 | p4
 s101 | p6
 s102 | p1
 s102 | p3
 s102 | p4
 s102 | p6
 s103 | p1
 s103 | p2
 s103 | p3
 s103 | p4
 s103 | p5
 s103 | p6
 s104 | p1
 s104 | p2
 s104 | p3
 s104 | p4
 s104 | p5
 s104 | p6
 s105 | p1
 s105 | p3
 s105 | p4
 s105 | p5
 s105 | p6
 s106 | p1
 s106 | p2
 s106 | p3
 s106 | p4
 s106 | p5
 s106 | p6
 s107 | p1
 s107 | p2
 s107 | p3
 s107 | p4
 s107 | p5
 s107 | p6
(41 rows)
*/

/* ALL set join */

SELECT sid, pid
FROM   S CROSS JOIN P
EXCEPT
SELECT distinct sid, pid
FROM   (SELECT sid, cno, pid
        FROM   S CROSS JOIN TaughtBy
        EXCEPT
        SELECT sid, cno, pid
        FROM   Enroll NATURAL JOIN TaughtBy) q order by 1,2;

/*
 sid  | pid 
------+-----
 s100 | p2
 s101 | p1
 s101 | p2
 s101 | p5
 s102 | p2
 s102 | p5
 s105 | p2
(7 rows)
*/

