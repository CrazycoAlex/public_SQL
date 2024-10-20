--CREATE TABLESPACE fastspace LOCATION '/ssd1/postgresql/data';
DROP DATABASE IF EXISTS vis3d;
CREATE DATABASE vis3d WITH OWNER = postgres ENCODING = 'UTF8' 
--TABLESPACE=fastspace;
TABLESPACE=pg_default;
\connect vis3d postgres
COMMENT ON DATABASE vis3d IS 'База данных СПО';
GRANT CONNECT, TEMPORARY ON DATABASE vis3d TO public;
GRANT ALL ON DATABASE vis3d TO postgres;
GRANT CONNECT, TEMPORARY ON DATABASE vis3d TO user_external;
