-- Switch to ACCOUNTADMIN role for full administrative privileges
USE ROLE ACCOUNTADMIN;

-- Select the warehouse to run queries
USE WAREHOUSE COMPUTE_WH;

-- Use Snowflake sample database
USE DATABASE SNOWFLAKE_SAMPLE_DATA;

-- Use TPCH sample schema
USE SCHEMA TPCH_SF1;

-- Display all tables in current schema
SHOW TABLES;

-- Check if CUSTOMER table exists
SHOW TABLES LIKE 'CUSTOMER';

-- View all records from CUSTOMER table
SELECT * FROM CUSTOMER;

-- Verify CUSTOMER table again
SHOW TABLES LIKE 'CUSTOMER';

-- Describe structure of CUSTOMER table
DESC TABLE CUSTOMER;

-- Verify CUSTOMER table once more
SHOW TABLES LIKE 'CUSTOMER';

-- Read metadata from previous SHOW TABLES command
SELECT
    "name",
    "database_name",
    "schema_name",
    "kind",
    "is_external",
    "retention_time"
FROM
    TABLE(RESULT_SCAN(LAST_QUERY_ID()));



-- Create a new database for demo purpose
CREATE OR REPLACE DATABASE DEMO_DB;

-- Create a new schema inside DEMO_DB
CREATE OR REPLACE SCHEMA DEMO_SCHEMA;

-- Display all databases
SHOW DATABASES;

-- Switch to DEMO_DB database
USE DATABASE DEMO_DB;

-- Switch to DEMO_SCHEMA schema
USE SCHEMA DEMO_SCHEMA;



-- Create a permanent table
CREATE TABLE PERMANENT_TABLE
(
    NAME STRING,
    AGE INT
);

-- Show all tables in schema
SHOW TABLES;

-- Query permanent table
SELECT * FROM PERMANENT_TABLE;



-- Drop temporary table if needed
-- DROP TABLE TEMPORARY_TABLE;

-- Create a temporary table
CREATE TEMPORARY TABLE TEMPORARY_TABLE
(
    NAME STRING,
    AGE INT
);

-- Show all tables including temp table
SHOW TABLES;



-- Create a transient table
CREATE TRANSIENT TABLE TRANSIENT_TABLE 
(
    NAME STRING,
    AGE INT
);

-- Display all available tables
SHOW TABLES;

-- Display tables again for verification
SHOW TABLES;



-- Set retention period for permanent table to 90 days
ALTER TABLE PERMANENT_TABLE 
SET DATA_RETENTION_TIME_IN_DAYS = 90;

-- Change retention period to 60 days
ALTER TABLE PERMANENT_TABLE 
SET DATA_RETENTION_TIME_IN_DAYS = 60;

-- Verify updated retention settings
SHOW TABLES;



-- Retention > 1 day is not allowed for temporary tables
-- ALTER TABLE TEMPORARY_TABLE 
-- SET DATA_RETENTION_TIME_IN_DAYS = 2;

-- Set temporary table retention to 1 day
ALTER TABLE TEMPORARY_TABLE 
SET DATA_RETENTION_TIME_IN_DAYS = 1;

-- Verify table settings
SHOW TABLES;

-- Set temporary table retention to 0 days
ALTER TABLE TEMPORARY_TABLE 
SET DATA_RETENTION_TIME_IN_DAYS = 0;

-- Verify changes again
SHOW TABLES;



-- Create an external table using parquet files
CREATE EXTERNAL TABLE EXT_TABLE
(
    col1 VARCHAR AS (value:col1::varchar),
    col2 VARCHAR AS (value:col2::int),
    col3 VARCHAR AS (value:col3::varchar)
)
LOCATION = @s1/logs/
FILE_FORMAT = (TYPE = parquet);



-- Create a standard view from permanent table
CREATE OR REPLACE VIEW STANDARD_VIEW AS
SELECT * FROM PERMANENT_TABLE;

-- Display all views
SHOW VIEWS;

-- Describe standard view structure
DESC VIEW STANDARD_VIEW;



-- Create a secure view
CREATE OR REPLACE SECURE VIEW SECURE_VIEW AS
SELECT * FROM PERMANENT_TABLE;

-- Display all views again
SHOW VIEWS;

-- Describe standard view again
DESC VIEW STANDARD_VIEW;



-- Create a materialized view
CREATE MATERIALIZED VIEW MATERIALIZED_VIEW AS
SELECT * FROM PERMANENT_TABLE;

-- Display all views including materialized view
SHOW VIEWS;



-- Retrieve metadata for views
SELECT 
    "name", 
    "database_name", 
    "schema_name", 
    "is_secure", 
    "is_materialized"
FROM 
    TABLE(RESULT_SCAN(LAST_QUERY_ID()));



-- Insert sample data into permanent table
INSERT INTO PERMANENT_TABLE (NAME, AGE) VALUES
('Alice', 29),
('Bob', 34),
('Charlie', 41),
('Diana', 25),
('Ethan', 38);

-- Query data from standard view
SELECT * FROM STANDARD_VIEW;

-- Query data from secure view
SELECT * FROM SECURE_VIEW;



-- Show all database-level parameters
SHOW PARAMETERS IN DATABASE DEMO_DB;

-- Check retention parameter value
SELECT *
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
WHERE "key" = 'DATA_RETENTION_TIME_IN_DAYS';



-- Show account-level parameters
SHOW PARAMETERS IN ACCOUNT;



-- Drop DEMO_DB database
DROP DATABASE DEMO_DB;

-- Restore dropped database using Time Travel
UNDROP DATABASE DEMO_DB;



-- Create clone database as backup
CREATE DATABASE DEMO_DB_BACKUP CLONE DEMO_DB;



-- Remove original database
DROP DATABASE DEMO_DB;

-- Remove cloned backup database
DROP DATABASE DEMO_DB_BACKUP;