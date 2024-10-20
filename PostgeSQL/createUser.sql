DO
$do$
BEGIN
   IF EXISTS (
      SELECT * FROM pg_catalog.pg_roles
      WHERE  rolname = 'user_external') THEN

      RAISE NOTICE 'Role "user_external" already exists. Skipping.';
   ELSE
      CREATE ROLE user_external LOGIN PASSWORD 'password';
	  COMMENT ON ROLE user_external IS 'Пользователь';
   END IF;
END
$do$;