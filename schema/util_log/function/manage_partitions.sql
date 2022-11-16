CREATE OR REPLACE FUNCTION util_log.manage_partitions ()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
/**
Procedure manage_partitions creates (and disposes of) table partitions
for the util_log.dt_proc_log table.

*/
DECLARE

    l_schema_name varchar := 'util_log' ;   -- The name of the schema for the partitioned table
    l_table_name varchar := 'dt_proc_log' ; -- The name of the table to manage partitions for
    l_retention_days integer := 30 ;        -- The number of past days to retain logs for.
    l_pre_days integer := 10 ;              -- The number of future days to pre-create partitions for.
                                            -- The intent is to maintain a buffer so that, in the
                                            -- event that this function is not run for a few days,
                                            -- the logging functionality can continue to work.

    dt record ;
    l_cmd text ;

BEGIN

    -- ASSERTION: the schema name and table name of the partioned table do not require quoting
    -- ASSERTION: there are no other partitioned tables in the schema that have a similar name
    -- ASSERTION: the table partitions reside in the same schema as the parent table

    -- NB: in the event that there are ever any partitions that are desired to be preserved
    --  beyond the retention schedule then they either need to be renamed in such fashion that
    --  breaks the naming pattern or, better yet, manually detached from the parent table

    FOR dt IN (
        WITH args AS (
            SELECT l_retention_days AS retention_days,
                    l_pre_days AS pre_days,
                    l_retention_days + l_pre_days AS total_days,
                    l_schema_name AS schema_name,
                    l_table_name AS table_name,
                    l_schema_name || '.' || l_table_name AS parent_table
        ),
        dates AS (
            SELECT ( current_date + ( ( s.idx - args.retention_days )::text || ' days'::text )::interval )::date AS partition_date
                FROM args
                CROSS JOIN (
                    SELECT idx
                        FROM generate_series ( 1, ( SELECT total_days FROM args ), 1 ) AS gs ( idx )
                    ) s
        ),
        new_parts AS (
            SELECT args.parent_table || '_' || to_char ( dates.partition_date, 'yyyymmdd' ) AS partition_name,
                    to_char ( dates.partition_date, 'yyyy-mm-dd' ) AS partition_date
                FROM dates
                CROSS JOIN args
        ),
        cur_parts AS (
            SELECT n.nspname || '.' || c.relname AS partition_name
                FROM pg_catalog.pg_class c
                JOIN pg_catalog.pg_namespace n
                    ON ( n.oid = c.relnamespace )
                JOIN pg_catalog.pg_inherits i
                    ON ( c.oid = i.inhrelid )
                CROSS JOIN args
                WHERE n.nspname = args.schema_name
                    AND c.relname::text ~ ( args.table_name || '_.+' )::text
        )
        SELECT args.parent_table,
                cur_parts.partition_name AS current_partition,
                new_parts.partition_name AS new_partition,
                new_parts.partition_date
            FROM cur_parts
            FULL JOIN new_parts
                ON ( cur_parts.partition_name = new_parts.partition_name )
            CROSS JOIN args ) LOOP

        IF dt.current_partition IS NULL THEN

            l_cmd := 'CREATE TABLE '
                || dt.new_partition
                || ' PARTITION OF '
                || dt.parent_table
                || ' FOR VALUES FROM ( '''
                || dt.partition_date
                || '''::date ) TO ( ( '''
                || dt.partition_date
                || '''::date + ''1 day''::interval )::date )' ;

            --RAISE NOTICE E' % ;', l_cmd ;
            EXECUTE l_cmd ;

        ELSIF dt.new_partition IS NULL THEN

            l_cmd := 'ALTER TABLE '
                || dt.parent_table
                || ' DETACH PARTITION '
                || dt.current_partition ;

            --RAISE NOTICE E' % ;', l_cmd ;
            EXECUTE l_cmd ;

            l_cmd := 'DROP TABLE ' || dt.current_partition ;

            --RAISE NOTICE E' % ;', l_cmd ;
            EXECUTE l_cmd ;

        END IF ;

    END LOOP ;

END ;
$$ ;

SELECT true FROM util_log.manage_partitions () ;
