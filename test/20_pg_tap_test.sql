
\c util_log

SET search_path = tap, test, pg_catalog, public ;

-- Turn off echo and keep things quiet.
\unset ECHO
\set QUIET 1

-- Format the output for nice TAP.
\pset format unaligned
\pset tuples_only true
\pset pager off

-- Revert all changes on failure.
\set ON_ERROR_ROLLBACK off
\set ON_ERROR_STOP on

ALTER PROCEDURE util_log.log_to_background OWNER to util_log_tester ;
ALTER PROCEDURE util_log.log_to_dblink OWNER to util_log_tester ;
ALTER PROCEDURE util_log.log_to_none OWNER to util_log_tester ;

BEGIN ;

-- Load any required test functions
\i function/log_to_background.sql
\i function/log_to_dblink.sql
\i function/log_to_none.sql

-- Plan count should be the number of tests
SELECT plan ( 12 ) ;

SELECT ok (
    util_log.dici ( true ) = 'true'::text,
    'dici 01'
    ) ;

SELECT ok (
    util_log.dici ( false ) = 'false'::text,
    'dici 02'
    ) ;

SELECT ok (
    util_log.dici ( 3.14::numeric ) = '3.14'::text,
    'dici 03'
    ) ;

SELECT ok (
    util_log.dici ( '2022-10-20'::date ) = '2022-10-20'::text,
    'dici 04'
    ) ;

SELECT ok (
    util_log.dici ( '11/12/1999'::date ) = '1999-11-12'::text,
    'dici 05'
    ) ;

SELECT ok (
    util_log.dici ( null::date ) = 'null'::text,
    'dici 06'
    ) ;

SELECT ok (
    test.log_to_none ( null::text ),
    'log_to_none 01'
    ) ;

SELECT ok (
    test.log_to_none ( 'foo', 'bar', 'baz' ),
    'log_to_none 02'
    ) ;

SELECT ok (
    test.log_to_dblink ( null::text ),
    'log_to_dblink 01'
    ) ;

SELECT ok (
    test.log_to_dblink ( 'foo', 'bar', 'baz' ),
    'log_to_dblink 02'
    ) ;

SELECT ok (
    test.log_to_background ( null::text ),
    'log_to_background 01'
    ) ;

SELECT ok (
    test.log_to_background ( 'foo', 'bar', 'baz' ),
    'log_to_background 02'
    ) ;

SELECT *
    FROM finish () ;

ROLLBACK ;
