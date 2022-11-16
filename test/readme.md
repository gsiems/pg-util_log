# Purpose

To test the functionality of the util_log objecta and also to determine
some measure of the overhead imposed by using logging.

## Functions

| function          | description                                   |
| ----------------- | --------------------------------------------- |
| log_to_none       | return immediately without logging anything (for determining a baseline) |
| log_to_dblink     | use dblink to perform logging                 |
| log_to_background | use pg_background_launch to perform logging   |

## Tests

| test | description                                  |
| ---- | -------------------------------------------- |
| dici | call the dici function 1000 times            |
| n01  | call the no logging function once            |
| n02  | call the no logging function twice           |
| n05  | call the no logging function 5 times         |
| l01  | call the dblink logging function once        |
| l02  | call the dblink logging function twice       |
| l05  | call the dblink logging function 5 times     |
| b01  | call the background logging function once    |
| b02  | call the background logging function twice   |
| b05  | call the background logging function 5 times |

Trying to run 8 or more background logging calls in a loop pretty
consistently resulted in pg throwing the "53000: could not register
background process" error. Increasing the max_worker_processes
configuration parameter helps; however, as the logging activity
increases pg may start periodically throwing the "53000: could not
register background process" error again. I don't know how high the
max_worker_processes needs to be set to prevent this error completely.

## Results

* Each test was run 50 times

* Times are in ms.

|         |   dici |    n01 |    n02 |    n05 |    l01 |   l02  |    l05 |    b01 |    b02 |   b05 |
| ------- | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ |------ |
| min     |  1.941 |  0.742 |  0.736 |  0.758 | 12.228 | 13.278 | 15.409 |  1.575 |  1.899 | 2.917 |
| max     |  2.371 |  0.896 |  1.856 |  1.100 | 15.958 | 15.063 | 17.691 |  2.213 |  2.748 | 4.746 |
| average |  2.024 |  0.784 |  0.816 |  0.827 | 13.097 | 14.091 | 16.134 |  1.698 |  2.071 | 3.220 |

|               | none        | dblink      | background  |
| ------------- | ----------- | ----------- | ----------- |
| "setup"       | 0.75        | 12.10       | 1.33        |
| time per call | 0.01 - 0.03 | 0.76 - 0.99 | 0.37 - 0.38 |

## Takeaway

 * using pg_background_launch is significantly faster (as a percent)

 * using dblink is seemingly more robust

 * unless the logged procedures/functions are being hammered then it
 doesn't appear that logging adds any noticible overhead
