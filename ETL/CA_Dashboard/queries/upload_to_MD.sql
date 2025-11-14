ATTACH 'CA_Dashboard.duckdb' AS dash_local;
ATTACH 'md:';
DROP DATABASE IF EXISTS CA_Dashboard CASCADE;
CREATE OR REPLACE DATABASE CA_Dashboard FROM dash_local;