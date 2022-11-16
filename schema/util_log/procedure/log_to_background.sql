CREATE OR REPLACE PROCEDURE util_log.log_to_background (
    a_log_level integer,
    variadic a_args text[] )
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
/**
Function log_to_background takes a logging level and a variable list of text values,
determines which function/procedure was called (and which function/procedure
called it (if applicable)) and uses pg_background_launch to log the results.

| Parameter                      | In/Out | Datatype   | Remarks                                            |
| ------------------------------ | ------ | ---------- | -------------------------------------------------- |
| a_log_level                    | in     | integer    | The logging level (per st_log_level)               |
| a_args                         | in     | text[]     | The list of elements to log                        |

*/
DECLARE

    l_stack text ;
    l_called text ;
    l_caller text ;
    l_calling_obj_name text ;
    l_obj_name text ;
    l_calling_obj_line_number text ;
    l_obj_line_number text ;
    x text ;
    i integer := 0 ;
    l_log_level integer ;
    l_cmd text ;
    l_remarks text ;
    l_count integer ;

BEGIN

    GET DIAGNOSTICS l_stack = PG_CONTEXT ;

    -- NB the stack has different number of lines depending on if functions are called vs procedures
    --
    -- NOTICE:  --- Call Stack ---
    -- PL/pgSQL function util_log.log_entry(text[]) line 9 at GET DIAGNOSTICS
    -- SQL statement "CALL util_log.log_entry(util_log.dici(42))"
    -- PL/pgSQL function foo.proc_two() line 3 at CALL
    -- SQL statement "CALL foo.proc_two()"
    -- PL/pgSQL function foo.func_one() line 3 at CALL
    --
    -- The topmost "PL/pgSQL .." line should be the call to this,
    -- the second "PL/pgSQL .." line should be the callee,
    -- the third "PL/pgSQL .." line should be the caller

    FOREACH x IN ARRAY string_to_array ( l_stack, E'\n' ) LOOP
        IF starts_with ( x, 'PL/pgSQL'::text ) THEN
            i := i + 1 ;
            IF i = 3 THEN
                l_called := split_part ( x, 'PL/pgSQL function '::text, 2 ) ;

                l_obj_line_number := split_part ( l_called, ') line '::text, 2 ) ;
                l_obj_line_number := split_part ( l_obj_line_number, ' '::text, 1 ) ;

                l_obj_name := split_part ( l_called, ')'::text, 1 ) || ')' ;

            ELSIF i = 4 THEN
                l_caller := split_part ( x, 'PL/pgSQL function '::text, 2 ) ;

                l_calling_obj_line_number := split_part ( l_caller, ') line '::text, 2 ) ;
                l_calling_obj_line_number := split_part ( l_calling_obj_line_number, ' '::text, 1 ) ;

                l_calling_obj_name := split_part ( l_caller, ')'::text, 1 ) || ')' ;

                EXIT ;
            END IF ;
        END IF ;
    END LOOP ;

    -- If the log entry is for the beginning of a function/procedure then
    -- check if the function/procedure being called is being called from
    -- another function/procedure or if it is being called as an entry point.
    l_log_level := a_log_level ;
    IF l_log_level = 30 AND l_calling_obj_name IS NULL THEN
        l_log_level := 20 ;
    END IF ;

    l_remarks := quote_literal ( array_to_string ( a_args, ', ' ) ) ;

    l_cmd := 'select true from util_log.log_atx ( '
        || 'a_log_level => ' || ( coalesce ( l_log_level, 0 ) )::text || ', '
        || 'a_pid => ' || pg_backend_pid()::text || ', '
        || 'a_obj_line_number => ' || coalesce ( l_obj_line_number, 'null::integer' ) || ', '
        || 'a_calling_obj_line_number => ' || coalesce ( l_calling_obj_line_number, 'null::integer' ) || ', '
        || 'a_obj_name => ' || quote_nullable ( l_obj_name ) || ', '
        || 'a_calling_obj_name => ' || quote_nullable ( l_calling_obj_name ) || ', '
        || 'a_remarks => ' || l_remarks || ' ) ;' ;

    SELECT count(*)
        INTO l_count
        FROM public.pg_background_launch ( l_cmd ) ;

END;
$$ ;
