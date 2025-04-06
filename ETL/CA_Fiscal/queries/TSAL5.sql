-- J-90 TSAL V
attach 'CA_Fiscal.duckdb';
use CA_Fiscal;

create or replace table TSAL5 as
select 
  '20' || substr(regexp_extract(filename, '([0-9]{4}).parquet$', 1), 1, 2) as Year,
  * exclude (filename),
from read_parquet('data/J-90/processed/parquet/tsal5/*.parquet', 
  union_by_name=True, filename=True)
order by COUNTY, DISTRICT, Year, TS5_BEN;