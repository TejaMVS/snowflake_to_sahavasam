-- set context 
USE ROLE SYSADMIN;
USE WAREHOUSE COMPUTE_WH;


-- create demo database and schema 
CREATE DATABASE DEMO_DB;
CREATE SCHEMA DEMO_SCHEMA;

--User Defined Functions

-- select query for function
SELECT
  'In 100 days it will be a ' ||
  DAYNAME(
    DATEADD(day,100,CURRENT_DATE())
  );

-- Without string direct usinf system defined functions
SELECT DAYNAME(DATEADD(day,100,CURRENT_DATE()));

-- Some system defined functions 
SELECT CURRENT_DATE();
SELECT DAYNAME(DATEADD(day,100,CURRENT_DATE()));
-- syntax : DATEADD(<date_part>, <value>, <date>) 
-- date_part → unit (day, month, year, hour, etc.)
-- value → how many units to add/subtract
-- date → the starting date or timestamp

SELECT DAYNAME(CURRENT_DATE()); 
SELECT DATEADD(day,100,CURRENT_DATE());

-- Converts text to uppercase
SELECT UPPER('snowflake') AS upper_text; -- creates column with uppertext and row value is SNOWFLAKE
SELECT UPPER('snowflake');   -- BY default the column name is taken as UPPER('snowflake') , default behaviour

-- Converts text to lowercase
SELECT LOWER('SNOWFLAKE') AS lower_text;

-- Counts the number of rows
SELECT COUNT(*) AS total_rows
FROM employees;

-- Calculates the total of a numeric column
SELECT SUM(salary) AS total_salary
FROM employees;

-- Calculates the average of a numeric column
SELECT AVG(salary) AS average_salary
FROM employees;




-- SQL UDF to return the name of the day of the week on a date in the future
CREATE OR REPLACE FUNCTION DAY_NAME_ON(num_of_days int)
RETURNS STRING
  AS
  $$
    select 'In ' || CAST(num_of_days AS string) || ' days it will be a ' || dayname(dateadd(day,num_of_days, current_date()))
  $$; 
  -- single quote can be used instead of dollar sign to delimit function body
  
  
-- Use the SQL UDF as part of a query. 
SELECT DAY_NAME_ON(100);

-- CAST Understanding:
-- ===================
-- CAST() IN SNOWFLAKE

-- Definition:
-- CAST() converts a value from one data type to another.

-- Syntax
CAST(expression AS data_type);

-- Alternative Syntax
expression::data_type;

-- Number -> String
SELECT CAST(100 AS STRING);

-- String -> Number
SELECT CAST('100' AS NUMBER);

-- String -> Date
SELECT CAST('2026-06-02' AS DATE);

-- Date -> String
SELECT CAST(CURRENT_DATE() AS STRING);

-- String -> Timestamp
SELECT CAST('2026-06-02 10:30:00' AS TIMESTAMP);

-- Number -> Boolean
SELECT CAST(1 AS BOOLEAN);
SELECT CAST(0 AS BOOLEAN);

-- Alternative (::) Syntax
SELECT '100'::NUMBER;
SELECT CURRENT_DATE()::STRING;

-- String Concatenation
SELECT 'Employee ID: ' || CAST(100 AS STRING);

-- Mathematical Calculation
SELECT CAST('5000' AS NUMBER) * 12 AS annual_salary;

-- CAST throws error on invalid conversion
SELECT CAST('ABC' AS NUMBER);

-- TRY_CAST returns NULL instead of error
SELECT TRY_CAST('ABC' AS NUMBER);


-- AS (ALIAS)

-- Gives a temporary name to a column

SELECT UPPER('snowflake') AS upper_text;

-- Without AS
SELECT UPPER('snowflake');

-- Aggregate Function Alias
SELECT COUNT(*) AS total_employees
FROM employees;


-- BUILT-IN STRING FUNCTIONS

-- Convert text to uppercase
SELECT UPPER('snowflake') AS upper_text;

-- Convert text to lowercase
SELECT LOWER('SNOWFLAKE') AS lower_text;


-- AGGREGATE FUNCTIONS

-- Count rows
SELECT COUNT(*) AS total_rows
FROM employees;

-- Sum values
SELECT SUM(salary) AS total_salary
FROM employees;

-- Average values
SELECT AVG(salary) AS average_salary
FROM employees;


-- DATEADD()

-- Syntax
DATEADD(date_part, value, date);

-- Add 10 days
SELECT DATEADD(day, 10, CURRENT_DATE());

-- Add 2 months
SELECT DATEADD(month, 2, CURRENT_DATE());

-- Add 1 year
SELECT DATEADD(year, 1, CURRENT_DATE());

-- Subtract 7 days
SELECT DATEADD(day, -7, CURRENT_DATE());

-- Common date_part values:
-- day
-- week
-- month
-- quarter
-- year
-- hour
-- minute
-- second


-- DAYNAME()

-- Returns day of week

SELECT DAYNAME(CURRENT_DATE());

SELECT DAYNAME('2026-09-10');


-- CURRENT_DATE()

-- Returns today's date

SELECT CURRENT_DATE();


-- UDF (USER DEFINED FUNCTION)

CREATE OR REPLACE FUNCTION DAY_NAME_ON(num_of_days INT)
RETURNS STRING
AS
$$
SELECT 'In '
       || CAST(num_of_days AS STRING)
       || ' days it will be a '
       || DAYNAME(
            DATEADD(day, num_of_days, CURRENT_DATE())
          )
$$;

-- Execute UDF
SELECT DAY_NAME_ON(100);

-- Sample Output
-- In 100 days it will be a Thu


-- Function Flow

-- CURRENT_DATE()
--        ↓
-- DATEADD(day,100,CURRENT_DATE())
--        ↓
-- Future Date
--        ↓
-- DAYNAME(Future Date)
--        ↓
-- Thu
--        ↓
-- String Concatenation
--        ↓
-- In 100 days it will be a Thu


-- COMMENTS

-- Single-line comment

/*
Multi-line
comment
*/


-- Interview One-Liners

-- CAST() : Converts one data type to another.
-- AS : Creates a temporary alias for a column or table.
-- DATEADD() : Adds/Subtracts date or time intervals.
-- DAYNAME() : Returns day name from a date.
-- CURRENT_DATE() : Returns current system date.
-- UDF : Custom function created by the user.
-- COUNT() : Counts rows.
-- SUM() : Returns total of a numeric column.
-- AVG() : Returns average of a numeric column.
-- UPPER() : Converts text to uppercase.
-- LOWER() : Converts text to lowercase.



-- ==========================================================
-- SAMPLE DATA FOR UNION, UNION ALL
-- ==========================================================

-- ----------------------------------------------------------
-- CREATE TABLES FOR UNION / UNION ALL
-- ----------------------------------------------------------
CREATE DATABASE DEMO_DB;
CREATE SCHEMA DEMO_SCHEMA;
USE DATABASE DEMO_DB;
USE SCHEMA DEMO_SCHEMA;

CREATE OR REPLACE TABLE employees_2025 (
    emp_id INT,
    emp_name STRING
);

CREATE OR REPLACE TABLE employees_2026 (
    emp_id INT,
    emp_name STRING
);

-- Insert Sample Data

INSERT INTO employees_2025 VALUES
(1, 'John'),
(2, 'Alice'),
(3, 'Bob');

INSERT INTO employees_2026 VALUES
(3, 'Bob'),
(4, 'David'),
(5, 'Emma');

-- ----------------------------------------------------------
-- UNION
-- Removes duplicate rows
-- ----------------------------------------------------------

SELECT emp_id, emp_name
FROM employees_2025

UNION

SELECT emp_id, emp_name
FROM employees_2026;

-- Expected Result
--
-- 1  John
-- 2  Alice
-- 3  Bob
-- 4  David
-- 5  Emma


-- ----------------------------------------------------------
-- UNION ALL
-- Keeps duplicate rows
-- ----------------------------------------------------------

SELECT emp_id, emp_name
FROM employees_2025

UNION ALL

SELECT emp_id, emp_name
FROM employees_2026;

-- Expected Result
--
-- 1  John
-- 2  Alice
-- 3  Bob
-- 3  Bob
-- 4  David
-- 5  Emma


-- ----------------------------------------------------------
-- COUNT EXAMPLE WITH UNION ALL
-- ----------------------------------------------------------

SELECT 'employees_2025' AS table_name,
       COUNT(*) AS row_count
FROM employees_2025

UNION ALL

SELECT 'employees_2026' AS table_name,
       COUNT(*) AS row_count
FROM employees_2026;

-- Expected Result
--
-- employees_2025   3
-- employees_2026   3

-- ==============================================================================

-- JOIN  UNDERSTANDING :
-- =======================

-- ==========================================================
-- SQL JOINS - QUICK REFERENCE
-- ==========================================================

-- +--------------+------------------------------------------+-----------------------------+
-- | JOIN TYPE    | RETURNS                                  | MEMORY TRICK               |
-- +--------------+------------------------------------------+-----------------------------+
-- | INNER JOIN   | Matching rows from both tables          | Common records only        |
-- | LEFT JOIN    | All Left + Matching Right               | Keep everything on Left    |
-- | RIGHT JOIN   | Matching Left + All Right               | Keep everything on Right   |
-- | FULL JOIN    | All rows from both tables               | Keep everything            |
-- | CROSS JOIN   | Every row with every row                | Cartesian Product          |
-- | SELF JOIN    | Table joined with itself                | Same table ↔ Same table    |
-- +--------------+------------------------------------------+-----------------------------+


-- ==========================================================
-- SAMPLE SYNTAX
-- ==========================================================

-- INNER JOIN
SELECT *
FROM employees e
INNER JOIN departments d
ON e.emp_id = d.emp_id;

-- LEFT JOIN
SELECT *
FROM employees e
LEFT JOIN departments d
ON e.emp_id = d.emp_id;

-- RIGHT JOIN
SELECT *
FROM employees e
RIGHT JOIN departments d
ON e.emp_id = d.emp_id;

-- FULL OUTER JOIN
SELECT *
FROM employees e
FULL OUTER JOIN departments d
ON e.emp_id = d.emp_id;

-- CROSS JOIN
SELECT *
FROM employees e
CROSS JOIN departments d;

-- SELF JOIN
SELECT e.emp_name,
       m.emp_name AS manager_name
FROM employees e
JOIN employees m
ON e.manager_id = m.emp_id;


-- ==========================================================
-- RESULT BEHAVIOR
-- ==========================================================

-- +--------------+----------------+-----------------+
-- | JOIN TYPE    | LEFT ROWS      | RIGHT ROWS      |
-- +--------------+----------------+-----------------+
-- | INNER JOIN   | Matching Only  | Matching Only   |
-- | LEFT JOIN    | All            | Matching Only   |
-- | RIGHT JOIN   | Matching Only  | All             |
-- | FULL JOIN    | All            | All             |
-- | CROSS JOIN   | All x All      | All x All       |
-- | SELF JOIN    | Same Table     | Same Table      |
-- +--------------+----------------+-----------------+


-- ==========================================================
-- INTERVIEW ONE-LINERS
-- ==========================================================

-- INNER JOIN : Returns only matching records from both tables.
-- LEFT JOIN  : Returns all rows from left table and matching rows from right.
-- RIGHT JOIN : Returns all rows from right table and matching rows from left.
-- FULL JOIN  : Returns all rows from both tables.
-- CROSS JOIN : Returns Cartesian product (every row with every row).
-- SELF JOIN  : Joins a table with itself.

-- Note:
-- JOIN = INNER JOIN (by default)

-- Example:
SELECT *
FROM employees e
JOIN departments d
ON e.emp_id = d.emp_id;

-- Same as:
SELECT *
FROM employees e
INNER JOIN departments d
ON e.emp_id = d.emp_id;


-- =============      **********************    =======================

-- ==========================================================
-- ORDER BY vs GROUP BY IN SNOWFLAKE
-- ==========================================================

-- SAMPLE TABLE

CREATE OR REPLACE TABLE employees (
    emp_id INT,
    emp_name STRING,
    dept STRING,
    salary NUMBER
);

INSERT INTO employees VALUES
(1, 'John',  'IT', 50000),
(2, 'Alice', 'HR', 70000),
(3, 'Bob',   'IT', 60000),
(4, 'David', 'HR', 50000);

-- ==========================================================
-- ORDER BY
-- ==========================================================

-- Purpose:
-- Sorts the result set.
-- Does NOT group or aggregate data.

-- Sort salary ascending (default)

SELECT *
FROM employees
ORDER BY salary;

-- Sort salary descending

SELECT *
FROM employees
ORDER BY salary DESC;

-- Sort by multiple columns

SELECT *
FROM employees
ORDER BY dept, salary DESC;


-- ==========================================================
-- GROUP BY
-- ==========================================================

-- Purpose:
-- Groups rows having the same value.
-- Usually used with aggregate functions.

-- Count employees per department

SELECT dept,
       COUNT(*) AS employee_count
FROM employees
GROUP BY dept;

-- Total salary per department

SELECT dept,
       SUM(salary) AS total_salary
FROM employees
GROUP BY dept;

-- Average salary per department

SELECT dept,
       AVG(salary) AS avg_salary
FROM employees
GROUP BY dept;


-- ==========================================================
-- ORDER BY + GROUP BY TOGETHER
-- ==========================================================

SELECT dept,
       SUM(salary) AS total_salary
FROM employees
GROUP BY dept
ORDER BY total_salary DESC;


-- ==========================================================
-- KEY DIFFERENCES
-- ==========================================================

-- +-----------+--------------------------------------------+
-- | ORDER BY  | Sorts rows                                 |
-- | GROUP BY  | Creates groups and aggregates data         |
-- +-----------+--------------------------------------------+

-- ORDER BY:
-- Input  : 4 rows
-- Output : Same 4 rows, different order

-- GROUP BY:
-- Input  : 4 rows
-- Output : 2 rows (IT, HR)


-- ==========================================================
-- RULES
-- ==========================================================

-- Valid

SELECT dept,
       COUNT(*)
FROM employees
GROUP BY dept;

-- Invalid

SELECT dept,
       emp_name,
       COUNT(*)
FROM employees
GROUP BY dept;

-- Error:
-- emp_name is neither grouped nor aggregated

-- Fix

SELECT dept,
       COUNT(*)
FROM employees
GROUP BY dept;


-- ==========================================================
-- EXECUTION ORDER
-- ==========================================================

-- FROM
-- WHERE
-- GROUP BY
-- HAVING
-- SELECT
-- ORDER BY


-- ==========================================================
-- INTERVIEW ONE-LINERS
-- ==========================================================

-- ORDER BY:
-- Used to sort query results in ascending or descending order.

-- GROUP BY:
-- Used to group rows with the same values and perform
-- aggregate calculations such as COUNT, SUM, AVG, MIN, MAX.

-- Memory Trick:
-- ORDER BY = Arrange Rows
-- GROUP BY = Combine Similar Rows