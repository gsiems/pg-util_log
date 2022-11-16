# pg-util_log

Database logging for PostgreSQL functions and procedures.

The goal is to be able to log information from functions and procedures
that will persist regardless of whethere the transaction for the
function/procedure is commited or rolled back. Since PostgreSQL does
not (currently) support autonomous sub-transactions a little creativity
is required.

# Examples

## Functions/procedures

To log the calling parameters to a function/procedure:

    ```
    call util_log.log_begin (
        util_log.dici ( parameter_one ),
        util_log.dici ( parameter_two ),
        ...
        util_log.dici ( parameter_n ) ) ;
    ```

To log an exception:

    ```
    call util_log.log_exception ( SQLSTATE::text || ' - ' || SQLERRM ) ;
    ```

## Views

Views can also be logged using the util_log.query_bug function by including the fuction call in the view definition. This is (potentially) useful for determining if a view is actually being used.

While simpler,
    ```
    CREATE OR REPLACE VIEW ...
    AS
    SELECT t0.
        FROM some_table_name t0
        WHERE ...
            AND util_log.query_bug ( 'blah blah blah' ) ;
    ```
appears to result in a logging entry for each tuple selected.

Using a CTE however,
    ```
    CREATE OR REPLACE VIEW ...
    AS
    WITH qb AS (
        SELECT util_log.query_bug ( 'blah blah blah' ) AS x
    )
    SELECT t0.
        FROM some_table_name t0
        CROSS JOIN qb
        WHERE ...
            AND qb.x ;
    ```
appears to result in one logging entry for each time the view is queried.

# References

 * https://blog.dalibo.com/2016/08/19/Autonoumous_transactions_support_in_PostgreSQL.html
 * https://www.cybertec-postgresql.com/en/implementing-autonomous-transactions-in-postgres/
 * https://aws.amazon.com/blogs/database/migrating-oracle-autonomous-transactions-to-postgresql/
