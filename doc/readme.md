# Documentation

There are five different logging levels: "Exception", "Entry", "Begin", "Info",
and "Debug" with "Exception" being the highest and "Debug" being the lowest.

By default util_log uses the dblink extension to perform logging, although this
can be changed to use the pg_background extension (see notes in the
schema/11_create-util_log.sql file). If using the pg_background extension then
it is also necessary to increase the number of background workers
(max_worker_processes).

[API](api/readme.md)

## References

 * https://blog.dalibo.com/2016/08/19/Autonoumous_transactions_support_in_PostgreSQL.html
 * https://www.cybertec-postgresql.com/en/implementing-autonomous-transactions-in-postgres/
 * https://aws.amazon.com/blogs/database/migrating-oracle-autonomous-transactions-to-postgresql/
