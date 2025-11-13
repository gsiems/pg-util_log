CREATE OR REPLACE PROCEDURE util_log.log_begin (
    variadic a_args text[] )
LANGUAGE plpgsql
AS $$
/**
Procedure log_begin is used to log the beginning of a function/procedure

If the function/procedure is called from another function/procedure then this
is logged as "Begin" level, otherwise this is logged as "Entry" level.

| Parameter                      | In/Out | Datatype   | Remarks                                            |
| ------------------------------ | ------ | ---------- | -------------------------------------------------- |
| a_args                         | in     | text[]     | The list of elements to log                        |

*/
BEGIN
    call util_log.log_to_dblink ( 30, variadic a_args ) ;
END ;
$$ ;
