/* The following is an example of triggers that result in infinite loop */
/* In this example, we use BEFORE INSERT trigger on relation W */


CREATE OR REPLACE FUNCTION insert_in_W() RETURNS TRIGGER AS
   $$
   BEGIN
      INSERT INTO W VALUES(NEW.x);
      RETURN NEW;
   END;
   $$ LANGUAGE 'plpgsql';


CREATE TRIGGER insert_into_W_table
    BEFORE INSERT ON W
    FOR EACH ROW
    EXECUTE PROCEDURE insert_in_W();



/* In this example, we use AFTER INSERT trigger on relation W */


CREATE OR REPLACE FUNCTION insert_in_W() RETURNS TRIGGER AS
   $$
   BEGIN
      INSERT INTO W VALUES(NEW.x);
      RETURN NEW;
   END;
   $$ LANGUAGE 'plpgsql';



CREATE TRIGGER insert_into_W_table
    AFTER INSERT ON W
    FOR EACH ROW
    EXECUTE PROCEDURE insert_in_W();


/* We even get infinite loop if we returns NULL in trigger function */

/* With a AFTER TRIGGER */


CREATE OR REPLACE FUNCTION insert_in_W() RETURNS TRIGGER AS
   $$
   BEGIN
      INSERT INTO W VALUES(NEW.x);
      RETURN NULL;
   END;
   $$ LANGUAGE 'plpgsql';


CREATE TRIGGER insert_into_W_table
    AFTER INSERT ON W
    FOR EACH ROW
    EXECUTE PROCEDURE insert_in_W();

/* Altenitvely with BEFORE INSERT trigger */

CREATE OR REPLACE FUNCTION insert_in_W() RETURNS TRIGGER AS
   $$
   BEGIN
      INSERT INTO W VALUES(NEW.x);
      RETURN NULL;
   END;
   $$ LANGUAGE 'plpgsql';


CREATE TRIGGER insert_into_W_table
    BEFORE INSERT ON W
    FOR EACH ROW
    EXECUTE PROCEDURE insert_in_W();



/* The following is an example of triggers that result in infinite loop */
/* In this example, we use BEFORE INSERT triggers on U and V */
CREATE TABLE U(x int);

CREATE TABLE V(x,int);


CREATE OR REPLACE FUNCTION insert_in_U() RETURNS TRIGGER AS
   $$
   BEGIN
      INSERT INTO V VALUES(NEW.x);
      RETURN NEW;
   END;
   $$ LANGUAGE 'plpgsql';


CREATE TRIGGER insert_into_U_table
    BEFORE INSERT ON U
    FOR EACH ROW
    EXECUTE PROCEDURE insert_in_U();


CREATE OR REPLACE FUNCTION insert_in_V() RETURNS TRIGGER AS
   $$
   BEGIN
      INSERT INTO U VALUES(NEW.x);
      RETURN NEW;
   END;
   $$ LANGUAGE 'plpgsql';


CREATE TRIGGER insert_into_V_table
    BEFORE INSERT ON V
    FOR EACH ROW
    EXECUTE PROCEDURE insert_in_V();


-- Another similar example of an infinite loop with triggers;
-- but with after

CREATE OR REPLACE FUNCTION insert_in_U() RETURNS TRIGGER AS
   $$
   BEGIN
      INSERT INTO V VALUES(NEW.x);
      RETURN NEW;
   END;
   $$ LANGUAGE 'plpgsql';


CREATE TRIGGER insert_into_U_table
    AFTER INSERT ON U
    FOR EACH ROW
    EXECUTE PROCEDURE insert_in_U();


CREATE OR REPLACE FUNCTION insert_in_V() RETURNS TRIGGER AS
   $$
   BEGIN
      INSERT INTO U VALUES(NEW.x);
      RETURN NEW;
   END;
   $$ LANGUAGE 'plpgsql';


CREATE TRIGGER insert_into_V_table
    AFTER INSERT ON V
    FOR EACH ROW
    EXECUTE PROCEDURE insert_in_V();


--

/* Maintaining the same state for U and V needs to be done with views on
   a relation W that keeps the state for U and V */

create view u  as (select * from w);
create view v  as (select * from w);

create table w (x int);

CREATE OR REPLACE FUNCTION insert_in_U() RETURNS TRIGGER AS
   $$
   BEGIN
      INSERT INTO W VALUES(NEW.x);

      RETURN NULL;
   END;
   $$ LANGUAGE 'plpgsql';

CREATE TRIGGER insert_into_U_table
    INSTEAD OF INSERT ON U
    FOR EACH ROW
    EXECUTE PROCEDURE insert_in_U();

CREATE OR REPLACE FUNCTION insert_in_V() RETURNS TRIGGER AS
   $$
   BEGIN
      INSERT INTO W VALUES(NEW.x);

      RETURN NULL;
   END;
   $$ LANGUAGE 'plpgsql';


CREATE TRIGGER insert_into_V_table
    INSTEAD OF INSERT ON V
    FOR EACH ROW
    EXECUTE PROCEDURE insert_in_V();