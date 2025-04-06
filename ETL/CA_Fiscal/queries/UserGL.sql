-- General Ledger
load https;

copy (
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
  order by CCcode, Dcode, Scode, FiscalYear, Account, Fund, Resource, Projectyear, Goal, Function
) to 'data/UserGL.parquet' (FORMAT parquet, COMPRESSION zstd, ROW_GROUP_SIZE 100_000)