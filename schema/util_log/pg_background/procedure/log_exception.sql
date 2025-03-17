CREATE OR REPLACE PROCEDURE util_log.log_exception (
    variadic a_args text[] )
LANGUAGE plpgsql
AS $$
BEGIN
    call util_log.log_to_background ( 10, variadic a_args ) ;
END ;
$$ ;
