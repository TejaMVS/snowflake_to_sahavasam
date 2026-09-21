-- =====================================================
-- Snowflake Parameter Precedence Demo
-- Demonstrates Account, User, Session, and Object
-- parameter hierarchy and overrides
-- =====================================================

-- =========================
-- Environment Setup
-- =========================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;

CREATE DATABASE DEMO_DB;
CREATE SCHEMA DEMO_SCHEMA;

CREATE TABLE DEMO_TABLE
(
NAME STRING,
AGE INT
);


-- =========================
-- Account Parameters
-- =========================

-- Change to enable Workspaces as default
ALTER ACCOUNT SET USE_WORKSPACES_FOR_SQL = always;

-- =========================
-- Session Parameters
-- =========================
ALTER ACCOUNT SET DATE_OUTPUT_FORMAT = 'YYYY/MM/DD';
ALTER USER SET DATE_OUTPUT_FORMAT = 'DD-MM-YYYY';
ALTER SESSION SET DATE_OUTPUT_FORMAT = 'DD, MM, YYYY';

-- Verify effective session setting
SELECT CURRENT_DATE();

SHOW PARAMETERS;

-- Verify effective session setting
SELECT CURRENT_DATE();

-- =========================
-- Inspect Parameter Values
-- =========================
SHOW PARAMETERS;

SHOW PARAMETERS LIKE 'DATE_OUTPUT_FORMAT';

SHOW PARAMETERS IN ACCOUNT;



SHOW PARAMETERS IN DATABASE DEMO_DB;
DESC DATABASE DEMO_DB;
SHOW PARAMETERS IN SCHEMA DEMO_SCHEMA;

SHOW PARAMETERS IN USER;
SHOW PARAMETERS IN ACCOUNT;
SHOW PARAMETERS IN SESSION;

-- By default if no session/user/account in defined , it will show user PARAMETERS
SHOW PARAMETERS ;

SHOW PARAMETERS LIKE 'DATE_OUTPUT_FORMAT';

-- =========================
-- Object Parameters
-- =========================
ALTER DATABASE DEMO_DB

SET DATA_RETENTION_TIME_IN_DAYS = 7;
ALTER SCHEMA DEMO_SCHEMA

SET DATA_RETENTION_TIME_IN_DAYS = 5;

ALTER TABLE DEMO_TABLE SET DATA_RETENTION_TIME_IN_DAYS = 3;

CREATE TABLE SECOND_DEMO_TABLE 
(
  NAME STRING,
  AGE INT
);

SHOW PARAMETERS LIKE 'DATA_RETENTION_TIME_IN_DAYS' IN TABLE second_demo_table;

SHOW PARAMETERS LIKE 'DATA_RETENTION_TIME_IN_DAYS' IN TABLE demo_table;

SHOW PARAMETERS LIKE 'DATA_RETENTION_TIME_IN_DAYS' IN DATABASE DEMO_DB;


-- =========================
-- Cleanup
-- =========================
DROP DATABASE DEMO_DB;