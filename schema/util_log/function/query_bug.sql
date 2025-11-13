CREATE OR REPLACE FUNCTION util_log.query_bug (
    a_tag text DEFAULT NULL )
RETURNS boolean
LANGUAGE plpgsql
AS $$
/**
Function query_bug is intended for including in views to log if the view is
being queried from.

| Parameter                      | In/Out | Datatype   | Remarks                                            |
| ------------------------------ | ------ | ---------- | -------------------------------------------------- |
| a_tag                          | in     | text       | The optional tag to log.                           |

NB this is defined as a plpgsql (vs. plain sql) function, possibly because it
needs to be, but primarily to prevent the query optimizer from optimizing it
out of the view query.

Views can be logged using this function by including the function call in the
view definition. This is (potentially) useful for determining if a view is
actually being used.

While simpler,

```
    CREATE OR REPLACE VIEW ...
    AS
    SELECT t0.
        FROM some_table_name t0
        WHERE ...
            AND util_log.query_bug ( 'optional tag' ) ;
```

appears to result in a logging entry for each tuple selected.

Using a CTE however,

```
    CREATE OR REPLACE VIEW ...
    AS
    WITH qb AS (
        SELECT util_log.query_bug ( 'optional tag' ) AS x
    )
    SELECT t0.
        FROM some_table_name t0
        CROSS JOIN qb
        WHERE ...
            AND qb.x ;
```

appears to result in only one logging entry for each time the view is queried.

*/
BEGIN

    call util_log.log_info ( coalesce ( a_tag, 'select' ) ) ;
    RETURN true ;

END ;
$$ ;
