ATTACH 'CA_Fiscal.duckdb' AS fiscal_local;
ATTACH 'md:';
DROP DATABASE IF EXISTS CA_Fiscal CASCADE;
CREATE OR REPLACE DATABASE CA_Fiscal FROM fiscal_local;