-- General Ledger Totals
load https;

SET preserve_insertion_order = false;

copy (
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
) to 'data/UserGLTotals.parquet' (FORMAT parquet, COMPRESSION zstd, ROW_GROUP_SIZE 100_000)