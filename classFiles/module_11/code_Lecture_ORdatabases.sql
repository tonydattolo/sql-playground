create table documentWord (doc text, word text);

create table documents (doc text, words text[]);

insert into documents values ('d1', '{"A","B","C"}');
insert into documents values ('d2', '{"B","C","D"}');
insert into documents values ('d3', '{"A","E"}');
insert into documents values ('d4', '{"B","B","A","D"}');
insert into documents values ('d5', '{"E","F"}');
insert into documents values ('d6', '{"A","D","G"}');
insert into documents values ('d7', '{"C","B","A"}');
insert into documents values ('d8', '{"B","A"}');

/*
table documents;
 doc |   words   
-----+-----------
 d1  | {A,B,C}
 d2  | {B,C,D}
 d3  | {A,E}
 d4  | {B,B,A,D}
 d5  | {E,F}
 d6  | {A,D,G}
 d7  | {C,B,A}
 d8  | {B,A}
(8 rows)
*/

insert into documentWord select d.doc, unnest(d.words) from documents d;

/*
table documentWord;
 doc | word 
-----+------
 d1  | A
 d1  | B
 d1  | C
 d2  | B
 d2  | C
 d2  | D
 d3  | A
 d3  | E
 d4  | B
 d4  | B
 d4  | A
 d4  | D
 d5  | E
 d5  | F
 d6  | A
 d6  | D
 d6  | G
 d7  | C
 d7  | B
 d7  | A
 d8  | B
 d8  | A
(22 rows)
*/


select d.doc, d.words
from   documents d
where  'D' = SOME(d.words);

/*
 doc |   words   
-----+-----------
 d2  | {B,C,D}
 d4  | {B,B,A,D}
 d6  | {A,D,G}
(3 rows)
*/

select d.doc, d.words
from   documents d
where  'D' <> ALL(d.words);

/*
 doc |  words  
-----+---------
 d1  | {A,B,C}
 d3  | {A,E}
 d5  | {E,F}
 d7  | {C,B,A}
 d8  | {B,A}
(5 rows)
*/

/* The membership function x \in A */

create or replace function isIn (x anyelement, A anyarray)
returns boolean as
$$
  select x = SOME(A);
$$ language sql;

/* Find the documents that contain the word ‘A’ but not the word ‘D’ */

select d.doc, d.words
from   documents d
where  isIn('A',d.words) and not(isIn('D',d.words));

/*  doc |  words  
-----+---------
 d1  | {A,B,C}
 d3  | {A,E}
 d7  | {C,B,A}
 d8  | {B,A}
(4 rows)
*/


/* Overlap (intersection) test of sets A and B: 
     "Do A and B have a non-empty intersection? "
   Expressed in Object-Relational SQL as  A && B */

/*Find the documents whose sets of words overlap with the set of words {B, C}*/

select d.doc, d.words
from   documents d
where  d.words && '{"B","C"}';

/*
 doc |   words   
-----+-----------
 d1  | {A,B,C}
 d2  | {B,C,D}
 d4  | {B,B,A,D}
 d7  | {C,B,A}
 d8  | {B,A}
(5 rows)
*/


/* Disjointness test of sets A and B: 
    "Are A and B disjoint?"
   Expressed in Object-Relational SQL as  A && B */

/* Find the pairs of documents that do not have words in common */

select d1.doc as doc1, d2.doc as doc2,
       d1.words as words1, d2.words as words2
from   documents d1, documents d2
where  not(d1.words && d2.words);

/*
 doc1 | doc2 |  words1   |  words2   
------+------+-----------+-----------
 d1   | d5   | {A,B,C}   | {E,F}
 d2   | d3   | {B,C,D}   | {A,E}
 d2   | d5   | {B,C,D}   | {E,F}
 d3   | d2   | {A,E}     | {B,C,D}
 d4   | d5   | {B,B,A,D} | {E,F}
 d5   | d1   | {E,F}     | {A,B,C}
 d5   | d2   | {E,F}     | {B,C,D}
 d5   | d4   | {E,F}     | {B,B,A,D}
 d5   | d6   | {E,F}     | {A,D,G}
 d5   | d7   | {E,F}     | {C,B,A}
 d5   | d8   | {E,F}     | {B,A}
 d6   | d5   | {A,D,G}   | {E,F}
 d7   | d5   | {C,B,A}   | {E,F}
 d8   | d5   | {B,A}     | {E,F}
(14 rows)

/* Alternatively, with join ... on */

select d1.doc as doc1, d2.doc as doc2,
       d1.words as words1, d2.words as words2
from   documents d1 join documents d2 on not(d1.words && d2.words);


/*
 doc1 | doc2 |  words1   |  words2   
------+------+-----------+-----------
 d1   | d5   | {A,B,C}   | {E,F}
 d2   | d3   | {B,C,D}   | {A,E}
 d2   | d5   | {B,C,D}   | {E,F}
 d3   | d2   | {A,E}     | {B,C,D}
 d4   | d5   | {B,B,A,D} | {E,F}
 d5   | d1   | {E,F}     | {A,B,C}
 d5   | d2   | {E,F}     | {B,C,D}
 d5   | d4   | {E,F}     | {B,B,A,D}
 d5   | d6   | {E,F}     | {A,D,G}
 d5   | d7   | {E,F}     | {C,B,A}
 d5   | d8   | {E,F}     | {B,A}
 d6   | d5   | {A,D,G}   | {E,F}
 d7   | d5   | {C,B,A}   | {E,F}
 d8   | d5   | {B,A}     | {E,F}
(14 rows)
/*


/* Checking for containment between two sets 
    "Is A a subset of B?"
   Expressed in Object-relational SQL as A <@ B
*/

/* Find the documents that contain the words ‘A’ and ‘B’*/

select d.doc, d.words
from   documents d
where  '{"A","B"}' <@ d.words
order by 1,2;

/*  doc |   words   
-----+-----------
 d1  | {A,B,C}
 d4  | {B,B,A,D}
 d7  | {C,B,A}
 d8  | {B,A}
(4 rows)
*/

/* Find the pairs of different documents d1, d2 such that 
   all words in d1 also occur as words in d2.

   Alternatively,
   Find the pairs of different documents d1, d2 such that 
   d1 ONLY contains words that occur in d2.

   This is also called the "subset join"

*/

select d1.doc as doc1, d2.doc as doc2,
       d1.words as words1, d2.words as words2
from   documents d1, documents d2
where  d1.words <@ d2.words and
       d1.doc <> d2.doc;


/* 
 doc1 | doc2 | words1  |  words2   
------+------+---------+-----------
 d1   | d7   | {A,B,C} | {C,B,A}
 d7   | d1   | {C,B,A} | {A,B,C}
 d8   | d1   | {B,A}   | {A,B,C}
 d8   | d4   | {B,A}   | {B,B,A,D}
 d8   | d7   | {B,A}   | {C,B,A}
(5 rows)
*/

/* Set equality test:
   "Is A = B?"
   Expressed as
   A <@ B and B <@ A
*/

select d1.doc as doc1, d2.doc as doc2,
       d1.words as words1, d2.words as words2
from   documents d1, documents d2
where  d1.words <@ d2.words and
       d2.words <@ d1.words and
       d1.doc <> d2.doc;

/*  doc1 | doc2 | words1  | words2  
------+------+---------+---------
 d1   | d7   | {A,B,C} | {C,B,A}
 d7   | d1   | {C,B,A} | {A,B,C}
(2 rows)
*/

/* The equality predicate "=" of Object-Relational SQL
   checks for ARRAY equality between the arrays that
   represent A and B
     "Are A and B equal as array?"
   This is not the same as checking if the sets A and B 
   represented by these arrays are equal.
*/

select d1.doc as doc1, d2.doc as doc2,
       d1.words as words1, d2.words as words2
from   documents d1, documents d2
where  d1.words = d2.words and
       d1.doc <> d2.doc;
/*
 doc1 | doc2 | words1 | words2 
------+------+--------+--------
(0 rows)
*/

/* Alternatively, this shows that normal joins are permitted on arrays */

select d1.doc as doc1, d2.doc as doc2,
       d1.words as words1, d2.words as words2
from   documents d1 join documents d2 on (d1.words = d2.words and d1.doc <> d2.doc);

/*
 doc1 | doc2 | words1 | words2 
------+------+--------+--------
(0 rows)
*/

/* Checking for set emptyness 
     "Is A empty"
   Expressed as
     "A < '{}'"
*/

select d.doc, d.words
from   documents d
where  d.words <@ '{}';

/*
 doc | words 
-----+-------
(0 rows)
*/

/* Example: 
   Note that we type the sets, including the emptyset*/

   select q.A
   from   (select '{}'::text[] as A
           union
           select '{"a","b"}'::text[] as A) q
   where   q.A <@ '{}';

/*    
 a  
----
 {}
(1 row)
*/


select d.doc, d.words
from   documents d
where  d.words <@ '{}';

/* Application Set Joins */

/* SOME set join */

create or replace function atLeastOne (A anyarray, B anyarray)
returns boolean as
$$
  select A && B; 
$$ language sql;

/* ALL set join (better called subset join) 
   "Is Each element in A is in B?"
*/


create or replace function Each (A anyarray, B anyarray)
returns boolean as
$$
  select A <@ B;
$$ language sql;

/* Find all pairs of documents (d1, d2) such that some words of d1 are in d2. */

select d1.doc, d2.doc
from   documents d1, documents d2
where  atLeastOne(d1.words, d2.words)
order by 1,2;

/*
 doc | doc 
-----+-----
 d1  | d1
 d1  | d2
 d1  | d3
 d1  | d4
 d1  | d6
 d1  | d7
 d1  | d8
 d2  | d1
 d2  | d2
 d2  | d4
 d2  | d6
 d2  | d7
 d2  | d8
 d3  | d1
 d3  | d3
 d3  | d4
 d3  | d5
 d3  | d6
 d3  | d7
 d3  | d8
 d4  | d1
 d4  | d2
 d4  | d3
 d4  | d4
 d4  | d6
 d4  | d7
 d4  | d8
 d5  | d3
 d5  | d5
 d6  | d1
 d6  | d2
 d6  | d3
 d6  | d4
 d6  | d6
 d6  | d7
 d6  | d8
 d7  | d1
 d7  | d2
 d7  | d3
 d7  | d4
 d7  | d6
 d7  | d7
 d7  | d8
 d8  | d1
 d8  | d2
 d8  | d3
 d8  | d4
 d8  | d6
 d8  | d7
 d8  | d8
(50 rows)
*/

/* "Find all pairs of documents (d1, d2) such that all words of d1 are in d2."

   Or, alternatively,

   "Find all pairs of documents (d1, d2) such that d1 only contains words that are in d2."
*/


select d1.doc, d2.doc
from   documents d1, documents d2
where  Each(d1.words, d2.words);


/*
 doc | doc 
-----+-----
 d1  | d1
 d1  | d7
 d2  | d2
 d3  | d3
 d4  | d4
 d5  | d5
 d6  | d6
 d7  | d1
 d7  | d7
 d8  | d1
 d8  | d4
 d8  | d7
 d8  | d8
(13 rows)
*/


select d1.doc, d2.doc
from   documents d1, documents d2
where  Each(d1.words, d2.words) and d1.doc <> d2.doc;

/* 
 doc | doc 
-----+-----
 d1  | d7
 d7  | d1
 d8  | d1
 d8  | d4
 d8  | d7
(5 rows)
*/

/* "Find the document pairs (d1,d2) such that 
   d1 contains all the words of d2" 
*/

select d1.doc, d2.doc
from   documents d1, documents d2
where  Each(d2.words, d1.words) and d1.doc <> d2.doc;

/*
 doc | doc 
-----+-----
 d1  | d7
 d1  | d8
 d4  | d8
 d7  | d1
 d7  | d8
(5 rows)
*/

/* Set size, also called set cardinality */
/* Determine |A| */

select d.doc, cardinality(d.words) as number_of_words
from   documents d;

/*
 doc | number_of_words 
-----+-----------------
 d1  |               3
 d2  |               3
 d3  |               2
 d4  |               4
 d5  |               2
 d6  |               3
 d7  |               3
 d8  |               2
(8 rows)
*/


/* "Find the documents with fewer than 10 words */

select d.doc
from   documents d
where  cardinality(d.words) < 10;

/*
 doc 
-----
 d1
 d2
 d3
 d4
 d5
 d6
 d7
 d8
(8 rows)
*/

/* "Find the documents with that have exactly 3 words */

select d.doc
from   documents d
where  cardinality(d.words) = 3;

/*
 doc 
-----
 d1
 d2
 d6
 d7
(4 rows)
*/


/* We now to restrucring operator */

/* The UNNEST operator */

select unnest(array[2,1,3,4,4]);

/*
 unnest 
--------
      2
      1
      3
      4
      4
(5 rows)
*/

/* providing an attribute name for the elements in 
of the array */

select unnest(array[2,1,3,4,4]) as a;

/* a 
---
 2
 1
 3
 4
 4
(5 rows)
*/

/* Restructuring the documents relation

"Starting from the documents relation, create a relation of (doc, word) pairs."

*/

select d.doc, unnest(d.words) as word
from   documents d;

/*
 doc | word 
-----+------
 d1  | A
 d1  | B
 d1  | C
 d2  | B
 d2  | C
 d2  | D
 d3  | A
 d3  | E
 d4  | B
 d4  | B
 d4  | A
 d4  | D
 d5  | E
 d5  | F
 d6  | A
 d6  | D
 d6  | G
 d7  | C
 d7  | B
 d7  | A
 d8  | B
 d8  | A
(22 rows)
*/


/* Union, intersection, and difference  of set A and B 

     A union B
     A intersection B
     A - B

*/

create or replace function setUnion(A anyarray, B anyarray) 
returns anyarray as
$$
   select array(select * from unnest(A)
                union
                select * from unnest(B) order by 1);
$$ language sql;

select setunion('{1,2,3}'::int[], '{2,3,3,5}');

/*
 setunion  
-----------
 {1,2,3,5}
(1 row)
*/

select setunion('{"A","B"}'::text[], '{"A","C"}'::text[]);

/*
 setunion 
----------
 {A,B,C}
(1 row)
*/



create or replace function setIntersection(A anyarray, B anyarray) 
returns anyarray as
$$
   select array(select * from unnest(A)
                intersect
                select * from unnest(B) order by 1);
$$ language sql;

select setintersection('{1,2,3}'::int[], '{2,3,3,5}');

/*
 setintersection 
-----------------
 {2,3}
(1 row)
*/


create or replace function setDifference(A anyarray, B anyarray) 
returns anyarray as
$$
   select array(select * from unnest(A)
                except
                select * from unnest(B) order by 1);
$$ language sql;

select setdifference('{1,2,3}'::int[], '{2,3,3,5}');


/*
 setdifference 
---------------
 {1}
(1 row)
*/

/* Restructuring: GROUPING (also called NESTING) */

/* Restructure this relation by grouping the words of each
document into a set (bag) */

table documentWord;

/* Method 1 */

select distinct d.doc, 
       array(select d1.word
             from   documentWord d1
             where  d1.doc = d.doc) as words
from   documentWord d
order by 1,2;

/*
 doc |   words   
-----+-----------
 d1  | {A,B,C}
 d2  | {B,C,D}
 d3  | {A,E}
 d4  | {B,B,A,D}
 d5  | {E,F}
 d6  | {A,D,G}
 d7  | {C,B,A}
 d8  | {B,A}
(8 rows)
*/

/* Method 2:  use 
    use GROUP BY and ARRAY_AGG aggregate function
*/

select d.doc, array_agg(d.word)
from   documentWord d
group by (d.doc)
order by 1,2;

/*
 doc | array_agg 
-----+-----------
 d1  | {A,B,C}
 d2  | {B,C,D}
 d3  | {A,E}
 d4  | {B,B,A,D}
 d5  | {E,F}
 d6  | {A,D,G}
 d7  | {C,B,A}
 d8  | {B,A}
(8 rows)
*/

/* Restructuring multiple times */

/* Starting from the documents relation, we may want to create a
complex-object relation words which keeps for each word the set of
documents that contain that word */

with docWord as (select d.doc as doc,
                        unnest(d.words) as word
                 from documents d)
select p.word as word, array_agg(p.doc) as docs
from   docWord p
group by(p.word)
order by 1,2;

/*
 word |        docs         
------+---------------------
 A    | {d1,d3,d4,d6,d7,d8}
 B    | {d1,d2,d4,d4,d7,d8}
 C    | {d1,d2,d7}
 D    | {d2,d4,d6}
 E    | {d3,d5}
 F    | {d5}
 G    | {d6}
(7 rows)
*/

select p.word, array_agg(p.doc) as docs
from   (select doc, unnest(words) as word
        from   documents d) p
group by(p.word)
order by 1,2;


/*
 word |        docs         
------+---------------------
 A    | {d1,d3,d4,d6,d7,d8}
 B    | {d1,d2,d4,d4,d7,d8}
 C    | {d1,d2,d7}
 D    | {d2,d4,d6}
 E    | {d3,d5}
 F    | {d5}
 G    | {d6}
(7 rows)
*/

/* Application the word-count problem */

/* "Determine the word-count, i.e., frequency of occurrence, of each word
   in the set of documents." */

select p.word, cardinality(array_agg(p.doc)) as wordCount
from   (select d.doc, unnest(d.words) as word
        from   documents d) p
group by (p.word)
order by 2,1;


/*
 word | wordcount 
------+-----------
 F    |         1
 G    |         1
 E    |         2
 C    |         3
 D    |         3
 A    |         6
 B    |         6
(7 rows)
*/

/* “Find the words that occur most frequently in the set of documents." */

with E as (
   select p.word, cardinality(array_agg(p.doc)) as wordCount
   from   (select d.doc, unnest(d.words) as word
           from   documents d) p
   group by (p.word))

select word
from   e
where  wordCount = (select max(wordcount) from e)
order by 1;


/*
 word 
------
 A
 B
(2 rows)
*/

/* Double Nesting */

create table enroll(sid int, cno int, grade text);

insert into enroll values(1001,2001,'A');
insert into enroll values(1001,2002,'A');
insert into enroll values(1001,2003,'B');
insert into enroll values(1002,2001,'B');
insert into enroll values(1002,2003,'A');
insert into enroll values(1003,2004,'A');
insert into enroll values(1003,2005,'B');
insert into enroll values(1004,2002,'A');
insert into enroll values(1004,2004,'A');
insert into enroll values(1005,2001,'B');
insert into enroll values(1005,2003,'A');

/*
table enroll;
 sid  | cno  | grade 
------+------+-------
 1001 | 2001 | A
 1001 | 2002 | A
 1001 | 2003 | B
 1002 | 2001 | B
 1002 | 2003 | A
 1003 | 2004 | A
 1003 | 2005 | B
 1004 | 2002 | A
 1004 | 2004 | A
 1005 | 2001 | B
 1005 | 2003 | A
(11 rows)
*/

/* We want to create a complex-object relation which stores for each
   student, his or her courses, internally grouped by grades obtained
   in these courses
*/

/* This requires double nesting (grouping) */

/* First restructuring grouping on (sid,grade) */

select e.sid, e.grade, array_agg(e.cno) as courses
from   enroll e
group by (e.sid, e.grade)
order by 1,2;

/*
 sid  | grade |   courses   
------+-------+-------------
 1001 | A     | {2001,2002}
 1001 | B     | {2003}
 1002 | A     | {2003}
 1002 | B     | {2001}
 1003 | A     | {2004}
 1003 | B     | {2005}
 1004 | A     | {2002,2004}
 1005 | A     | {2003}
 1005 | B     | {2001}
(9 rows)
*/

/* We then group over the pair of attributes (grades, courses) */


with f as(
      select e.sid, e.grade, array_agg(e.cno) as courses
      from   enroll e
      group by (e.sid, e.grade))
select f.sid, array_agg((f.grade,f.courses)) as grades
from   F f
group  by(f.sid)
order by 1,2;

/*
 sid  |                grades                
------+--------------------------------------
 1001 | {"(B,{2003})","(A,\"{2001,2002}\")"}
 1002 | {"(B,{2001})","(A,{2003})"}
 1003 | {"(B,{2005})","(A,{2004})"}
 1004 | {"(A,\"{2002,2004}\")"}
 1005 | {"(B,{2001})","(A,{2003})"}
*/




