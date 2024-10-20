\connect vis3d postgres
--'classifiersmodel' schema.
CREATE SCHEMA IF NOT EXISTS classifiersmodel AUTHORIZATION postgres;
COMMENT ON SCHEMA classifiersmodel IS 'Схема данных "Модель"';
-- Tables in 'classifiersmodel' schema
-- Table 'classifierModels'
-- Sequence: classifiersmodel.classifiermodels_id_seq
do 
$$
begin
if not exists (
    select relname 
        from pg_statio_all_sequences
    where schemaname = 'classifiersmodel'
        and relname = 'classifiermodels_id_seq'
)
then
    CREATE SEQUENCE classifiersmodel.classifiermodels_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807;
	COMMENT ON SEQUENCE classifiersmodel.classifiermodels_id_seq IS 'Предназначена для генерации первичных ключей таблицы "classifierModels"';
end if;
end 
$$;
ALTER SEQUENCE IF EXISTS classifiersmodel.classifiermodels_id_seq OWNER TO postgres;
-- DROP TABLE IF EXISTS classifiersmodel.classifiermodels;
do 
$$
begin
RAISE INFO 'Table |classifierModels|';
end 
$$;

CREATE TABLE IF NOT EXISTS classifiersmodel.classifiermodels(ID integer NOT NULL DEFAULT nextval('classifiersmodel.classifiermodels_id_seq'),
  ModelCodeID integer NOT NULL DEFAULT currval('classifiersmodel.classifiermodels_id_seq'),
  Name character varying(29) NOT NULL,
  Description text,
  CONSTRAINT "classifiermodels_idx_pk" PRIMARY KEY (ID),
  CONSTRAINT "classifiermodels_modelcodeid_key" UNIQUE (ModelCodeID)
);
COMMENT ON TABLE classifiersmodel.classifiermodels IS 'Классификатор моделей экспериментов';
COMMENT ON COLUMN classifiersmodel.classifiermodels.ID IS 'Уникальный идентификатор модели эксперимента';
COMMENT ON COLUMN classifiersmodel.classifiermodels.ModelCodeID IS 'Код модели эксперимента';
COMMENT ON COLUMN classifiersmodel.classifiermodels.Name IS 'Наименование модели эксперимента';
COMMENT ON COLUMN classifiersmodel.classifiermodels.Description IS 'Описание модели эксперимента';
COMMENT ON CONSTRAINT classifiermodels_idx_pk ON classifiersmodel.classifiermodels IS 'Первичный ключ - столбец ID';
COMMENT ON CONSTRAINT classifiermodels_modelcodeid_key ON classifiersmodel.classifiermodels IS 'Ограничение по уникальности столбца ModelCodeID';
-- Index: classifiersmodel."classifiermodels_idx_un1"
-- DROP INDEX classifiersmodel."classifiermodels_idx_un1";
do 
$$
begin
if not exists (
    select indexname
        from pg_indexes
    where schemaname = 'classifiersmodel'
        and tablename = 'classifiermodels'
        and indexname = 'classifiermodels_idx_un1'
)
then
    CREATE UNIQUE INDEX "classifiermodels_idx_un1" ON classifiersmodel.classifiermodels (ModelCodeID);
--COMMENT ON INDEX "classifiermodels_idx_un1" IS 'Обеспечивает уникальность по коду модели эксперимента';
end if;
if not exists (
    select indexname
        from pg_indexes
    where schemaname = 'classifiersmodel'
        and tablename = 'classifiermodels'
        and indexname = 'classifiermodels_idx_idx1'
)
then
    CREATE INDEX "classifiermodels_idx_idx1" ON classifiersmodel.classifiermodels ((lower(Name)));
--COMMENT ON INDEX "classifiermodels_idx_idx1" IS 'Для поиска по наименованию модели эксперимента';
end if;
end 
$$;
GRANT ALL PRIVILEGES ON SCHEMA classifiersmodel TO postgres WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA classifiersmodel TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA classifiersmodel TO postgres;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA classifiersmodel TO postgres;
GRANT USAGE ON SCHEMA classifiersmodel TO user_external;
GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER ON ALL TABLES IN SCHEMA classifiersmodel TO user_external;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA classifiersmodel TO user_external;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA classifiersmodel TO user_external;
GRANT USAGE ON SCHEMA classifiersmodel TO public;
GRANT SELECT ON ALL TABLES IN SCHEMA classifiersmodel TO public;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA classifiersmodel TO public;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA classifiersmodel TO public;
ALTER DEFAULT PRIVILEGES FOR USER postgres IN SCHEMA classifiersmodel GRANT ALL PRIVILEGES ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR USER postgres IN SCHEMA classifiersmodel GRANT ALL PRIVILEGES ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR USER postgres IN SCHEMA classifiersmodel GRANT ALL PRIVILEGES ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR USER user_external IN SCHEMA classifiersmodel GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO user_external;
ALTER DEFAULT PRIVILEGES FOR USER user_external IN SCHEMA classifiersmodel GRANT ALL PRIVILEGES ON SEQUENCES TO user_external;
ALTER DEFAULT PRIVILEGES FOR USER user_external IN SCHEMA classifiersmodel GRANT EXECUTE ON FUNCTIONS TO user_external;
ALTER DEFAULT PRIVILEGES IN SCHEMA classifiersmodel GRANT SELECT ON TABLES TO public;
ALTER DEFAULT PRIVILEGES IN SCHEMA classifiersmodel GRANT USAGE, SELECT ON SEQUENCES TO public;
ALTER DEFAULT PRIVILEGES IN SCHEMA classifiersmodel GRANT EXECUTE ON FUNCTIONS TO public;