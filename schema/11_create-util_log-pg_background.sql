-- NOTE: If using pg_background for logging, use this

\unset ON_ERROR_STOP

CREATE EXTENSION IF NOT EXISTS pg_background ;

\set ON_ERROR_STOP

-- Functions -----------------------------------------------------------
\i util_log/pg_background/function/log_atx.sql

-- Procedures ----------------------------------------------------------
\i util_log/pg_background/procedure/log_to_background.sql
\i util_log/pg_background/procedure/log_begin.sql
\i util_log/pg_background/procedure/log_debug.sql
\i util_log/pg_background/procedure/log_exception.sql
\i util_log/pg_background/procedure/log_finish.sql
\i util_log/pg_background/procedure/log_info.sql
