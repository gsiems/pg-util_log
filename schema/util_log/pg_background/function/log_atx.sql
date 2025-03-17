CREATE OR REPLACE FUNCTION util_log.log_atx (
    a_log_level integer,
    a_pid integer,
    a_obj_line_number integer,
    a_calling_obj_line_number integer,
    a_obj_name text,
    a_calling_obj_name text,
    a_remarks text )
RETURNS void
LANGUAGE SQL
SECURITY DEFINER
SET search_path = pg_catalog, util_log
AS $$
/**
Function log_atx inserts into the dt_proc_log table and is intended to
be called via pg_background_launch function for persisting log entries
in the event of rollbacks in the data processing

| Parameter                      | In/Out | Datatype   | Remarks                                            |
| ------------------------------ | ------ | ---------- | -------------------------------------------------- |
| a_log_level                    | in     | integer    | The logging level                                  |
| a_pid                          | in     | integer    | The process ID of the client connection            |
| a_obj_line_number              | in     | integer    | The line number of the object (callee) being logged |
| a_calling_obj_line_number      | in     | integer    | The line number of the calling object where the callee was called |
| a_obj_name                     | in     | text       | The name of the object being called                |
| a_calling_obj_name             | in     | text       | The name of the object that called the callee      |
| a_remarks                      | in     | text       | The remarks/text to be logged                      |

*/

INSERT INTO util_log.dt_proc_log (
        date_exec,
        tmsp_exec,
        client_address,
        client_port,
        pid,
        log_level,
        obj_line_number,
        calling_obj_line_number,
        db_name,
        username,
        application_name,
        obj_name,
        calling_obj_name,
        remarks )
    SELECT current_date AS date_exec,
            current_timestamp AS tmsp_exec,
            psa.client_addr,
            psa.client_port,
            psa.pid,
            a_log_level AS log_level,
            a_obj_line_number AS obj_line_number,
            a_calling_obj_line_number AS calling_obj_line_number,
            psa.datname AS db_name,
            psa.usename AS username,
            psa.application_name,
            a_obj_name AS obj_name,
            a_calling_obj_name AS calling_obj_name,
            a_remarks AS remarks
        FROM pg_stat_activity psa
        WHERE psa.pid = a_pid
        LIMIT 1 ;

$$ ;
