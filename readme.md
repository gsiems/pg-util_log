# pg-util_log

Database logging for PostgreSQL functions and procedures (and views).

The goal is to be able to log information from PLpgSQL functions and
procedures, SQL functions and views that will persist regardless of whether the
transaction for the function/procedure/query is commited or rolled back. Since
PostgreSQL does not (currently) support autonomous sub-transactions a little
creativity is required.

[Documentation](doc/readme.md)
