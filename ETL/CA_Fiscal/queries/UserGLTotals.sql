-- General Ledger Totals
attach 'CA_Fiscal.duckdb';
use CA_Fiscal;

SET preserve_insertion_order = false;

create or replace table LedgerTotals as
select
  Ccode::int as CCcode,
  Dcode::int as Dcode,
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
from read_parquet('data/sacs/processed/parquet/UserGL_Totals/*.parquet', 
  union_by_name=True)
-- order by CCcode, Dcode, FiscalYear, Account, Fund, Resource, Projectyear, Goal, Function
;