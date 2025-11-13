/*
NOTE: If using dblink for logging, use this

For actual deployment
 * the dbname needs to be updated,
 * the loopback user mapping(s) need to be properly specified; 'util_log_tester' is not a good username and is an even worse password.
 * TODO: is there any way to make this work without hard coding a password in the user mapping? .pgpass somehow?
*/

CREATE EXTENSION IF NOT EXISTS dblink ;

\unset ON_ERROR_STOP

DROP SERVER IF EXISTS loopback_dblink CASCADE ;

CREATE SERVER loopback_dblink FOREIGN DATA WRAPPER dblink_fdw
    OPTIONS ( hostaddr '127.0.0.1', dbname 'util_log' ) ;

ALTER SERVER loopback_dblink OWNER TO util_log_tester ;

DO
$$
DECLARE
    r record ;
BEGIN
    FOR r IN (
        WITH x AS (
            -- upper case letters
            SELECT chr ( ( 65 + round ( random () * 25 ) )::integer ) AS x
                FROM generate_series ( 1, 26 )
            UNION
            -- lower case letters
            SELECT chr ( ( 97 + round ( random () * 25 ) )::integer )
                FROM generate_series ( 1, 26 )
            UNION
            -- numbers
            SELECT chr ( ( 48 + round ( random () * 9 ) )::integer )
                FROM generate_series ( 1, 10 )
        ),
        y AS (
            SELECT x AS chrs
                FROM x
                ORDER BY random ()
                LIMIT ( 20 + round ( random () * 10 ) )
        )
        SELECT array_to_string ( array_agg ( chrs ), '' ) AS passwd
            FROM y ) LOOP

        EXECUTE format ('ALTER ROLE util_log_tester LOGIN PASSWORD %L', r.passwd ) ;

        EXECUTE format ('CREATE USER MAPPING FOR util_log_tester SERVER loopback_dblink
            OPTIONS ( user ''util_log_tester'', password %L )', r.passwd ) ;

        EXECUTE format ('CREATE USER MAPPING FOR CURRENT_USER SERVER loopback_dblink
            OPTIONS ( user ''util_log_tester'', password %L )', r.passwd ) ;

    END LOOP ;
END ;
$$ ;

\set ON_ERROR_STOP

-- Functions -----------------------------------------------------------

-- Procedures ----------------------------------------------------------
\i util_log/procedure/log_to_dblink.sql
\i util_log/procedure/log_begin.sql
\i util_log/procedure/log_debug.sql
\i util_log/procedure/log_exception.sql
\i util_log/procedure/log_finish.sql
\i util_log/procedure/log_info.sql
