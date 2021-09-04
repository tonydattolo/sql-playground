SELECT S.major FROM student S;
-- DISTINCT to get a set vs a bag
SELECT DISTINCT S.major FROM student S;
-- EXPLAIN generates access plan that says if it uses hashing or sorting
EXPLAIN SELECT DISTINCT S.major FROM student S;
-- EXPLAIN ANALYZE to see predictive time/space complexity of query
EXPLAIN ANALYZE SELECT DISTINCT S.major from student S;

-- use AS to display SELECT clauses with specific attribute name
SELECT S.sid AS StudentID, S.sname as StudentName
FROM student S
WHERE S.major = 'CS';

-- ORDER BY, does ordering by column. Can use col name or col number
SELECT S.sid, S.sname
FROM student S
ORDER BY 2;

-- ORDER BY RANDOM() for random output order
SELECT * FROM student
ORDER BY random();

INSERT INTO enroll VALUES ('s1','c1','B');

-- S.sid = E.sid is a join condition
-- E.grade = 'B' is a constant comparison
SELECT S.sname, E.cno
FROM student S, enroll E
WHERE S.sid = E.sid AND E.grade = 'B'
ORDER BY 2;

-- Subqueries
SELECT S.sname, C.cno
FROM student S, (SELECT E.sid, E.cno
                 FROM enroll E
                 WHERE E.grade = 'B') C
WHERE S.sid = C.sid;

SELECT DISTINCT S.sid, S.sname
FROM student S, enroll E1, enroll E2
WHERE S.sid = E1.sid AND S.sid = E2.sid AND E1.cno <> E2.cno;

-- UNION, INTERSECT, EXCEPT (difference)
-- UNION example
-- "find the sids and names of all students who major in CS or Math"
(SELECT sid,sname
 FROM student
 WHERE major = 'CS')
UNION
(SELECT sid, sname
 FROM student
 WHERE major = 'Math');
-- Equivalent statement using OR operator
SELECT sid, sname
 FROM student
 WHERE major = 'Math' OR major = 'CS';

-- INTERSECTION
-- "find the sids of all students who are enrolled in course c1 and course c2"
(SELECT sid
    FROM enroll
    WHERE cno = 'c1')
INTERSECT
(SELECT sid
    FROM enroll
    WHERE cno = 'c2');

-- difference
-- "find the sids of all students who are enrolled in no courses"
(SELECT S.sid
    from student S)
EXCEPT
(SELECT E.sid
    FROM enroll E);

-- UNION, INTERSECT, EXCEPT are all sets, even if inputs are bags
-- to retain bags, all ALL operator
-- so, UNION ALL, INTERSECTION ALL, EXCEPT ALL

-- CROSS JOIN is the equivalent of product (R x S) in relational algebra
SELECT * FROM student CROSS JOIN enroll;
