-- J-90 TSAL I
attach 'CA_Fiscal.duckdb';
use CA_Fiscal;

create or replace table TSAL1 as
select 
  '20' || substr(regexp_extract(filename, '([0-9]{4}).parquet$', 1), 1, 2) as Year,
  * exclude (filename),
from read_parquet('data/J-90/processed/parquet/tsal1/*.parquet', 
  union_by_name=True, filename=True)
order by COUNTY, DISTRICT, Year;