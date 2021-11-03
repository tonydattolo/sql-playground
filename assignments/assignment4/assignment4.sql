-- 1. Find the cname of each company that employs persons who live in Bloomington or in
-- Indianapolis.
SELECT DISTINCT w.cname
FROM worksfor w JOIN person p on p.pid = w.pid
WHERE p.city ='Bloomington' OR p.city='Indianapolis';

-- 2. Find  the  pid  and  name  of  each  person  who  (a)  works  for  a  company  located  in
-- 'Bloomington' and (b) knows as person who lives in 'Chicago'.
SELECT p.pid,p.name
FROM person p
JOIN worksfor w ON p.pid = w.pid
JOIN company c ON c.city = 'Bloomington'
WHERE w.cname = c.cname
INTERSECT
SELECT p1.pid, p1.name
FROM person p1
JOIN knows k ON p1.pid = k.pid1
JOIN person p2 ON p2.pid = k.pid2 AND p2.city = 'Chicago';

-- 3. Find each job skill that is not the job skill of any person who works for 'Yahoo' or for
-- 'Netflix'.
SELECT j.skill
FROM jobskill j
EXCEPT
    (SELECT s.skill
    FROM personskill s
        JOIN worksfor w on s.pid = w.pid
    WHERE w.cname = 'Yahoo'
    UNION
    SELECT s.skill
    FROM personskill s
        JOIN worksfor w on s.pid = w.pid
    WHERE w.cname = 'Netflix');

-- 4. Find  the  pid  and  name  of  each  person  who  knows  all  the  persons  who  (a)  work  at
-- Netflix, (b) make at least 55000, and (c) are born after 1985.
SELECT DISTINCT p.pid,
    p.name
FROM person p
    JOIN knows k ON p.pid = k.pid1
    JOIN person p2 ON p2.pid = k.pid2 AND p2.birthyear > 1985
    JOIN worksfor w ON p2.pid = w.pid AND w.salary >= 55000
    JOIN company c ON w.cname = c.cname
    AND c.cname = 'Netflix'
WHERE p.pid <> p2.pid;

-- 5. Find  the  pairs  of  company  names  (c1;  c2)  such  that  no  person  who  works  for  the
-- company with cname c1 has a higher salary than the salaries of all persons who works
-- for the company with cname c2.
SELECT DISTINCT c1.cname,
    c2.cname
FROM company c1
    JOIN company c2 ON c1.cname <> c2.cname
    AND c1.cname NOT IN (
        SELECT c.cname
        FROM company c
        EXCEPT (SELECT cc.cname
                FROM company cc
                    JOIN worksfor w on cc.cname = w.cname
                    WHERE w.salary > (SELECT w2.salary
                                    FROM worksfor w2
                                    WHERE w2.cname = c2.cname
                                    ORDER BY w2.salary DESC LIMIT 1))
    );

-- 6. Find the pid and name of each person who does not know any person who has a salary
-- strictly above 55000.
SELECT DISTINCT p.pid, p.name
FROM person p
    JOIN knows k on p.pid = k.pid1
    JOIN person p2 ON p2.pid = k.pid2
EXCEPT
SELECT DISTINCT p.pid, p.name
FROM person p
    JOIN knows k on p.pid = k.pid1
    JOIN person p2 ON p2.pid = k.pid2
    JOIN worksfor w on p2.pid = w.pid AND w.salary > 55000;

-- 7. Find the pid of each person who has a salary that is strictly below that of any person
-- who has the Accounting jobskill.
SELECT DISTINCT p.pid
FROM person p
    join worksfor w on p.pid = w.pid
WHERE w.salary < (SELECT w.salary
                    FROM person p
                        JOIN worksfor w on p.pid = w.pid
                        JOIN personskill s on p.pid = s.pid AND s.skill = 'Accounting'
                    ORDER BY w.salary ASC LIMIT 1);


--
-- 8. Find the pairs (c, p) where c is the cname of a company that only employs persons who
-- make more than 50000 and where p is the pid of a person who works at that company
-- and who knows someone who works for IBM.
SELECT c.cname,
    p.pid
FROM company c
    JOIN worksfor w ON c.cname = w.cname
    JOIN person p ON w.pid = p.pid
WHERE c.cname IN (
        SELECT c2.cname
        FROM company c2
            JOIN worksfor w2 ON c2.cname = w2.cname
                AND w2.salary > 50000
                AND c2.cname = 'IBM'
    )
    AND p.pid IN (
        SELECT p2.pid
        FROM person p2
            JOIN knows k ON p2.pid = k.pid2
            JOIN worksfor w on p2.pid = w.pid
                AND w.cname = 'IBM'
                AND w.salary > 50000
    );


-- 9. Find the pid and name of each person who works for IBM and who has a strictly higher
-- salary than some other person who he or she knows and who also works for IBM.
SELECT p.pid,
    p.name
FROM person p
    JOIN worksfor w ON p.pid = w.pid
    JOIN company c ON w.cname = c.cname
    AND c.cname = 'IBM'
WHERE p.pid IN (
        SELECT p2.pid
        FROM person p2
            JOIN knows k ON p2.pid = k.pid2
        WHERE p2.pid = k.pid1
            AND k.pid2 IN (
                SELECT p3.pid
                FROM person p3
                    JOIN worksfor w3 ON p3.pid = w3.pid
                WHERE w3.cname = 'IBM'
                    AND w3.salary > ALL (
                        SELECT w4.salary
                        FROM person p4
                            JOIN worksfor w4 on p4.pid = w4.pid
                                AND w4.cname = 'IBM'
                    )
            )
    );
-- 10. (BONUS) Find the pid of each person who has all-but-one job skill.
SELECT p.pid
FROM person p
    JOIN personskill ps ON p.pid = ps.pid
WHERE p.pid IN (
        SELECT p2.pid
        FROM person p2
            JOIN personskill ps2 ON p2.pid = ps2.pid
        WHERE p2.pid <> p.pid
            AND ps2.skill IN (
                SELECT s.skill
                FROM jobskill s
                WHERE s.skill NOT IN (
                        SELECT s2.skill
                        FROM jobskill s2
                    )
            )
    );