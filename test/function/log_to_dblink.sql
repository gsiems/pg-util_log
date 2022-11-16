CREATE OR REPLACE FUNCTION test.log_to_dblink (
    variadic a_args text[] )
RETURNS boolean
LANGUAGE plpgsql
AS $$
BEGIN
    CALL util_log.log_to_dblink ( 30, variadic a_args ) ;
    RETURN true ;
END ;
$$ ;
