-- General Ledger
attach 'CA_Fiscal.duckdb';
use CA_Fiscal;

SET preserve_insertion_order = false;

create or replace table Ledger as
select
  Ccode::int as CCcode,
  Dcode::int as Dcode,
  SchoolCode::int as Scode,
  Fiscalyear::int as FiscalYear,
  Period,
  Colcode,
  Account,
  Fund,
  Resource,
  Projectyear,
  Goal,
  Function,
  Object,
  cast(Value as decimal(15, 2)) as Value
from read_parquet('data/sacs/processed/parquet/UserGL/*.parquet', 
  union_by_name=True)
-- order by CCcode, Dcode, Scode, FiscalYear, Account, Fund, Resource, Projectyear, Goal, Function
;
