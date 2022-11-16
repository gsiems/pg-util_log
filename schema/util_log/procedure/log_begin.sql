CREATE OR REPLACE PROCEDURE util_log.log_begin (
    variadic a_args text[] )
LANGUAGE plpgsql
AS $$
BEGIN
    CALL util_log.log_to_dblink ( 30, variadic a_args ) ;
END ;
$$ ;
