-- =============================================================================
-- Redshift Grants - PROD environment
-- Managed via GitHub Actions. Do NOT apply manually.
-- REQUIRES: manual approval via GitHub Environments protection rule.
-- =============================================================================

-- -------------------------
-- Schema: raw (ingesta - acceso muy restringido en prod)
-- -------------------------
GRANT USAGE ON SCHEMA raw TO GROUP data_engineers_prod;
GRANT SELECT ON ALL TABLES IN SCHEMA raw TO GROUP data_engineers_prod;
ALTER DEFAULT PRIVILEGES IN SCHEMA raw GRANT SELECT ON TABLES TO GROUP data_engineers_prod;

-- -------------------------
-- Schema: staging
-- -------------------------
GRANT USAGE ON SCHEMA staging TO GROUP data_engineers_prod;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA staging TO GROUP data_engineers_prod;
ALTER DEFAULT PRIVILEGES IN SCHEMA staging GRANT SELECT, INSERT, UPDATE ON TABLES TO GROUP data_engineers_prod;

-- -------------------------
-- Schema: reporting (analists solo lectura)
-- -------------------------
GRANT USAGE ON SCHEMA reporting TO GROUP analysts_prod;
GRANT SELECT ON ALL TABLES IN SCHEMA reporting TO GROUP analysts_prod;
ALTER DEFAULT PRIVILEGES IN SCHEMA reporting GRANT SELECT ON TABLES TO GROUP analysts_prod;

-- BI tool service account (Tableau / Looker / QuickSight)
GRANT USAGE ON SCHEMA reporting TO svc_bi_prod;
GRANT SELECT ON ALL TABLES IN SCHEMA reporting TO svc_bi_prod;
ALTER DEFAULT PRIVILEGES IN SCHEMA reporting GRANT SELECT ON TABLES TO svc_bi_prod;

-- -------------------------
-- Schema: audit (compliance / solo lectura)
-- -------------------------
GRANT USAGE ON SCHEMA audit TO GROUP compliance_prod;
GRANT SELECT ON ALL TABLES IN SCHEMA audit TO GROUP compliance_prod;
ALTER DEFAULT PRIVILEGES IN SCHEMA audit GRANT SELECT ON TABLES TO GROUP compliance_prod;

-- -------------------------
-- Service accounts - ETL
-- -------------------------
GRANT USAGE ON SCHEMA raw       TO svc_etl_prod;
GRANT USAGE ON SCHEMA staging   TO svc_etl_prod;
GRANT USAGE ON SCHEMA reporting TO svc_etl_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA raw       TO svc_etl_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA staging   TO svc_etl_prod;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA reporting TO svc_etl_prod;
ALTER DEFAULT PRIVILEGES IN SCHEMA raw       GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO svc_etl_prod;
ALTER DEFAULT PRIVILEGES IN SCHEMA staging   GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO svc_etl_prod;
ALTER DEFAULT PRIVILEGES IN SCHEMA reporting GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO svc_etl_prod;

-- -------------------------
-- Revocar accesos peligrosos (hardening prod)
-- -------------------------
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
