/* In this note, we develop RA expressions expressed in SQL for
queries with quantifiers of the form

"Find each the sid of each student who takes
 [some, no, not only, only, all, not all, at least 2]
 CS_courses"

 These queries can be supported with "set semijoins".
*/

/* The data:

table student;
 sid  | sname  |  major  | byear 
------+--------+---------+-------
 s100 | Eric   | CS      |  1987
 s101 | Nick   | Math    |  1990
 s102 | Chris  | Biology |  1976
 s103 | Dinska | CS      |  1977
 s104 | Zanna  | Math    |  2000
 s105 | Vince  | CS      |  2000
 s106 | Linda  | Biology |  1990
(7 rows)

table course;
 cno  |  cname   |    dept    
------+----------+------------
 c200 | PL       | CS
 c201 | Calculus | Math
 c202 | Dbs      | CS
 c301 | AI       | CS
 c302 | Logic    | Philosophy
(5 rows)

table enroll;
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
(15 rows)

/* To develop the RA expressions, we
define various views*
*/

create or replace  view S as 
  (select distinct sid from student order by 1);

create or replace  view CS as
  (select cno from course where dept = 'CS' order by 1);

/* Let us look at the data associate with these views *

postgres=# table S;
 sid  
------
 s100
 s101
 s102
 s103
 s104
 s105
 s106
(7 rows)

postgres=# table CS;
 cno  
------
 c200
 c202
 c301
(3 rows)


/* We are now ready to express or queries */

/* "Find the sid of each student who takes SOME CS course */

select distinct sid
from   Enroll
       NATURAL JOIN CS;


/* sid  
------
 s100
 s101
 s102
 s105
(4 rows) */

/* "Find the sid of each student who takes NO course */

select sid
from   S
except
select distinct sid
from   Enroll
       NATURAL JOIN CS;

/* sid  
------
 s104
 s103
 s106
(3 rows)
*/


/* "Find the sid of each student who takes NOT ONLY CS courses */

select distinct sid
from   (select sid, cno
        from   Enroll
        except
        select distinct sid, cno
        from   Enroll
        NATURAL JOIN CS) q;

/* sid  
------
 s100
 s101
 s103
 s104
(4 rows)
*/

/* "Find the sid of each student who takes ONLY CS courses */

select sid
from   student_sid
except
select distinct sid
from   (select sid, cno
        from   Enroll
        except
        select distinct sid, cno
        from   Enroll
        NATURAL JOIN CS) q;


/*
 sid  
------
 s102
 s105
 s106
(3 rows)
*/


/* "Find the sid of each student who takes NOT ALL CS courses */

select distinct sid
from   (select sid, cno
        from   S cross join CS
        except
        select distinct sid, cno
        from   Enroll
        NATURAL JOIN CS) q;

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


/* "Find the sid of each student who takes ALL CS courses */

select sid
from   S
except
select distinct sid
from   (select sid, cno
        from   S cross join CS
        except
        select distinct sid, cno
        from   Enroll
        NATURAL JOIN CS) q;

/*
 sid  
------
 s102
 s101
(2 rows)
*/


/* "Find the sid of each student who takes at least 2 CS courses */

with    E  as
        (select sid, cno
         from   Enroll 
                NATURAL JOIN CS)    
select  distinct e1.sid
from    E e1 JOIN E e2 ON (e1.sid = e2.sid AND e1.cno <> e2.cno);

where   p1.sid = p2.sid and p1.cno <> p2.cno;

/*
 sid  
------
 s100
 s101
 s102
 s105
(4 rows)

*/





