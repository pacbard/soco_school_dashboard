-- Local Education Agency
attach 'CA_Fiscal.duckdb';
use CA_Fiscal;

create or replace table LEA as
select distinct
  CASE
        WHEN filename LIKE '%SACS2003%' THEN regexp_extract(filename, '([0-9]{4})_[0-9]{2}.parquet$', 1)
        ELSE '20' || substr(regexp_extract(filename, '([0-9]{4}).parquet$', 1), 1, 2)
    END AS Year,
  * exclude (filename),
from read_parquet('data/sacs/processed/parquet/LEAs/*.parquet', 
  union_by_name=True,
  filename=True)
order by Ccode, Dcode, Year