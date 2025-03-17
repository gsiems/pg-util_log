SET statement_timeout = 0 ;
SET client_encoding = 'UTF8' ;
SET standard_conforming_strings = on ;
SET check_function_bodies = true ;
SET client_min_messages = warning ;

DROP DATABASE IF EXISTS util_log ;

CREATE DATABASE util_log
    WITH TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8' ;

ALTER DATABASE util_log OWNER TO postgres ;

COMMENT ON DATABASE util_log IS 'Development and testing database for util_log functionality' ;

GRANT CONNECT ON DATABASE util_log TO util_log_tester ;
