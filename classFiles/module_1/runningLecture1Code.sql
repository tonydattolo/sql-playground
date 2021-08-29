CREATE TABLE student
(
    sid   text NOT NULL,
    sname varchar(30),
    major varchar(15),
    byear integer,
    primary key (sid)
);

CREATE TABLE course
(
    cno   text NOT NULL,
    cname varchar(20),
    dept  varchar(15),
    primary key (cno)
);

CREATE TABLE enroll
(
    sid text,
    cno text,
    grade varchar(2),
    primary key (sid,cno),
    foreign key (sid) references  student(sid),
    foreign key (cno) references  course(cno)
);

INSERT INTO student VALUES ('s1','John','CS',1990);
INSERT INTO student VALUES ('s2','Ellen','Math',1995);
INSERT INTO student VALUES ('s3','Eric','CS',1990);
INSERT INTO student VALUES ('s4','John','Biology',2001);


INSERT INTO Course VALUES ('c1', 'Dbs', 'CS'),
                          ('c2', 'Calc1', 'Math'),
                          ('c3', 'Calc2', 'Math'),
                          ('c4', 'AI', 'Info');

INSERT INTO Enroll VALUES ('s1', 'c1', 'B'),
                          ('s1', 'c2', 'A'),
                          ('s2', 'c3', 'B'),
                          ('s3', 'c1', 'A'),
                          ('s3', 'c2', 'C');

INSERT INTO Student VALUES ('s1', 'Linda', 'CS', 1990);

insert into student VALUES (NULL, 'John', 'DataScience', 19080);

SELECT * FROM student;

SELECT S.sid, S.sname
FROM student S
WHERE S.major = 'CS';

SELECT S.sid, E.cno
FROM student S, enroll E
WHERE S.sid = S.sid AND E.grade = 'B';

(SELECT S.sid FROM student S)
EXCEPT
(SELECT E.sid FROM enroll E WHERE E.grade = 'A');

DROP TABLE enroll;

CREATE TABLE enroll
(
    sid text,
    cno text,
    grade varchar(2),
    PRIMARY KEY (sid,cno),
    FOREIGN KEY (sid) REFERENCES student(sid),
    FOREIGN KEY (cno) REFERENCES course(cno)
);


INSERT INTO enroll VALUES ('s1', 'c1', 'B'),
                          ('s1', 'c2', 'A'),
                          ('s2', 'c3', 'B'),
                          ('s3', 'c1', 'A'),
                          ('s3', 'c2', 'C');

TABLE enroll;

DROP TABLE student;

INSERT INTO enroll VALUES ('s5','c1','A');

DROP TABLE enroll;

CREATE TABLE enroll
(
    sid text,
    cno text,
    grade varchar(2),
    PRIMARY KEY (sid,cno),
    FOREIGN KEY (sid) REFERENCES student(sid) ON DELETE CASCADE,
    FOREIGN KEY (cno) REFERENCES course(cno) ON DELETE RESTRICT
);

INSERT INTO enroll VALUES ('s1', 'c1', 'B'),
                          ('s1', 'c2', 'A'),
                          ('s2', 'c3', 'B'),
                          ('s3', 'c1', 'A'),
                          ('s3', 'c2', 'C');

DELETE FROM student WHERE sid = 's1';
TABLE student;
TABLE enroll;

DELETE FROM course WHERE cno = 'c1';