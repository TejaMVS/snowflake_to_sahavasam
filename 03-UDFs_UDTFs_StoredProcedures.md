# Snowflake UDFs, UDTFs, and Stored Procedures

## 1. What is a UDF (User Defined Function)?

A **UDF** is a custom function created by users to perform a specific calculation or transformation and return a value.

### Simple Definition

> A UDF is like a calculator. You give it input, it processes the input, and returns a result.

### Example

```sql
CREATE OR REPLACE FUNCTION get_discount(price NUMBER)
RETURNS NUMBER
AS
$$
    price * 0.10
$$;
```

Usage:

```sql
SELECT get_discount(100);
```

Output:

```text
10
```

---

## 2. What is a UDTF (User Defined Table Function)?

A **UDTF** is a function that returns a table (multiple rows and columns) instead of a single value.

### Simple Definition

> A UDTF is like a mini query. You provide input and it returns a dataset.

### Example

```sql
CREATE OR REPLACE FUNCTION split_words(sentence STRING)
RETURNS TABLE(word STRING)
AS
$$
SELECT VALUE::STRING AS word
FROM TABLE(SPLIT_TO_TABLE(sentence, ' '))
$$;
```

Usage:

```sql
SELECT *
FROM TABLE(split_words('Hello Snowflake World'));
```

Output:

| WORD      |
| --------- |
| Hello     |
| Snowflake |
| World     |

---

## 3. What is a Stored Procedure?

A **Stored Procedure** is a collection of SQL statements and business logic that can perform multiple operations.

### Simple Definition

> A Stored Procedure is like a program or workflow that can execute many SQL statements and perform actions.

### Example

```sql
CREATE OR REPLACE PROCEDURE load_data()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN

    INSERT INTO target_table
    SELECT *
    FROM source_table;

    RETURN 'Data Loaded Successfully';

END;
$$;
```

Usage:

```sql
CALL load_data();
```

Output:

```text
Data Loaded Successfully
```

---

# UDF vs UDTF vs Stored Procedure

| Feature                                 | UDF                   | UDTF                        | Stored Procedure               |
| --------------------------------------- | --------------------- | --------------------------- | ------------------------------ |
| Full Form                               | User Defined Function | User Defined Table Function | Stored Procedure               |
| Returns                                 | Single value          | Table                       | Value, Variant, String, Result |
| Output Type                             | Scalar                | Rows & Columns              | Depends on implementation      |
| Used In                                 | SELECT clause         | FROM clause                 | CALL statement                 |
| Can return table?                       | ❌ No                  | ✅ Yes                       | Indirectly                     |
| Can contain multiple SQL statements?    | ❌ No                  | ❌ No                        | ✅ Yes                          |
| Can perform DML (INSERT/UPDATE/DELETE)? | ❌ No                  | ❌ No                        | ✅ Yes                          |
| Can perform DDL (CREATE/DROP)?          | ❌ No                  | ❌ No                        | ✅ Yes                          |
| Can contain loops?                      | ❌ No                  | ❌ No                        | ✅ Yes                          |
| Can contain IF conditions?              | Limited               | Limited                     | ✅ Yes                          |
| Used for calculations?                  | ✅ Yes                 | ❌ No                        | Sometimes                      |
| Used for ETL workflows?                 | ❌ No                  | ❌ No                        | ✅ Yes                          |
| Invoked using                           | Function Call         | TABLE()                     | CALL                           |
| Example                                 | get_tax(100)          | TABLE(split_words())        | CALL load_data()               |

---

# UDF Syntax

## SQL UDF Syntax

```sql
CREATE OR REPLACE FUNCTION function_name
(
    parameter_name DATA_TYPE
)
RETURNS RETURN_DATA_TYPE
AS
$$
    expression
$$;
```

### Example

```sql
CREATE OR REPLACE FUNCTION square_num(n NUMBER)
RETURNS NUMBER
AS
$$
    n * n
$$;
```

Usage:

```sql
SELECT square_num(5);
```

Output:

```text
25
```

---

# UDTF Syntax

```sql
CREATE OR REPLACE FUNCTION function_name
(
    parameter_name DATA_TYPE
)
RETURNS TABLE
(
    column_name DATA_TYPE
)
AS
$$
    SELECT ...
$$;
```

### Example

```sql
CREATE OR REPLACE FUNCTION get_employees(dept_id NUMBER)
RETURNS TABLE
(
    emp_id NUMBER,
    emp_name STRING
)
AS
$$
SELECT emp_id, emp_name
FROM employees
WHERE department_id = dept_id
$$;
```

Usage:

```sql
SELECT *
FROM TABLE(get_employees(10));
```

---

# Stored Procedure Syntax (SQL)

```sql
CREATE OR REPLACE PROCEDURE procedure_name()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN

    -- SQL Statements

    RETURN 'Success';

END;
$$;
```

### Example

```sql
CREATE OR REPLACE PROCEDURE delete_old_records()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN

    DELETE
    FROM sales
    WHERE order_date < '2024-01-01';

    RETURN 'Records Deleted';

END;
$$;
```

Usage:

```sql
CALL delete_old_records();
```

---

# When to Use What?

| Requirement                            | Use              |
| -------------------------------------- | ---------------- |
| Calculate tax, discount, commission    | UDF              |
| Format names or dates                  | UDF              |
| Split strings into rows                | UDTF             |
| Return multiple rows from custom logic | UDTF             |
| ETL process                            | Stored Procedure |
| Insert/Update/Delete data              | Stored Procedure |
| Create tables dynamically              | Stored Procedure |
| Run multiple SQL statements            | Stored Procedure |
| Error handling and loops               | Stored Procedure |

---

# Real-Life Analogy

| Object                     | Snowflake Component |
| -------------------------- | ------------------- |
| Calculator                 | UDF                 |
| Excel Table Generator      | UDTF                |
| Complete Automation Script | Stored Procedure    |

### Example

Suppose an employee salary is ₹50,000:

**UDF**

```sql
SELECT calculate_bonus(50000);
```

Returns:

```text
5000
```

**UDTF**

```sql
SELECT *
FROM TABLE(get_employee_details(101));
```

Returns:

| EMP_ID | NAME | SALARY |
| ------ | ---- | ------ |
| 101    | John | 50000  |

**Stored Procedure**

```sql
CALL monthly_payroll_process();
```

Performs:

1. Reads employee data
2. Calculates bonuses
3. Updates payroll table
4. Generates reports
5. Returns status message

---

# Quick Interview Answer

**What is the difference between UDF and Stored Procedure?**

| UDF                            | Stored Procedure            |
| ------------------------------ | --------------------------- |
| Returns a value                | Performs operations         |
| Used inside SQL queries        | Called separately           |
| Cannot modify database objects | Can modify database objects |
| Cannot run DML/DDL             | Can run DML/DDL             |
| Best for calculations          | Best for workflows and ETL  |
| Invoked in SELECT              | Invoked using CALL          |

**One-line answer:**

> A UDF is used to compute and return values inside queries, whereas a Stored Procedure is used to execute business logic, workflows, and database operations.
