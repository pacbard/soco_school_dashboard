-- Goal
attach 'CA_Fiscal.duckdb';
use CA_Fiscal;

create or replace table Goal as
select
  case
    when filename LIKE '%SACS2003%' THEN regexp_extract(filename, '([0-9]{4})_[0-9]{2}.parquet$', 1)
    else '20' || substr(regexp_extract(filename, '([0-9]{4}).*parquet$', 1), 1, 2)
  end as FiscalYear,
  code as Goal,
  title as Description,
from read_parquet('data/sacs/processed/parquet/Goal/*.parquet', 
                  union_by_name=True, filename=True)
order by FiscalYear, Goal;