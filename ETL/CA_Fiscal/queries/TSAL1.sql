-- J-90 TSAL I
load https;

copy (
  select 
    '20' || substr(regexp_extract(filename, '([0-9]{4}).parquet$', 1), 1, 2) as Year,
    * exclude (filename),
  from read_parquet('data/J-90/processed/parquet/tsal1/*.parquet', 
    union_by_name=True, filename=True)
  order by COUNTY, DISTRICT, Year
) to 'data/TSAL1.parquet'
  (FORMAT parquet, COMPRESSION zstd, ROW_GROUP_SIZE 100_000)