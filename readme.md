# pg-util_log

Database logging for PostgreSQL functions and procedures.

The goal is to be able to log information from functions and procedures
that will persist regardless of whethere the transaction for the
function/procedure is commited or rolled back. Since PostgreSQL does
not (currently) support autonomous sub-transactions a little creativity
is required.

# Examples

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

# References

 * https://blog.dalibo.com/2016/08/19/Autonoumous_transactions_support_in_PostgreSQL.html
 * https://www.cybertec-postgresql.com/en/implementing-autonomous-transactions-in-postgres/
 * https://aws.amazon.com/blogs/database/migrating-oracle-autonomous-transactions-to-postgresql/
