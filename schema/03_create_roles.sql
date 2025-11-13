SET statement_timeout = 0 ;
SET client_encoding = 'UTF8' ;
SET standard_conforming_strings = ON ;
SET check_function_bodies = TRUE ;
SET client_min_messages = warning ;

\unset ON_ERROR_STOP

DROP ROLE util_log_tester ;

CREATE ROLE util_log_tester NOLOGIN NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION ;

COMMENT ON ROLE util_log_tester IS 'Role for testing util_log functionality' ;

\set ON_ERROR_STOP
