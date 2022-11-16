CREATE OR REPLACE PROCEDURE util_log.log_finish ()
LANGUAGE plpgsql
AS $$
BEGIN
    CALL util_log.log_to_dblink ( 40, 'finished' ) ;
END ;
$$ ;
