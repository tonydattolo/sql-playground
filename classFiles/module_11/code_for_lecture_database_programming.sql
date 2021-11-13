/* Code for Lecture on Database Programming */

/* Example with conditional if-else statement */
/* Version 1 */

CREATE OR REPLACE FUNCTION convert(a char) RETURNS FLOAT AS $$
        BEGIN
	IF (a = 't') THEN RETURN(1);
	ELSE 
          IF (a= 'f') THEN RETURN(0); 
          ELSE
            IF (a = 'u') THEN RETURN(0.5); 
            ELSE RETURN(2);
            END IF;
          END IF;
         END IF;
        END;
$$ LANGUAGE plpgsql;

select convert('t'); select convert('f'); select convert('u'); select convert('a');

/*
 convert 
---------
       1
(1 row)

 convert 
---------
       0
(1 row)

 convert 
---------
     0.5
(1 row)

 convert 
---------
       2
(1 row)
*/


/* Using case statement */

CREATE OR REPLACE FUNCTION convert(a char) RETURNS float AS
$$
  BEGIN
    CASE WHEN (a = 't') THEN RETURN 1;
         WHEN (a = 'f') THEN RETURN 0; 
         WHEN (a = 'u') THEN RETURN 0.5;
         ELSE RETURN 2;
    END CASE; 
  END;
$$ LANGUAGE plpgsql;

select convert('t'); select convert('f'); select convert('u'); select convert('a');  

/*
convert 
---------
       1
(1 row)

 convert 
---------
       0
(1 row)

 convert 
---------
     0.5
(1 row)

 convert 
---------
       2
(1 row)

*/

/* Iterative version of factorial */

CREATE OR REPLACE FUNCTION factorial_Iterative (n integer) RETURNS integer AS
$$
  DECLARE
  result integer;
  i integer; 
  BEGIN
    result := 1; 
    FOR i IN 1..n LOOP
                  result := i * result;
                  END LOOP;
  RETURN result;
   END;
$$ language plpgsql;

select factorial_Iterative(0); select factorial_Iterative(5);

/*
 factorial_iterative 
---------------------
                   1
(1 row)

 factorial_iterative 
---------------------
                 120
(1 row)
*/


/* Recursive function factorial */

create or replace function factorial_Recursive(n integer) returns integer as
$$
begin
  if n = 0 then return 1;
           else return n*factorialFunction(n-1);
  end if;
end;
$$ language plpgsql;

 select factorialFunction(0); select factorialFunction(5);                            

/*
 factorialfunction 
-------------------
                 1
(1 row)

 factorialfunction 
-------------------
               120
(1 row)
*/


/* Function can change state of database */

CREATE OR REPLACE FUNCTION change_db_state() RETURNS VOID AS
$$ 
   BEGIN
     DROP TABLE foo_relation;
     CREATE TABLE foo_relation(a integer); 
     INSERT INTO foo_relation VALUES (1), (2), (3); 
     DELETE FROM foo_relation WHERE a=1;
    END;
$$ language plpgsql;

select change_db_state();

/* change_db_state 
-----------------
 
(1 row)
*/

select * from foo_relation;

/* 
a 
---
 2
 3
*/

/* Program with local function */

CREATE OR REPLACE FUNCTION globalFunction() RETURNS void AS
$proc$ 
  BEGIN
    CREATE OR REPLACE FUNCTION localFunction() RETURNS integer AS
    $$
      SELECT 5;
    $$ language sql;
   END; 
$proc$ language plpgsql;

 select globalFunction();

/*
 globalfunction 
----------------
 
(1 row)
*/

select localFunction();

/*
 localfunction 
---------------
             5
(1 row)
*/



/* SELECT INTO assignment statement */

CREATE OR REPLACE FUNCTION size_of_A() RETURNS integer AS
$$
   DECLARE counter integer;
   BEGIN
      SELECT INTO counter COUNT(*) from A;
   RETURN counter; 
   END;
$$ language plpgsql;

select * from a;

/*
 x 
---
 A
 B
(2 rows)
*/

select size_of_A();

/*
 size_of_a 
-----------
         2
(1 row)
*/

CREATE OR REPLACE FUNCTION size_of_A() RETURNS integer AS
$$
   DECLARE counter integer; 
   BEGIN
     counter := (SELECT COUNT(*) from A);
   RETURN counter; END;
$$ language plpgsql;

select size_of_A();                                                                  

/*
size_of_a 
-----------
         2
(1 row)
*/

/* SELECT INTO can lead to non-deterministic effects */

CREATE OR REPLACE FUNCTION choose_one_from_A() RETURNS text AS
$$
   DECLARE element_from_A text; 
   BEGIN
     SELECT INTO element_from_A a.x
     FROM (SELECT x from A ORDER BY random()) a; 
     RETURN element_from_A;
   END;
$$ language plpgsql;


select choose_one_from_A();

/*
choose_one_from_a 
-------------------
 B
(1 row)
*/

select choose_one_from_A();

/*
 choose_one_from_a 
-------------------
 A
(1 row)
*/

/*
“Assignment" statements to relation (table) variables are done using
the INSERT INTO, DELETE FROM, and UPDATE statements, or using triggers
*/


CREATE OR REPLACE FUNCTION relation_assignment() RETURNS void AS
$$ 
  BEGIN
    CREATE TABLE IF NOT EXISTS AB(A integer, B integer);
    DELETE FROM AB; 
    INSERT INTO AB VALUES (0,0);
    INSERT INTO AB SELECT a1.x, a2.x FROM A a1, A a2;
    UPDATE AB SET A = A*A WHERE B = 2;
END;
$$ language plpgsql;

select * from a;

/*
 x 
---
 1
 2
(2 rows)
*/

table ab;
/*
ERROR:  relation "ab" does not exist
LINE 1: table ab;
*/

select relation_assignment();


/*
 relation_assignment 
---------------------
 
(1 row)
*/



select * from ab;

/*
 a | b 
---+---
 0 | 0
 1 | 1
 2 | 1
 1 | 2
 4 | 2
(5 rows)
*/

/* In SQL it is often not necessary to declare cursor or iterator */

CREATE OR REPLACE FUNCTION there_is_book_that_cost_more_than(k integer) 
RETURNS boolean AS
$$ 
  SELECT EXISTS(SELECT * FROM book WHERE price > k);
$$ language sql;

select there_is_book_that_cost_more_that(30);

/*
 there_is_book_that_cost_more_than 
-----------------------------------
 t
(1 row)
*/

/* The following equivalent function uses an iterator */

CREATE OR REPLACE FUNCTION there_is_book_that_cost_more_than(k integer) 
 RETURNS boolean AS
$$
DECLARE exists_book boolean;
        b RECORD; -- the structure will be defined during the program
BEGIN
   exists_book := false;
   FOR b IN SELECT * FROM book -- RECORD b will have have the attribute 
                               -- structure of the book relation
   LOOP
     IF b.price > k
     THEN exists_book := true; EXIT;  -- exit the loop
     END IF;
   END LOOP; 
   RETURN exists_book;
END; 
$$ language plpgsql;


select there_is_book_that_cost_more_than(30);
/*
 there_is_book_that_cost_more_than 
-----------------------------------
 t
(1 row)
*/


/* Iterator over array elements with FOR EACH */

CREATE FUNCTION sum(A int[]) RETURNS int8 AS
   $$ 
     DECLARE s int8 := 0; 
             x int;
     BEGIN
       FOREACH x IN ARRAY A 
         LOOP
           s := s + x;
         END LOOP; 
RETURN s;
END;
$$ LANGUAGE plpgsql;


select sum('{1,2,3,4,5}'::int[]);

/*
 sum 
-----
  15
(1 row)
*/

/* The same function but with an iterator i over the components
   of an array */

CREATE FUNCTION sum(A int[]) RETURNS int8 AS
   $$ 
     DECLARE s int8 := 0;
             i int;
     BEGIN
        FOR i IN array_lower(A,1)..array_length(A,1) 
        LOOP
         s := s + A[i]; 
        END LOOP;
        RETURN s;
      END;
$$ LANGUAGE plpgsql;

select sum('{1,2,3,4,5}'::int[]);                                              

/*
sum 
-----
  15
(1 row)
*/

/* The ancestor-descendant query which is not expressible in OR-SQL */

create or replace function new_ANC_pairs()
returns table (A integer, D integer) AS
$$
   (select A, C
    from   ANC JOIN PC ON D = P)
   except
   (select  A, D
    from    ANC);
$$ LANGUAGE SQL;

create or replace function Ancestor_Descendant()
returns void as $$
begin
   drop table if exists ANC;   
   create table ANC(A integer, D integer);
   
   insert into ANC select * from PC;
   
   while exists(select * from new_ANC_pairs()) 
   loop
        insert into ANC select * from new_ANC_pairs();
   end loop;
end;
$$ language plpgsql;


create or replace function Ancestor_Descendant()
returns void as $$
begin
   drop table if exists ANC;   
   create table ANC(A integer, D integer, primary key(A,D));
   
   insert into ANC select * from PC;
   
   while exists(select * from new_ANC_pairs()) 
   loop
        insert into ANC 
   select Anc.A, PC.C
    from  ANC, PC
    where  ANC.D = PC.P on conflict do nothing;
   end loop;
end;
$$ language plpgsql;

/*
table pc;
 p | c 
---+---
 1 | 2
 1 | 3
 1 | 4
 2 | 5
 2 | 6
 3 | 7
 5 | 8
(7 rows)
*/

select Ancestor_Descendant();


/* ancestor_descendant 
---------------------
 
(1 row)
*/

select * from anc order by 1,2;

/*
 a | d 
---+---
 1 | 2
 1 | 3
 1 | 4
 1 | 5
 1 | 6
 1 | 7
 1 | 8
 2 | 5
 2 | 6
 2 | 8
 3 | 7
 5 | 8
(12 rows)
*/

---Code to do transitive closure of a graph

create or replace function new_TC_pairs()
returns table (source integer, target integer) AS
$$
(select   TC.source, Edge.target
 from     TC JOIN Edge ON (TC.target = Edge.source))
except
(select   source, target
 from     TC);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION TC ()
RETURNS VOID AS $$
BEGIN
   delete from tc;
   insert into tc select * from Edge;
   WHILE exists(select * from new_TC_pairs()) 
   LOOP
        insert into tc select * from new_TC_pairs();
   END LOOP;
END;
$$ LANGUAGE plpgsql;

select * from edge;

/*
 source | target 
--------+--------
      1 |      2
      1 |      3
      2 |      3
      3 |      2
      3 |      4
      3 |      5
      6 |      7
      6 |      6
      7 |      8
      4 |      9
      9 |      5
(11 rows)
*/


select TC();

/*
 tc 
----
 
(1 row)
----------------
*/



select * from tc;

/*
 source | target 
--------+--------
      1 |      2
      1 |      3
      1 |      4
      1 |      5
      1 |      9
      2 |      2
      2 |      3
      2 |      4
      2 |      5
      2 |      9
      3 |      2
      3 |      3
      3 |      4
      3 |      5
      3 |      9
      4 |      5
      4 |      9
      6 |      6
      6 |      7
      6 |      8
      7 |      8
      9 |      5
(22 rows)
*/

/* Non-linear version of transitive closure */

CREATE OR REPLACE FUNCTION new_TC_pairs() 
RETURNS TABLE (source integer, target integer)AS
$$
   (SELECT p1.source, p2.target
    FROM TC p1 JOIN TC p2 ON (p1.target=p2.source))
    EXCEPT
   (SELECT source, target
    FROM TC); 
$$ language sql;


CREATE OR REPLACE FUNCTION TC ()
RETURNS VOID AS $$
BEGIN
   delete from tc;
   insert into tc select * from Edge;
   WHILE exists(select * from new_TC_pairs()) 
   LOOP
        insert into tc select * from new_TC_pairs();
   END LOOP;
END;
$$ LANGUAGE plpgsql;

select tc();

/*
 tc 
----
 
(1 row)
*/

select * from tc order by 1,2;

/*
 source | target 
--------+--------
      1 |      2
      1 |      3
      1 |      4
      1 |      5
      1 |      9
      2 |      2
      2 |      3
      2 |      4
      2 |      5
      2 |      9
      3 |      2
      3 |      3
      3 |      4
      3 |      5
      3 |      9
      4 |      5
      4 |      9
      6 |      6
      6 |      7
      6 |      8
      7 |      8
      9 |      5
(22 rows)
*/
