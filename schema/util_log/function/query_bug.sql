CREATE OR REPLACE FUNCTION util_log.query_bug (
    a_tag text DEFAULT NULL )
RETURNS boolean
LANGUAGE plpgsql
AS $$
/**

Function query_bug is intended for including in views to log if the view is being queried from.

| Parameter                      | In/Out | Datatype   | Remarks                                            |
| ------------------------------ | ------ | ---------- | -------------------------------------------------- |
| a_tag                          | in     | text       | The optional tag to log.                           |

NB this is defined as a plpgsql (vs. plain sql) function, possibly
because it needs to be, but primarily to prevent the query optimizer
from optimizing it out of the view query.

    ```
    SELECT ...
        FROM ...
        WHERE ...
            AND util_log.query_bug ( 'optional tag' ) ;

    ```

*/
BEGIN

    call util_log.log_info ( coalesce ( a_tag, 'select' ) ) ;
    RETURN true ;

END ;
$$ ;
