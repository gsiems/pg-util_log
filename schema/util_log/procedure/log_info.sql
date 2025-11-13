CREATE OR REPLACE PROCEDURE util_log.log_info (
    variadic a_args text[] )
LANGUAGE plpgsql
AS $$
BEGIN
    call util_log.log_to_dblink ( 40, variadic a_args ) ;
END ;
$$ ;
