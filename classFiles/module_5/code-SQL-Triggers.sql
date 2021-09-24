/* Trigger definition for INSERT INTO student relation triggering
and INSERT into CS_relation
*/


CREATE OR REPLACE FUNCTION insert_into_Student() RETURNS TRIGGER AS
  $$
    BEGIN
    IF NEW.Major = 'CS' THEN 
      INSERT INTO CS_Student VALUES (NEW.sid, NEW.sname, NEW.byear);
    END IF;
    RETURN NEW;
    END;
  $$ LANGUAGE 'plpgsql';


CREATE TRIGGER insert_into_Student_Relation
    BEFORE INSERT ON Student
    FOR EACH ROW
    EXECUTE PROCEDURE insert_into_Student();



TABLE Student;
/*
 sid | sname | major | byear 
-----+-------+-------+-------
(0 rows)
*/

TABLE CS_student;

/*
 sid | sname | byear 
-----+-------+-------
(0 rows)
*/


INSERT INTO Student VALUES('s1', 'Linda', 'Math', 1960);

TABLE Student;

/*
 sid | sname | major | byear 
-----+-------+-------+-------
 s1  | Linda | Math  |  1960
(1 row)
*/

TABLE CS_student;

/*
 sid | sname | byear 
-----+-------+-------
(0 rows)
*/

INSERT INTO Student VALUES('s2', 'Marc', 'CS', 1959);

TABLE Student;

/*
 sid | sname | major | byear 
-----+-------+-------+-------
 s1  | Linda | Math  |  1960
 s2  | Marc  | CS    |  1959
(2 rows)
*/

TABLE CS_student;

/*
 sid | sname | byear 
-----+-------+-------
 s2  | Marc  |  1959
(1 row)
*/

/* Examining FOR EACH ROW clause */

INSERT INTO Student VALUES ('s3', 'Nick', 'CS', 1990),
                           ('s4', 'Vince', 'Biology', 1985);

TABLE Student;

/*
 sid | sname |  major  | byear 
-----+-------+---------+-------
 s1  | Linda | Math    |  1960
 s2  | Marc  | CS      |  1959
 s3  | Nick  | CS      |  1990
 s4  | Ellen | Biology |  1985
(4 rows)
*/


TABLE CS_student;

/*
 sid | sname | byear 
-----+-------+-------
 s2  | Marc  |  1959
 s3  | Nick  |  1990
(2 rows)
*/


/* RETURN NEW versus RETURN NULL */

CREATE OR REPLACE FUNCTION insert_into_Student() RETURNS TRIGGER AS
  $$
    BEGIN
    IF NEW.Major = 'CS' THEN 
      INSERT INTO CS_Student VALUES (NEW.sid, NEW.sname, NEW.byear);
    END IF;
    RETURN NULL;
    END;
  $$ LANGUAGE 'plpgsql';

INSERT INTO Student VALUES ('s5', 'Gloria', 'CS', 1956);

/* Notice that this tuple was not inserted in the Student table 
   It was inserted in CS students though */

TABLE Student;
/*
 sid | sname |  major  | byear 
-----+-------+---------+-------
 s1  | Linda | Math    |  1960
 s2  | Marc  | CS      |  1959
 s3  | Nick  | CS      |  1990
 s4  | Ellen | Biology |  1985
(4 rows)
*/


TABLE CS_student;

/*
 sid | sname  | byear 
-----+--------+-------
 s2  | Marc   |  1959
 s3  | Nick   |  1990
 s5  | Gloria |  1956
(3 rows)
*/

DELETE FROM CS_student WHERE sid = 's5';


/* INSERT BEFORE versus INSERT AFTER */

CREATE OR REPLACE FUNCTION insert_into_Student() RETURNS TRIGGER AS
  $$
    BEGIN
    IF NEW.Major = 'CS' THEN 
      INSERT INTO CS_Student VALUES (NEW.sid, NEW.sname, NEW.byear);
    END IF;
    RETURN NEW;  -- Equivalent with RETURN NULL
    END;
  $$ LANGUAGE 'plpgsql';

DROP TRIGGER insert_into_Student_Relation ON Student;


CREATE TRIGGER insert_into_Student_Relation
    AFTER INSERT ON Student
    FOR EACH ROW
    EXECUTE PROCEDURE insert_into_Student();


TABLE Student;
/*
 sid | sname |  major  | byear 
-----+-------+---------+-------
 s1  | Linda | Math    |  1960
 s2  | Marc  | CS      |  1959
 s3  | Nick  | CS      |  1990
 s4  | Ellen | Biology |  1985
(4 rows)
*/


TABLE CS_student;

/*
 sid | sname | byear 
-----+-------+-------
 s2  | Marc  |  1959
 s3  | Nick  |  1990
(2 rows)
*/

INSERT INTO student VALUES('s5', 'Charles', 'Math', 1959), ('s6', 'Elisabeth', 'CS', 1960);


TABLE Student;

/*
 sid |   sname   |  major  | byear 
-----+-----------+---------+-------
 s1  | Linda     | Math    |  1960
 s2  | Marc      | CS      |  1959
 s3  | Nick      | CS      |  1990
 s4  | Ellen     | Biology |  1985
 s5  | Charles   | Math    |  1959
 s6  | Elisabeth | CS      |  1960
(6 rows)
*/

TABLE CS_student;
/*
 sid |   sname   | byear 
-----+-----------+-------
 s2  | Marc      |  1959
 s3  | Nick      |  1990
 s6  | Elisabeth |  1960
(3 rows)
*/


/* DELETE triggers */



CREATE OR REPLACE FUNCTION delete_from_Student() RETURNS TRIGGER AS
  $$
    BEGIN
      IF OLD.major = 'CS' THEN
         DELETE FROM CS_Student WHERE sid = OLD.sid;
      END IF;
      RETURN OLD;
    END;
  $$ LANGUAGE 'plpgsql';



CREATE TRIGGER delete_from_Student_Relation
    BEFORE DELETE ON Student
    FOR EACH ROW
    EXECUTE PROCEDURE delete_from_Student();


TABLE Student;

/*
 sid |   sname   |  major  | byear 
-----+-----------+---------+-------
 s1  | Linda     | Math    |  1960
 s2  | Marc      | CS      |  1959
 s3  | Nick      | CS      |  1990
 s4  | Ellen     | Biology |  1985
 s5  | Charles   | Math    |  1959
 s6  | Elisabeth | CS      |  1960
(6 rows)
*/

TABLE CS_student;
/*
 sid |   sname   | byear 
-----+-----------+-------
 s2  | Marc      |  1959
 s3  | Nick      |  1990
 s6  | Elisabeth |  1960
(3 rows)
*/

DELETE FROM Student WHERE sid = 's1';

TABLE Student;
/*
 sid |   sname   |  major  | byear 
-----+-----------+---------+-------
 s2  | Marc      | CS      |  1959
 s3  | Nick      | CS      |  1990
 s4  | Ellen     | Biology |  1985
 s5  | Charles   | Math    |  1959
 s6  | Elisabeth | CS      |  1960
(5 rows)
*/

TABLE CS_student;
/*
 sid |   sname   | byear 
-----+-----------+-------
 s2  | Marc      |  1959
 s3  | Nick      |  1990
 s6  | Elisabeth |  1960
(3 rows)
*/

DELETE FROM Student WHERE sid = 's2';

TABLE Student;

/*
 sid |   sname   |  major  | byear 
-----+-----------+---------+-------
 s3  | Nick      | CS      |  1990
 s4  | Ellen     | Biology |  1985
 s5  | Charles   | Math    |  1959
 s6  | Elisabeth | CS      |  1960
(4 rows)
*/

TABLE CS_student;

/*
 sid |   sname   | byear 
-----+-----------+-------
 s3  | Nick      |  1990
 s6  | Elisabeth |  1960
(2 rows)
*/

DROP TABLE CS_student;

DROP TRIGGER insert_into_student_relation on student;
DROP TRIGGER delete_from_student_relation on student;
DROP TRIGGER

/* Updating VIEWs */
/* We will use a view CS_student for the CS student */
/* We only have the base relation Student */


CREATE VIEW CS_student AS (SELECT  s.sid, s.sname, s.byear
                           FROM    Student s
                           WHERE   s.major = 'CS');

TABLE Student;

/*
 sid |   sname   |  major  | byear 
-----+-----------+---------+-------
 s3  | Nick      | CS      |  1990
 s4  | Ellen     | Biology |  1985
 s5  | Charles   | Math    |  1959
 s6  | Elisabeth | CS      |  1960
(4 rows)
*/

TABLE CS_student;

/*
 sid |   sname   | byear 
-----+-----------+-------
 s3  | Nick      |  1990
 s6  | Elisabeth |  1960
(2 rows)
*/


/* VIEW update:  INSERTING into a VIEW */

CREATE OR REPLACE FUNCTION insert_CS_student() RETURNS TRIGGER AS
   $$
   BEGIN
      INSERT INTO Student VALUES(NEW.sid, NEW.sname, 'CS', NEW.byear);
      RETURN NULL;
   END;
   $$ LANGUAGE 'plpgsql';


CREATE TRIGGER insert_into_CS_student 
    INSTEAD OF INSERT ON CS_Student
    FOR EACH ROW
    EXECUTE PROCEDURE insert_CS_Student();


INSERT INTO CS_Student VALUES ('s1', 'Eric',1990);

/*
 sid |   sname   |  major  | byear 
-----+-----------+---------+-------
 s3  | Nick      | CS      |  1990
 s4  | Ellen     | Biology |  1985
 s5  | Charles   | Math    |  1959
 s6  | Elisabeth | CS      |  1960
 s1  | Eric      | CS      |  1990
(5 rows)
*/

TABLE CS_Student;

/* sid |   sname   | byear 
-----+-----------+-------
 s3  | Nick      |  1990
 s6  | Elisabeth |  1960
 s1  | Eric      |  1990
(3 rows)
*/

/* VIEW update:  DELETING from a view */

CREATE OR REPLACE FUNCTION delete_CS_student() RETURNS TRIGGER AS
 $$
 BEGIN
   DELETE FROM Student WHERE sid = OLD.sid;
   RETURN NULL;
  END;
 $$ LANGUAGE 'plpgsql';


CREATE TRIGGER delete_from_CS_student_relation
 INSTEAD OF DELETE ON CS_Student
 FOR EACH ROW
 EXECUTE PROCEDURE delete_CS_Student();


DELETE FROM CS_student WHERE sid = 's1';

TABLE student;
/*
 sid |   sname   |  major  | byear 
-----+-----------+---------+-------
 s4  | Ellen     | Biology |  1985
 s5  | Charles   | Math    |  1959
 s3  | Nick      | CS      |  1990
 s6  | Elisabeth | CS      |  1960
(4 rows)
*/

TABLE CS_student;

/*
 sid |   sname   | byear 
-----+-----------+-------
 s3  | Nick      |  1990
 s6  | Elisabeth |  1960
(2 rows)
*/

DELETE FROM CS_student;

TABLE Student;

/*
 sid |  sname  |  major  | byear 
-----+---------+---------+-------
 s4  | Ellen   | Biology |  1985
 s5  | Charles | Math    |  1959
(2 rows)
*/

TABLE CS_student;
/*
 sid | sname | byear 
-----+-------+-------
(0 rows)
*/


/* VIEW Materilaization */

CREATE TABLE Math_Student (sid text, sname text);

CREATE FUNCTION insert_Math_student() RETURNS TRIGGER AS
 $$
 BEGIN
  IF (NEW.Major = 'Math') THEN 
      INSERT INTO Math_Student VALUES(NEW.sid, NEW.sname);
  END IF;
  RETURN NULL;
  END;
 $$ LANGUAGE 'plpgsql';


CREATE TRIGGER add_Math_Student
  AFTER INSERT ON Student
  FOR EACH ROW
  EXECUTE PROCEDURE insert_Math_Student();


INSERT INTO Student VALUES ('s8', 'John', 'Math', 1975);

TABLE student;

/* sid |  sname  |  major  | byear 
-----+---------+---------+-------
 s4  | Ellen   | Biology |  1985
 s5  | Charles | Math    |  1959
 s8  | John    | Math    |  1975
(3 rows)
*/

TABLE Math_Student;

/* sid | sname 
-----+-------
 s8  | John
(1 row)
*/



/* Constraint verification */

CREATE OR REPLACE FUNCTION check_Student_key_constraint() RETURNS trigger AS
$$
BEGIN
 IF NEW.sid IN (SELECT sid FROM Student) THEN
    RAISE EXCEPTION 'sid already exist';
 END IF;
 RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER check_course_cno_key_constraint
 BEFORE INSERT
 ON Student 
 FOR EACH ROW
 EXECUTE PROCEDURE check_Student_key_constraint();


TABLE Student;

/* sid | sname | major | byear 
-----+-------+-------+-------
 s10 | Dirk  | CS    |  1959
(1 row)
*/


INSERT INTO Student VALUES ('s11', 'George', 'Math', 2000);

/*
 sid | sname  | major | byear 
-----+--------+-------+-------
 s10 | Dirk   | CS    |  1959
 s11 | George | Math  |  2000
(2 rows)
*/

INSERT INTO Student VALUES ('s11', 'Ann', 'CS', 1995);

/* ERROR:  sid already exist
CONTEXT:  PL/pgSQL function check_student_key_constraint() line 4 at RAISE
*/


/* Aggregate function maintenance */

CREATE TABLE Count_Students( total integer);
INSERT INTO  Count_Students VALUES(0);

/*
 total 
-------
     0
(1 row)
*/


CREATE OR REPLACE FUNCTION Maintain_Number_Students() RETURNS trigger AS
$$
BEGIN
  UPDATE Count_Students SET total = total + 1;
  RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER Total_Students
 AFTER INSERT ON Student
 FOR EACH ROW
 EXECUTE PROCEDURE Maintain_Number_Students();

INSERT INTO Student VALUES ('s1', 'Dirk', 'CS', 1990), ('s2', 'Ellen', 'Math', 1995);


TABLE Student;

/* sid | sname | major | byear 
-----+-------+-------+-------
 s1  | Dirk  | CS    |  1990
 s2  | Ellen | Math  |  1995
(2 rows)
*/

TABLE Count_Student;

/* total 
-------
     2
(1 row)
*/


/* Maintaining a log */

CREATE TABLE Student_log(
    sid text,
    stamp timestamp
);


CREATE OR REPLACE FUNCTION time_stamp_for_student() RETURNS TRIGGER AS
 $$
 BEGIN
   INSERT INTO student_log VALUES (NEW.sid, now());
   RETURN NULL;
 END;
$$  LANGUAGE plpgsql;


CREATE TRIGGER log_student
  AFTER INSERT ON Student
  FOR EACH ROW EXECUTE PROCEDURE time_stamp_for_student();


DELETE FROM Student;

INSERT INTO Student VALUES ('s10', 'Dirk', 'CS', 1959);



TABLE Student;

/*
 sid | sname | major | byear 
-----+-------+-------+-------
 s10 | Dirk  | CS    |  1959
(1 row)
*/


TABLE Student_log;

/*
 sid |           stamp            
-----+----------------------------
 s10 | 2019-02-02 19:59:00.574302
(1 row)
*/



