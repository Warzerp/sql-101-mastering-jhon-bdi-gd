
-- 1.Crear usuario 
CREATE USER sm_admin WITH PASSWORD 'sm2025**';

-- 2. Create database (with ENCODING=   'UTF8', TEMPLATE=template)

CREATE DATABASE smarthdb WITH
ENCODING = 'UTF8'
LC_COLLATE = 'es_CO.UTF-8'
LC_TYPE = 'es_CO.UTF-8'
TEMPLATE=template0
OWNER = sm_admin;

--03. Grant privileges
GRANT ALL PRIVILEGES ON DATABASE smarthdb TO sm_admin;

--04. Create Schema
CREATE SCHEMA IF NOT EXISTS smart_health AUTHORIZATION sm_admin;

-- 05. Comment on database
COMMENT ON DATABASE smarthdb IS 'Base de datos para el control de pacientes y citas';

-- 06. Comment of schema
COMMENT ON SCHEMA smart_health IS 'Esquema principal para el sistema de pacientes y citas';

--ejecutar scripts en postgres postgres