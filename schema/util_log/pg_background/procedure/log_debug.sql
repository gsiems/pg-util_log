CREATE OR REPLACE PROCEDURE util_log.log_debug (
    variadic a_args text[] )
LANGUAGE plpgsql
AS $$
BEGIN
    call util_log.log_to_background ( 50, variadic a_args ) ;
END ;
$$ ;
