#!/bin/sh

rm *.timing.out

for ((i = 1; i <= 50; i++)); do

    psql -f 40_perf_test_none_01.sql | grep Time >>40_perf_test_none_01.timing.out
    psql -f 40_perf_test_none_02.sql | grep Time >>40_perf_test_none_02.timing.out
    psql -f 40_perf_test_none_05.sql | grep Time >>40_perf_test_none_05.timing.out

    psql -f 50_perf_test_dblink_01.sql | grep Time >>50_perf_test_dblink_01.timing.out
    psql -f 50_perf_test_dblink_02.sql | grep Time >>50_perf_test_dblink_02.timing.out
    psql -f 50_perf_test_dblink_05.sql | grep Time >>50_perf_test_dblink_05.timing.out

    psql -f 60_perf_test_background_01.sql | grep Time >>60_perf_test_background_01.timing.out
    psql -f 60_perf_test_background_02.sql | grep Time >>60_perf_test_background_02.timing.out
    psql -f 60_perf_test_background_05.sql | grep Time >>60_perf_test_background_05.timing.out

    psql -f 70_perf_test_dici_01.sql | grep Time >>70_perf_test_dici_01.timing.out
    psql -f 70_perf_test_dici_1000.sql | grep Time >>70_perf_test_dici_1000.timing.out

done
