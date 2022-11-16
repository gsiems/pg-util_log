
\i 10_init_testrun.sql
\timing on
do
$$
declare
    r record ;
begin
    --for r in (
    --    select generate_series ( 1, 10 ) as idx ) loop
    --    call util_log.log_to_background ( 10, 'foo', r.idx::text ) ;
    --end loop ;
    call util_log.log_to_background ( 10, 'foo', 1::text ) ;
end ;
$$ ;
\timing off
\i 80_finalize_testrun.sql
