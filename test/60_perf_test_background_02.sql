
\i 10_init_testrun.sql
\timing on
do
$$
declare
    r record ;
begin
    for r in (
        select generate_series ( 1, 2 ) as idx ) loop
        call util_log.log_to_background ( 10, 'foo', r.idx::text ) ;
    end loop ;
end ;
$$ ;
\timing off
\i 80_finalize_testrun.sql
