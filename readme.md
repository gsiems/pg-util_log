# pg-util_log

Database logging for PostgreSQL functions and procedures (and views).

The goal is to be able to log information from functions and procedures  that
will persist regardless of whether the transaction for the function/procedure
is commited or rolled back. Since PostgreSQL does not (currently) support
autonomous sub-transactions a little creativity is required.

Views can also be logged using the util_log.query_bug function by including the
function call in the view definition. While not recommended for general use
this is (potentially) useful for determining if a view is actually being used.

[Documentation](doc/readme.md)
