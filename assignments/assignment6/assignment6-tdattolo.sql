-- Assignment_6, tdattolo, B461

-- Write a PL/pgSQL program that computes and returns the maximum of two values.
-- Example :
-- Input num1 = 51, num2 = 32
-- Output : 51
CREATE OR REPLACE FUNCTION max(num1 INT, num2 INT) RETURNS INT AS $$
DECLARE
    result INT;
BEGIN
    IF num1 > num2 THEN
        result := num1;
    ELSE
        result := num2;
    END IF;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

select max(51,32);
select max(77,666);

-- Write a PL/pgSQL program that increments the salary of every employee in
-- customers by 500 and replace the salary(incremented) back into the table.
drop table customers;
create table customers(
    id int,
    primary key (id),
    name text,
    age int,
    address text,
    salary decimal
);
INSERT INTO customers VALUES
    (1,'Bhargav',32,'Ahmedabad',2000.00),
    (2,'Tarika',25,'Delhi',1500.00),
    (3,'John',23,'Kota',2000.00),
    (4,'Michael',25,'Mumbai',6500.00),
    (5,'Harish',27,'Bhopal',8500.00),
    (6,'Suraj',22,'MP',4500.00);

-- select * from customers;

-- drop function increment_salary();

CREATE OR REPLACE FUNCTION increment_salary() RETURNS TABLE (c customers) AS $$
DECLARE
    salary_increment int;
BEGIN
    salary_increment := 500;
    UPDATE customers
    SET salary = salary + salary_increment;
    RETURN QUERY SELECT * from customers;
END;
$$ LANGUAGE plpgsql;

select increment_salary();


-- 3. Write a PL/pgSQL program that reverses a number using postgresql function.
-- Example:
-- Input: num = 123
-- Output: 321

CREATE OR REPLACE FUNCTION reverse_number(num INT) RETURNS INT AS $$
DECLARE
    result INT;
BEGIN
    result := 0;
    WHILE num > 0 LOOP
        result := result * 10 + num % 10;
        num := num / 10;
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

select reverse_number(123);
select reverse_number(6789);

-- 4. Write a PL/pgSQL program that takes a number n as input and prints a right-angled
-- pyramid of *
--             Input:3
--             Output:
--             *
--             **
--             ***

-- drop function pyramid(n integer);
CREATE OR REPLACE FUNCTION pyramid(n integer) RETURNS text AS $$
DECLARE
    i INT;
    j INT;
    result text;
BEGIN
    result := '';
    FOR i IN 1..n LOOP
        FOR j IN 1..i LOOP
            result := result||'*';
--             raise notice '*';
        END LOOP;
        result := result||E'\n';
--         raise notice '\n';
    END LOOP;
    raise notice '%',result;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

select pyramid(3);
select pyramid(5);

-- 5. Write a PL/pgSQL program that takes two numbers and find the GCD (Greatest
-- Common Divisor) or HCF (Highest Common Factor) value of the numbers.
--             Example :
--             Input: num1 = 8, num2 = 48
--             Output: 8
CREATE OR REPLACE FUNCTION gcd(num1 INT, num2 INT) RETURNS INT AS $$
DECLARE
    result INT;
BEGIN
    WHILE num1 > 0 LOOP
        result := num1;
        num1 := num2 % num1;
        num2 := result;
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

select gcd(8,48);
select gcd(9, 54);