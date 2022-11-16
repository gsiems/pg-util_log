
\c util_log

SET statement_timeout = 0 ;
SET client_encoding = 'UTF8' ;
SET standard_conforming_strings = on ;
SET check_function_bodies = true ;
SET client_min_messages = warning ;

\unset ON_ERROR_STOP

DROP SCHEMA IF EXISTS util_log CASCADE ;

CREATE EXTENSION IF NOT EXISTS dblink ;

CREATE SCHEMA IF NOT EXISTS util_log ;

COMMENT ON SCHEMA util_log IS 'Schema and objects for logging database function and procedure calls' ;

/*
NOTE

For actual deployment
 * the dbname needs to be updated,
 * the ownership needs to be set correctly
 * the loopback user mapping(s) need to be properly specified; 'util_log_tester' is not a good username and is an even worse password.
 * TODO: is there any way to make this work without hard coding a password in the user mapping? .pgpass somehow?
*/
CREATE SERVER loopback_dblink FOREIGN DATA WRAPPER dblink_fdw
    OPTIONS ( hostaddr '127.0.0.1', dbname 'util_log' ) ;

ALTER SERVER loopback_dblink OWNER TO util_log_tester ;

CREATE USER MAPPING FOR util_log_tester SERVER loopback_dblink
    OPTIONS ( user 'util_log_tester', password 'util_log_tester' ) ;

CREATE USER MAPPING FOR current_user SERVER loopback_dblink
    OPTIONS ( user 'util_log_tester', password 'util_log_tester' ) ;

\set ON_ERROR_STOP

-- Tables --------------------------------------------------------------
\i util_log/table/st_log_level.sql
\i util_log/table/dt_proc_log.sql

-- Views ---------------------------------------------------------------
\i util_log/view/dv_proc_log.sql
\i util_log/view/dv_proc_log_today.sql
\i util_log/view/dv_proc_log_last_hour.sql
\i util_log/view/dv_proc_log_last_day.sql

GRANT SELECT ON util_log.dv_proc_log TO current_user ;
GRANT SELECT ON util_log.dv_proc_log_today TO current_user ;
GRANT SELECT ON util_log.dv_proc_log_last_hour TO current_user ;
GRANT SELECT ON util_log.dv_proc_log_last_day TO current_user ;

-- Functions -----------------------------------------------------------
\i util_log/function/dici.sql
\i util_log/function/log_atx.sql
\i util_log/function/manage_partitions.sql

-- Procedures ----------------------------------------------------------
\i util_log/procedure/log_to_none.sql
\i util_log/procedure/log_to_background.sql
\i util_log/procedure/log_to_dblink.sql
\i util_log/procedure/log_begin.sql
\i util_log/procedure/log_debug.sql
\i util_log/procedure/log_exception.sql
\i util_log/procedure/log_finish.sql
\i util_log/procedure/log_info.sql

-- Query bug -----------------------------------------------------------
\i util_log/function/query_bug.sql

GRANT USAGE ON SCHEMA util_log TO util_log_tester ;
GRANT EXECUTE ON FUNCTION util_log.manage_partitions TO util_log_tester ;
GRANT INSERT ON util_log.dt_proc_log TO util_log_tester ;
GRANT SELECT ON ALL TABLES IN SCHEMA util_log TO util_log_tester ;
