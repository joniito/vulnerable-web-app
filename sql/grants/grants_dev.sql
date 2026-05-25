-- =============================================================================
-- Redshift Grants - DEV environment
-- Managed via GitHub Actions. Do NOT apply manually.
-- =============================================================================

-- -------------------------
-- Schema: raw
-- -------------------------
GRANT USAGE ON SCHEMA raw TO GROUP analysts_dev;
GRANT SELECT ON ALL TABLES IN SCHEMA raw TO GROUP analysts_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA raw GRANT SELECT ON TABLES TO GROUP analysts_dev;

-- -------------------------
-- Schema: staging
-- -------------------------
GRANT USAGE ON SCHEMA staging TO GROUP data_engineers_dev;
GRANT ALL ON ALL TABLES IN SCHEMA staging TO GROUP data_engineers_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA staging GRANT ALL ON TABLES TO GROUP data_engineers_dev;

-- -------------------------
-- Schema: reporting
-- -------------------------
GRANT USAGE ON SCHEMA reporting TO GROUP analysts_dev;
GRANT USAGE ON SCHEMA reporting TO GROUP data_engineers_dev;
GRANT SELECT ON ALL TABLES IN SCHEMA reporting TO GROUP analysts_dev;
GRANT ALL   ON ALL TABLES IN SCHEMA reporting TO GROUP data_engineers_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA reporting GRANT SELECT ON TABLES TO GROUP analysts_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA reporting GRANT ALL    ON TABLES TO GROUP data_engineers_dev;

-- -------------------------
-- Service accounts
-- -------------------------
GRANT USAGE ON SCHEMA raw       TO svc_etl_dev;
GRANT USAGE ON SCHEMA staging   TO svc_etl_dev;
GRANT USAGE ON SCHEMA reporting TO svc_etl_dev;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA raw       TO svc_etl_dev;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA staging   TO svc_etl_dev;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA reporting TO svc_etl_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA raw       GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO svc_etl_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA staging   GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO svc_etl_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA reporting GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO svc_etl_dev;
