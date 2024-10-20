\connect postgres postgres
SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'vis3d' AND pid <> pg_backend_pid();
DROP DATABASE IF EXISTS vis3d;
DROP ROLE IF EXISTS admin_vis3d;
DROP ROLE IF EXISTS user_vis3d;
DROP ROLE IF EXISTS user_external;
