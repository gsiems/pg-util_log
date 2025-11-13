/*
NOTE: If using dblink for logging, use this

For actual deployment
 * the dbname needs to be updated,
 * the loopback user mapping(s) need to be properly specified; 'util_log_tester' is not a good username and is an even worse password.
 * TODO: is there any way to make this work without hard coding a password in the user mapping? .pgpass somehow?
*/

\unset ON_ERROR_STOP

CREATE EXTENSION IF NOT EXISTS dblink ;

CREATE SERVER loopback_dblink FOREIGN DATA WRAPPER dblink_fdw
    OPTIONS ( hostaddr '127.0.0.1', dbname 'util_log' ) ;

ALTER SERVER loopback_dblink OWNER TO util_log_tester ;

CREATE USER MAPPING FOR util_log_tester SERVER loopback_dblink
    OPTIONS ( user 'util_log_tester', password 'util_log_tester' ) ;

CREATE USER MAPPING FOR CURRENT_USER SERVER loopback_dblink
    OPTIONS ( user 'util_log_tester', password 'util_log_tester' ) ;

\set ON_ERROR_STOP

-- Functions -----------------------------------------------------------

-- Procedures ----------------------------------------------------------
\i util_log/procedure/log_to_dblink.sql
\i util_log/procedure/log_begin.sql
\i util_log/procedure/log_debug.sql
\i util_log/procedure/log_exception.sql
\i util_log/procedure/log_finish.sql
\i util_log/procedure/log_info.sql
