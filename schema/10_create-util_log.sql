/*
NOTE

For actual deployment
 * the dbname needs to be updated,
 * the ownership needs to be set correctly
 * the desired logging extension needs to be specified (defaults to dblink) (see below)
*/

\connect util_log

SET statement_timeout = 0 ;
SET client_encoding = 'UTF8' ;
SET standard_conforming_strings = ON ;
SET check_function_bodies = TRUE ;
SET client_min_messages = warning ;

\unset ON_ERROR_STOP

DROP SCHEMA IF EXISTS util_log CASCADE ;

CREATE SCHEMA IF NOT EXISTS util_log ;

COMMENT ON SCHEMA util_log IS 'Schema and objects for logging database function and procedure calls' ;

\unset ON_ERROR_STOP

-- Tables --------------------------------------------------------------
\i util_log/table/st_log_level.sql
\i util_log/table/dt_proc_log.sql
\i util_log/table/dt_last_logged.sql

-- Views ---------------------------------------------------------------
\i util_log/view/dv_proc_log.sql
\i util_log/view/dv_proc_log_today.sql
\i util_log/view/dv_proc_log_last_hour.sql
\i util_log/view/dv_proc_log_last_day.sql
\i util_log/view/dv_proc_log_last_week.sql

GRANT SELECT ON util_log.dv_proc_log TO current_user ;
GRANT SELECT ON util_log.dv_proc_log_today TO current_user ;
GRANT SELECT ON util_log.dv_proc_log_last_hour TO current_user ;
GRANT SELECT ON util_log.dv_proc_log_last_day TO current_user ;
GRANT SELECT ON util_log.dv_proc_log_last_week TO current_user ;

-- Functions -----------------------------------------------------------
\i util_log/function/dici.sql
\i util_log/function/manage_partitions.sql
\i util_log/function/update_last_logged.sql

-- Specify Logger ------------------------------------------------------
\i schema/11_create-util_log-dblink.sql
--\i schema/11_create-util_log-pg_background.sql

-- Query bug -----------------------------------------------------------
\i util_log/function/query_bug.sql

GRANT USAGE ON SCHEMA util_log TO util_log_tester ;
GRANT EXECUTE ON FUNCTION util_log.manage_partitions TO util_log_tester ;
GRANT INSERT ON util_log.dt_proc_log TO util_log_tester ;
GRANT SELECT ON ALL TABLES IN SCHEMA util_log TO util_log_tester ;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO util_log_tester ;
