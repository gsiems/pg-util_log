
\i 10_init_testrun.sql
\timing on
do
$$
declare
    r record ;
    t text ;
begin
    t := util_log.dici ( 3.14 ) ;
end ;
$$ ;
\timing off
\i 80_finalize_testrun.sql
