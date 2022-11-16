
\i 10_init_testrun.sql
\timing on
do
$$
declare
    r record ;
    t text ;
begin
    for r in (
        select generate_series ( 1, 200 ) as idx ) loop
        t := util_log.dici ( r.idx ) ;
        t := util_log.dici ( 3.14 ) ;
        t := util_log.dici ( current_time ) ;
        t := util_log.dici ( 'foo'::char ) ;
        t := util_log.dici ( true ) ;
    end loop ;
end ;
$$ ;
\timing off
\i 80_finalize_testrun.sql
