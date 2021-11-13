-- Example of some type and populating nested relation

CREATE TYPE fooType AS (C int, D int);
CREATE TYPE barType AS (A int, B fooType[]);

CREATE TABLE tableTest(X int, Y barType[]);

insert into tableTest values (1, array[]::bartype []);

insert into tableTest values 
     (2, array[(2, array[(3,4)]::fooType[])]::bartype[]);


insert into tableTest values 
     (3, array[(3, array[(4,5)]::fooType[]),
               (4, array[(5,6),(6,7)]::fooType[])]::bartype[]);


-- We now go into creating nested relation based on Enroll relation

insert into enroll values 
     ('s100','c200', 'A'),
     ('s100','c201', 'B'),
     ('s100','c202', 'A'),
     ('s101','c200', 'B'),
     ('s101','c201', 'A'),
     ('s102','c200', 'B'),
     ('s103','c201', 'A'),
     ('s101','c202', 'A'),
     ('s101','c301', 'C'),
     ('s101','c302', 'A'),
     ('s102','c202', 'A'),
     ('s102','c301', 'B'),
     ('s102','c302', 'A'),
     ('s104','c201', 'D');

table course;

/* cno  |  cname   |    dept    
------+----------+------------
 c200 | PL       | CS
 c201 | Calculus | Math
 c202 | Dbs      | CS
 c301 | AI       | CS
 c302 | Logic    | Philosophy
(5 rows)
*/

table student;
/*
 sid  | sname  |  major  | byear 
------+--------+---------+-------
 s100 | Eric   | CS      |  1987
 s101 | Nick   | Math    |  1990
 s102 | Chris  | Biology |  1976
 s103 | Dinska | CS      |  1977
 s104 | Zanna  | Math    |  2000
(5 rows)
*/


-- Making nested relations
-- We assume a relation Enroll of type (sid, cno, grade)

select * from enroll order by sid, cno, grade;

/*
 sid  | cno  | grade 
------+------+-------
 s100 | c200 | A
 s100 | c201 | B
 s100 | c202 | A
 s101 | c200 | B
 s101 | c201 | A
 s101 | c202 | A
 s101 | c301 | C
 s101 | c302 | A
 s102 | c200 | B
 s102 | c202 | A
 s102 | c301 | B
 s102 | c302 | A
 s103 | c201 | A
 s104 | c201 | D
(14 rows)
*/


-- We want to make a relation Enroll_Info of type
--      (sid, grades{(grade, courses{class(cno)})})

CREATE TYPE studentType AS (sid text);
CREATE TYPE courseType as (cno text);

CREATE TYPE gradeCoursesType AS (grade text, courses courseType[]);
CREATE TABLE studentGrades(sid text, gradeInfo gradeCoursesType[]);

CREATE TYPE gradeStudentsType AS (grade text, student studentType[]);
CREATE TABLE courseGrades(cno text, gradeInfo gradeStudentsType[]);


-- We now restructure the Enroll relation and insert it in
-- the studentGrades


insert into studentGrades
with e as (select sid, grade, array_agg(row(cno)::courseType) as courses
           from enroll
           group by (sid, grade)),

     f as (select sid, array_agg(row(grade, courses)::gradeCoursesType) as gradeInfo
           from e
           group by (sid))

select * from f order by sid;

/*
 sid  |                                gradeinfo                                 
------+--------------------------------------------------------------------------
 s100 | {"(A,\"{(c200),(c202)}\")","(B,\"{(c201)}\")"}
 s101 | {"(B,\"{(c200)}\")","(A,\"{(c201),(c202),(c302)}\")","(C,\"{(c301)}\")"}
 s102 | {"(A,\"{(c202),(c302)}\")","(B,\"{(c200),(c301)}\")"}
 s103 | {"(A,\"{(c201)}\")"}
 s104 | {"(D,\"{(c201)}\")"}
(5 rows)
*/


-- We now restructure the Enroll relation and insert it in
-- the courseGrades relation


insert into courseGrades
with e as (select cno, grade, array_agg(row(sid)::studentType) as students
           from enroll
           group by (cno, grade)),

     f as (select cno, array_agg(row(grade, students)::gradeStudentsType) as gradeInfo
           from e
           group by (cno))

select * from f order by cno;


/*
 cno  |                             gradeinfo                             
------+-------------------------------------------------------------------
 c200 | {"(B,\"{(s101),(s102)}\")","(A,\"{(s100)}\")"}
 c201 | {"(D,\"{(s104)}\")","(B,\"{(s100)}\")","(A,\"{(s101),(s103)}\")"}
 c202 | {"(A,\"{(s100),(s101),(s102)}\")"}
 c301 | {"(B,\"{(s102)}\")","(C,\"{(s101)}\")"}
 c302 | {"(A,\"{(s101),(s102)}\")"}
(5 rows)
*/


-- We can now query the studentGrades table                                                                                                                                        
-- Find the grade information of each student who received an 'A' in some course                                                                                                   
select sid, gradeInfo
from   studentGrades sg
where  'A' IN (select  g.grade
               from    unnest(sg.gradeInfo) g);

/* 
 sid  |                                gradeinfo                                 
------+--------------------------------------------------------------------------
 s100 | {"(A,\"{(c200),(c202)}\")","(B,\"{(c201)}\")"}
 s101 | {"(B,\"{(c200)}\")","(A,\"{(c201),(c202),(c302)}\")","(C,\"{(c301)}\")"}
 s102 | {"(A,\"{(c202),(c302)}\")","(B,\"{(c200),(c301)}\")"}
 s103 | {"(A,\"{(c201)}\")"}
(4 rows)
*/

select distinct sid, gradeinfo
from   studentGrades sg, unnest(sg.gradeinfo) g
where  g.grade = 'A';

/*
 sid  |                                gradeinfo                                 
------+--------------------------------------------------------------------------
 s100 | {"(A,\"{(c200),(c202)}\")","(B,\"{(c201)}\")"}
 s101 | {"(B,\"{(c200)}\")","(A,\"{(c201),(c202),(c302)}\")","(C,\"{(c301)}\")"}
 s102 | {"(A,\"{(c202),(c302)}\")","(B,\"{(c200),(c301)}\")"}
 s103 | {"(A,\"{(c201)}\")"}
(4 rows)
*/

/* “Find for each student the set of courses in which he or she received an ‘A’ */

select distinct sg.sid, g.courses
from   studentGrades sg, unnest(sg.gradeinfo) g
where  g.grade = 'A';

/*
 sid  |        courses         
------+------------------------
 s100 | {(c200),(c202)}
 s101 | {(c201),(c202),(c302)}
 s102 | {(c202),(c302)}
 s103 | {(c201)}
(4 rows)
*/



/* “Find the grade information of each student who enrolled in course 301." */

select distinct sg.sid, sg.gradeInfo
from   studentGrades sg,
         unnest(sg.gradeinfo) g, 
            unnest(g.courses) c
where  c.cno = 'c301';

/*
 sid  |                                gradeinfo                                 
------+--------------------------------------------------------------------------
 s101 | {"(B,\"{(c200)}\")","(A,\"{(c201),(c202),(c302)}\")","(C,\"{(c301)}\")"}
 s102 | {"(A,\"{(c202),(c302)}\")","(B,\"{(c200),(c301)}\")"}
(2 rows)
*/

/* “Find the grade information of each student who received a
 ‘B’ in course 301."
*/

select distinct sg.sid, sg.gradeInfo
from   studentGrades sg,
         unnest(sg.gradeinfo) g, 
            unnest(g.courses) c
where  g.grade = 'B' and c.cno = 'c301';

/*
 sid  |                       gradeinfo                       
------+-------------------------------------------------------
 s102 | {"(A,\"{(c202),(c302)}\")","(B,\"{(c200),(c301)}\")"}
(1 row)
*/

/* “For each student, find the set of courses in which he or she is enrolled." */

select distinct sg.sid, array_agg(c.cno) as courses
from   studentGrades sg,
         unnest(sg.gradeinfo) g, 
            unnest(g.courses) c
group by(sg.sid);

/*
 sid  |          courses           
------+----------------------------
 s103 | {c201}
 s100 | {c200,c202,c201}
 s104 | {c201}
 s101 | {c200,c201,c202,c302,c301}
 s102 | {c202,c302,c200,c301}
(5 rows)
*/



/*
“For each student who majors in ‘CS’, list her sid and sname, along
with the courses she is enrolled in. Furthermore, these courses should
by grouped by the department in which they are offered."
*/

CREATE TABLE major (sid text, major text);
INSERT INTO major VALUES ('s100','French'),
('s100','Theater'),
('s100', 'CS'),
('s102', 'CS'),
('s103', 'CS'),
('s103', 'French'),
('s104',  'Dance'),
('s105',  'CS');

table major;
/*
 sid  |  major  
------+---------
 s100 | French
 s100 | Theater
 s100 | CS
 s102 | CS
 s103 | CS
 s103 | French
 s104 | Dance
 s105 | CS
(8 rows)
*/

WITH E AS (SELECT sid , cno
           FROM   studentGrades sg ,
                    unnest(sg.gradeInfo) g, 
                        unnest(g.courses) sc),
      F AS (SELECT sid, dept, array_agg((cno,cname)) as courses 
            FROM   E NATURAL JOIN Course
            GROUP BY(sid, dept))
SELECT sid, sname, ARRAY(SELECT (dept, courses)
                         FROM F
                         WHERE s.sid = F.sid) as courseInfo
FROM student s 
WHERE sid IN (SELECT sid
              FROM   major m
              WHERE  major = 'CS');



/*
 sid  | sname  |                                                   courseinfo                                                    
------+--------+-----------------------------------------------------------------------------------------------------------------
 s100 | Eric   | {"(CS,\"{\"\"(c202,Dbs)\"\",\"\"(c200,PL)\"\"}\")","(Math,\"{\"\"(c201,Calculus)\"\"}\")"}
 s102 | Chris  | {"(CS,\"{\"\"(c200,PL)\"\",\"\"(c202,Dbs)\"\",\"\"(c301,AI)\"\"}\")","(Philosophy,\"{\"\"(c302,Logic)\"\"}\")"}
 s103 | Dinska | {"(Math,\"{\"\"(c201,Calculus)\"\"}\")"}
 s105 | Vince  | {}
(4 rows)
*/

/* JSON */
/* Build the jstudentGrades json relation */

insert into jstudentGrades
with e as  (select sid, grade,
                   array_to_json(array_agg(json_build_object('cno',cno))) as courses
            from   enroll
            group by(sid,grade) order by 1),

     f as   (select json_build_object('sid', sid, 'gradeInfo', 
       array_to_json(array_agg(json_build_object('grade', grade, 'courses', courses)))) as studentInfo
             from   e
             group by (sid))
     select  studentInfo from f;

table jstudentGrades;


/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 {"sid" : "s103", "gradeInfo" : [{"grade" : "A", "courses" : [{"cno" : "c201"}]}]}
 {"sid" : "s102", "gradeInfo" : [{"grade" : "A", "courses" : [{"cno" : "c202"},{"cno" : "c302"}]},{"grade" : "B", "courses" : [{"cno" : "c200"},{"cno" : "c301"}]}]}
 {"sid" : "s104", "gradeInfo" : [{"grade" : "D", "courses" : [{"cno" : "c201"}]}]}
 {"sid" : "s101", "gradeInfo" : [{"grade" : "B", "courses" : [{"cno" : "c200"}]},{"grade" : "A", "courses" : [{"cno" : "c201"},{"cno" : "c202"},{"cno" : "c302"}]},{"grade" : "C", "courses" : [{"cno" : "c301"}]}]}
 {"sid" : "s100", "gradeInfo" : [{"grade" : "A", "courses" : [{"cno" : "c200"},{"cno" : "c202"}]},{"grade" : "B", "courses" : [{"cno" : "c201"}]}]}
(5 rows)

*/

-- Find the grade information of each student who received an ‘A’ in some course.

SELECT sg.studentInfo -> 'sid', sg.studentInfo -> 'gradeInfo' 
FROM   jstudentGrades sg, jsonb_array_elements(sg.studentInfo -> 'gradeInfo') g 
WHERE  g -> 'grade' = ' "A" ';


/*
 ?column? |                                                                                   ?column?                                                                                   
----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 "s103"   | [{"grade": "A", "courses": [{"cno": "c201"}]}]
 "s102"   | [{"grade": "A", "courses": [{"cno": "c202"}, {"cno": "c302"}]}, {"grade": "B", "courses": [{"cno": "c200"}, {"cno": "c301"}]}]
 "s101"   | [{"grade": "B", "courses": [{"cno": "c200"}]}, {"grade": "A", "courses": [{"cno": "c201"}, {"cno": "c202"}, {"cno": "c302"}]}, {"grade": "C", "courses": [{"cno": "c301"}]}]
 "s100"   | [{"grade": "A", "courses": [{"cno": "c200"}, {"cno": "c202"}]}, {"grade": "B", "courses": [{"cno": "c201"}]}]
(4 rows)
*/

--> Find the student information of students who are enrolled in course 301

SELECT  sg.studentInfo -> 'sid', sg.studentInfo -> 'gradeInfo'
FROM    jstudentGrades sg, 
           jsonb_array_elements(sg.studentInfo -> 'gradeInfo') g,
               jsonb_array_elements(g -> 'courses') c
WHERE   c -> 'cno' = ' "c301" ';

/*
 ?column? |                                                                                   ?column?                                                                                   
----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 "s102"   | [{"grade": "A", "courses": [{"cno": "c202"}, {"cno": "c302"}]}, {"grade": "B", "courses": [{"cno": "c200"}, {"cno": "c301"}]}]
 "s101"   | [{"grade": "B", "courses": [{"cno": "c200"}]}, {"grade": "A", "courses": [{"cno": "c201"}, {"cno": "c202"}, {"cno": "c302"}]}, {"grade": "C", "courses": [{"cno": "c301"}]}]
(2 rows)
*/

-->  For each student find the courses in which he or she is enrolled

SELECT sg.studentInfo -> 'sid' as sid, array_to_json(array_agg(c -> 'cno' order by c -> 'cno')) as courses
FROM   jstudentGrades sg, 
         jsonb_array_elements(sg.studentInfo -> 'gradeInfo') g,
           jsonb_array_elements(g -> 'courses') c
GROUP BY (sg.studentInfo -> 'sid') order by sg.studentInfo -> 'sid';

/*
  sid   |               courses                
--------+--------------------------------------
 "s100" | ["c200","c201","c202"]
 "s101" | ["c200","c201","c202","c301","c302"]
 "s102" | ["c200","c202","c301","c302"]
 "s103" | ["c201"]
 "s104" | ["c201"]
(5 rows)
*/


