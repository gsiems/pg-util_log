
\i 10_init_testrun.sql
\timing on
do
$$
declare
    r record ;
begin
    call util_log.log_to_dblink ( 10, 'foo', 1::text ) ;
end ;
$$ ;
\timing off

\i 80_finalize_testrun.sql
