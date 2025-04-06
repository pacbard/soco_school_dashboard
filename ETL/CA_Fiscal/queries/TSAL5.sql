-- J-90 TSAL V
load https;

copy (
  select 
    '20' || substr(regexp_extract(filename, '([0-9]{4}).parquet$', 1), 1, 2) as Year,
    * exclude (filename),
  from read_parquet('data/J-90/processed/parquet/tsal5/*.parquet', 
    union_by_name=True, filename=True)
  order by COUNTY, DISTRICT, Year, TS5_BEN
) to 'data/TSAL5.parquet'
  (FORMAT parquet, COMPRESSION zstd, ROW_GROUP_SIZE 100_000)