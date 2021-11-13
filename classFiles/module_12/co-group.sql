drop table R;
drop table S;

create table R(k text, v int);
create table S(k text, w int);

insert into R values ('a', 1),
                     ('a', 2),
                     ('b', 1),
                     ('c', 3);


insert into S values ('a', 1),
                     ('a', 3),
                     ('c', 2),
                     ('d', 1),
                     ('d', 4);

WITH Kvalues AS (SELECT r.K 
                 FROM R r 
                 UNION 
                 SELECT s.K FROM S s), 
     R_K AS (SELECT k.K, ARRAY(SELECT r.V
                               FROM R r WHERE r.K = k.K) AS RV_values
             FROM Kvalues k), 
     S_K AS (SELECT k.K, ARRAY(SELECT s.W
                               FROM S s WHERE s.K = k.K) AS SW_values
             FROM Kvalues k)
SELECT K, (RV_values, SW_values) FROM R_K NATURAL JOIN S_K;

/*
table r; table s;
 k | v 
---+---
 a | 1
 a | 2
 b | 1
 c | 3
(4 rows)

 k | w 
---+---
 a | 1
 a | 3
 c | 2
 d | 1
 d | 4
(5 rows)
*/

/* cogroup */
/*
 k |        row        
---+-------------------
 a | ("{1,2}","{1,3}")
 b | ({1},{})
 c | ({3},{2})
 d | ({},"{1,4}")
(4 rows)
*/


WITH  Kvalues AS (SELECT r.K FROM R r 
                  UNION 
                  SELECT s.K FROM S s),
      R_K AS (SELECT r.K, ARRAY_AGG(r.V) AS RV_values
              FROM   R r
              GROUP BY (r.K)
              UNION 
              SELECT k.K, '{}' AS RV_values 
              FROM   Kvalues k
              WHERE  k.K NOT IN (SELECT r.K FROM R r)),
      S_K AS (SELECT s.K, ARRAY_AGG(s.W) AS SW_values
              FROM   S s
              GROUP BY (K)
              UNION 
              SELECT k.K, '{}' AS SW_values 
              FROM   Kvalues k
              WHERE  k.K NOT IN (SELECT s.K FROM S s)) 

SELECT  K, (RV_values, SW_values) 
FROM    R_K NATURAL JOIN S_K;

/*
 k |        row        
---+-------------------
 a | ("{1,2}","{1,3}")
 b | ({1},{})
 c | ({3},{2})
 d | ({},"{1,4}")
(4 rows)
*/
