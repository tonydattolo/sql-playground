/* Code for Lecture on MapReduce */

create table document (doc text, words text[]);

insert into document values ('d1', '{"A","B","C"}');
insert into document values ('d2', '{"B","C","D"}');
insert into document values ('d3', '{"A","E"}');
insert into document values ('d4', '{"B","B","A","D"}');
insert into document values ('d5', '{"E","F"}');

table document;
/*
 doc |   words   
-----+-----------
 d1  | {A,B,C}
 d2  | {B,C,D}
 d3  | {A,E}
 d4  | {B,B,A,D}
 d5  | {E,F}
(5 rows)
*/

/* Application the word-count query */

/* "Determine the word-count, i.e., frequency of occurrence, of each word
   in the set of documents." */

select p.word, cardinality(array_agg(p.doc)) as wordCount
from   (select d.doc, unnest(d.words) as word
        from   document d) p
group by (p.word)
order by 1,2;

/*
 word | wordcount 
------+-----------
 A    |         3
 B    |         4
 C    |         2
 D    |         2
 E    |         2
 F    |         1
(6 rows)
*/

/* Alternatively, since we don't care about the actual "doc" value of a
document that contains as a word, but merely want to witness that the
word occurs in the document, we can also implement the word count
query as follows: */

select p.word, cardinality(array_agg(p.one)) as wordCount
from   (select unnest(d.words) as word, 1 as one
        from   document d) p
group by (p.word)
order by 1,2;

/*
 word | wordcount 
------+-----------
 A    |         3
 B    |         4
 C    |         2
 D    |         2
 E    |         2
 F    |         1
(6 rows)
*/

/* Even more compactly, taking advantage of bag semantics */

select word, cardinality(array_agg(1)) as wordCount
from   (select unnest(words) as word
        from   document) p
group by (word)
order by 1,2;

/*
 word | wordcount 
------+-----------
 A    |         3
 B    |         4
 C    |         2
 D    |         2
 E    |         2
 F    |         1
(6 rows)
*/

/* We will now decompose the above query in 3 stages that aligns with
MapReduce style of programming it */

WITH
-- mapper phase:
   doc_word AS (SELECT UNNEST(d.words) as word, 1 as one
                FROM   Document d),
-- group (shuffle) phase:
    word_ones AS (SELECT p.word, ARRAY_AGG(p.one) AS ones 
                  FROM doc_word p
                  GROUP BY (p.word)),
-- reducer (phase):
    word_count AS (SELECT q.word, CARDINALITY(q.ones) AS wordCount
                   FROM word_ones q)
-- output:
    SELECT word, wordCount FROM word_count
order by 1,2;



/* Mapper phase */
-- mapper phase
SELECT UNNEST(d.words) as word, 1 AS one
FROM   Document d;



/*  word | one 
------+-----
 A    |   1
 B    |   1
 C    |   1
 B    |   1
 C    |   1
 D    |   1
 A    |   1
 E    |   1
 B    |   1
 B    |   1
 A    |   1
 D    |   1
 E    |   1
 F    |   1
(14 rows)
*/

-- Group (shuffle) phase
WITH
-- mapper phase:
   doc_word AS (SELECT UNNEST(d.words) as word, 1 AS one
                FROM Document d),
-- group (shuffle) phase:
    word_ones AS (SELECT p.word, ARRAY_AGG(p.one) AS ones 
                  FROM doc_word p
                  GROUP BY (p.word))
select * from word_ones
order by 1,2;

/*
 word |   ones    
------+-----------
 A    | {1,1,1}
 B    | {1,1,1,1}
 C    | {1,1}
 D    | {1,1}
 E    | {1,1}
 F    | {1}
(6 rows)
*/

-- reducer phase

WITH
-- mapper phase:
   doc_word AS (SELECT UNNEST(d.words) as word, 1 AS one
                FROM Document d),
-- group (shuffle) phase:
    word_ones AS (SELECT p.word, ARRAY_AGG(p.one) AS ones 
                  FROM doc_word p
                  GROUP BY (p.word)),
-- reducer phase:
    word_count AS (SELECT q.word, CARDINALITY(q.ones) AS wordCount
                   FROM word_ones q)
-- output:
    SELECT word, wordCount FROM word_count
order by 1,2;

/*
 word | wordcount 
------+-----------
 A    |         3
 B    |         4
 C    |         2
 D    |         2
 E    |         2
 F    |         1
(6 rows)
*/

/* The mapper function */

CREATE OR REPLACE FUNCTION mapper(doc text, words text[]) 
RETURNS TABLE (word text, one int) AS
$$
 SELECT UNNEST(words) as word, 1 as one;
$$ LANGUAGE SQL;

SELECT word, one
FROM   mapper('d1',ARRAY['A','A','B']);

/*
 word | one 
------+-----
 A    |   1
 A    |   1
 B    |   1
(3 rows)
*/


/* We can map-apply the mapper function to the Document relation */

WITH map_output AS (SELECT q.word, q.one
                    FROM Document d,
                            LATERAL(SELECT p.word, p.one
                                    FROM mapper(d.doc,d.words) p) q)
SELECT word, one 
FROM   map_output;

/*
 word | one 
------+-----
 A    |   1
 B    |   1
 C    |   1
 B    |   1
 C    |   1
 D    |   1
 A    |   1
 E    |   1
 B    |   1
 B    |   1
 A    |   1
 D    |   1
 E    |   1
 F    |   1
(14 rows)
*/

/* group-phase */
/* We can now simulate the group (shuffle) phase */

WITH map_output AS (SELECT q.word, q.one
                    FROM Document d,
                            LATERAL(SELECT p.word, p.one
                                    FROM mapper(d.doc,d.words) p) q),


    group_output AS (SELECT p.word, ARRAY_AGG(p.one) as ones
                     FROM   map_output p 
                     GROUP BY (p.word))

SELECT word, ones FROM group_output
order by 1,2;

/*
 word |   ones    
------+-----------
 A    | {1,1,1}
 B    | {1,1,1,1}
 C    | {1,1}
 D    | {1,1}
 E    | {1,1}
 F    | {1}
(6 rows)
*/

/* The reducer function */

CREATE OR REPLACE FUNCTION reducer(word text, ones int[]) 
RETURNS TABLE(word text, wordCount int) AS
$$
   SELECT word, CARDINALITY(ones) as wordCount;
$$ LANGUAGE SQL;

/* The reducer works as follows */

SELECT word, wordCount
FROM   reducer('A','{1,1,1,1}');


/*
 word | wordcount 
------+-----------
 A    |         4
(1 row)
*/

/* Map-apply the reducer to the output of the group-phase */


WITH map_output AS (SELECT q.word, q.one
                    FROM   Document d,
                            LATERAL(SELECT p.word, p.one
                                    FROM mapper(d.doc,d.words) p) q),


    group_output AS (SELECT p.word, ARRAY_AGG(p.one) as ones
                     FROM   map_output p 
                     GROUP BY (p.word))

SELECT t.word, wordCount 
FROM   group_output r,
        LATERAL(SELECT word, wordCount
                FROM reducer(r.word, r.ones) s) t
order by 1,2;

/*
 word | wordcount 
------+-----------
 A    |         3
 B    |         4
 C    |         2
 D    |         2
 E    |         2
 F    |         1
(6 rows)
*/

/* Putting it all together */

WITH 
-- mapper phase
     map_output AS (SELECT q.word, q.one
                    FROM   Document d,
                            LATERAL(SELECT p.word, p.one
                                    FROM mapper(d.doc,d.words) p) q),
-- group phase
    group_output AS (SELECT p.word, ARRAY_AGG(p.one) as ones
                     FROM   map_output p 
                     GROUP BY (p.word)),

-- reducer phase
   reduce_output as (SELECT r.word, r.wordCount 
                     FROM   group_output q,
                               LATERAL(SELECT p.word, p.wordCount
                                       FROM reducer(q.word, q.ones) p) r)
--output
SELECT word, wordCount
FROM   reduce_output
order by 1,2;

/*
 word | wordcount 
------+-----------
 A    |         3
 B    |         4
 C    |         2
 D    |         2
 E    |         2
 F    |         1
(6 rows)
*/

/* We will now write another MapReduce program for the word count query.
   This program will do a local word count query withing the mapper function.
   The reducer will then also need to be changed.  Instead of counting one's
   it will need to sum the local word count to get the total word count*/

drop function mapper(text,text[]);

drop function reducer(text, int[]);

/* We can write a mapper function that does a local count
   of the word frequency withing a document */

CREATE OR REPLACE FUNCTION mapper(doc text, words text[]) 
RETURNS TABLE (word text, localWordCount bigint) AS
$$
   SELECT w.word, COUNT(1) as localWordCount
   FROM (SELECT UNNEST(words) AS word) w 
   GROUP BY (w.word)
$$ LANGUAGE SQL;

SELECT word, localwordcount 
FROM   mapper('d1',ARRAY['A','A','B','A','B','C','A'])
order by 1,2;

/*
 word | localwordcount 
------+----------------
 A    |              4
 B    |              2
 C    |              1
(3 rows)
*/

/* We then can write a reducer that receives for each word
   the local counts of that word in each document */

CREATE OR REPLACE FUNCTION reducer(word text, localWordCounts int[]) 
RETURNS TABLE(word text, wordCount bigint) AS
$$
   SELECT word, SUM(p.c) as wordCount
   FROM (SELECT UNNEST(localWordCounts) AS c) p
$$ LANGUAGE SQL;

SELECT word, wordCount
FROM   reducer('A','{3,1,7,4}');

/* word | wordcount 
------+-----------
 A    |        15
(1 row)
*/

/* Putting the entire simulation together */

WITH 
-- mapper phase
     map_output AS (SELECT q.word, q.localWordCount
                    FROM   Document d,
                            LATERAL(SELECT p.word, p.localWordCount
                                    FROM mapper(d.doc,d.words) p) q),
-- group phase
    group_output AS (SELECT p.word, ARRAY_AGG(p.localWordCOunt) as localWordCounts
                     FROM   map_output p 
                     GROUP BY (p.word)),
-- reducer phase
   reduce_output as (SELECT r.word, r.wordCount 
                     FROM   group_output q,
                               LATERAL(SELECT word, wordCount
                                       FROM reducer(q.word, q.localWordCounts::int[]) p) r)
--output
SELECT word, wordCount
FROM   reduce_output
order by 1,2;

/*
 word | wordcount 
------+-----------
 A    |         3
 B    |         4
 C    |         2
 D    |         2
 E    |         2
 F    |         1
(6 rows)
*/

CREATE OR REPLACE FUNCTION mapper(doc text, word text)
RETURNS TABLE (word text, one int) AS 
$$
 SELECT word, 1 as one;
$$ LANGUAGE SQL;


/* The mapper does the following */

select * from mapper('d1','A');

/* We now assume the input is docWord(doc, word)
   A pair (d,w) is in dowWord if w is a word in documment d */

/* table docWord;
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
(14 rows)
*/

/* The simulation is now as follows */

WITH 
-- mapper phase
     map_output AS (SELECT q.word, q.one
                    FROM   docWord dw,
                            LATERAL(SELECT p.word, p.one
                                    FROM mapper(dw.doc,dw.word) p) q),
-- group phase
    group_output AS (SELECT p.word, ARRAY_AGG(p.one) as ones
                     FROM   map_output p 
                     GROUP BY (p.word)),

-- reducer phase
   reduce_output as (SELECT r.word, r.wordCount 
                     FROM   group_output q,
                               LATERAL(SELECT p.word, p.wordCount
                                       FROM reducer(q.word, q.ones) p) r)
--output
SELECT word, wordCount
FROM   reduce_output
order by 1,2;

/* A word count problem on a key-value store Sentences(sid int, sentence text)*/


/*
table sentences;
 sid |                                                     sentence                                                     
-----+------------------------------------------------------------------------------------------------------------------
   1 | MapReduce is a programming model and an associated implementation for processing and generating large data sets\+
     | .
   2 | Users specify a map function that processes a key/value pair to generate a set of intermediate key/value pairs,\+
     | 
   3 | and a reduce function that merges all intermediate values associated with the same intermediate key.
   4 | Many real world tasks are expressible in this model, as shown in the paper.
   5 | Programs written in this functional style are automatically parallelized and executed on a large cluster of com\+
     | modity machines.
   7 | This allows programmers without any experience with parallel and distributed systems to easily utilize the reso\+
     | urces of a large distributed system.
   6 | The run-time system takes care of the details of partitioning the input data, scheduling the program execution \+
     | across a set of machines, handling machine failures, and managing the required inter-machine communication.
   8 | Our implementation of MapReduce runs on a large cluster of commodity machines and is highly scalable: a typical\+
     |  MapReduce computation processes many terabytes of data on thousands of machines.
   9 | Programmers find the system easy to use: hundreds of MapReduce programs have been implemented and upwards of on\+
     | e thousand MapReduce jobs are executed on Google clusters every day.
(9 rows)
*/


create or replace function mapper(sid int, sentence text) 
returns table(word text, one int) as
$$
  select unnest(regexp_split_to_array(sentence, '\s+')) as word, 1 as one;
$$ language sql;


WITH
-- mapper phase                                                                       
     map_output AS (SELECT q.word, q.one
                    FROM   Sentences s,
                            LATERAL(SELECT p.word, p.one
                                    FROM mapper(s.sid,s.sentence) p) q),
-- group phase                                                                        
    group_output AS (SELECT p.word, ARRAY_AGG(p.one) as ones
                     FROM   map_output p
                     GROUP BY (p.word)),

-- reducer phase                                                                      
   reduce_output as (SELECT r.word, r.wordCount
                     FROM   group_output q,
                               LATERAL(SELECT p.word, p.wordCount
                                       FROM reducer(q.word, q.ones) p) r)
--output                                                                              
SELECT word, wordCount
FROM   reduce_output
order by 2,1;

/*

      word      | wordcount 
----------------+-----------
                |         1
 .              |         1
 Google         |         1
 Many           |         1
 Our            |         1
 Programmers    |         1
 Programs       |         1
 The            |         1
 This           |         1
 Users          |         1
 \              |         1
 across         |         1
 all            |         1
 allows         |         1
 an             |         1
 any            |         1
 as             |         1
 automatically  |         1
 been           |         1
 care           |         1
 clusters       |         1
 com\           |         1
 commodity      |         1
 communication. |         1
 computation    |         1
 data,          |         1
 day.           |         1
 details        |         1
 e              |         1
 easily         |         1
 easy           |         1
 every          |         1
 execution      |         1
 experience     |         1
 expressible    |         1
 failures,      |         1
 find           |         1
 for            |         1
 functional     |         1
 generate       |         1
 generating     |         1
 handling       |         1
 have           |         1
 highly         |         1
 hundreds       |         1
 implemented    |         1
 input          |         1
 inter-machine  |         1
 jobs           |         1
 key.           |         1
 machine        |         1
 machines       |         1
 machines,      |         1
 managing       |         1
 many           |         1
 map            |         1
 merges         |         1
 model          |         1
 model,         |         1
 modity         |         1
 on\            |         1
 pair           |         1
 pairs,\        |         1
 paper.         |         1
 parallel       |         1
 parallelized   |         1
 partitioning   |         1
 processing     |         1
 program        |         1
 programmers    |         1
 programming    |         1
 programs       |         1
 real           |         1
 reduce         |         1
 required       |         1
 reso\          |         1
 run-time       |         1
 runs           |         1
 same           |         1
 scalable:      |         1
 scheduling     |         1
 sets\          |         1
 shown          |         1
 specify        |         1
 style          |         1
 system.        |         1
 systems        |         1
 takes          |         1
 tasks          |         1
 terabytes      |         1
 thousand       |         1
 thousands      |         1
 typical\       |         1
 upwards        |         1
 urces          |         1
 use:           |         1
 utilize        |         1
 values         |         1
 without        |         1
 world          |         1
 written        |         1
 associated     |         2
 cluster        |         2
 data           |         2
 distributed    |         2
 executed       |         2
 function       |         2
 implementation |         2
 is             |         2
 key/value      |         2
 machines.      |         2
 processes      |         2
 set            |         2
 system         |         2
 that           |         2
 this           |         2
 with           |         2
 are            |         3
 in             |         3
 intermediate   |         3
 to             |         3
 large          |         4
 on             |         4
 MapReduce      |         5
 and            |         8
 the            |         8
 a              |        10
 of             |        12
(128 rows)
*/
