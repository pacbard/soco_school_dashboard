-- Local Education Agency
load https;

copy (
  select distinct
    filename,
    CASE
          WHEN filename LIKE '%SACS2003%' THEN regexp_extract(filename, '([0-9]{4})_[0-9]{2}.parquet$', 1)
          ELSE '20' || substr(regexp_extract(filename, '([0-9]{4}).parquet$', 1), 1, 2)
      END AS Year,
    * exclude (filename),
  from read_parquet('data/sacs/processed/parquet/LEAs/*.parquet', 
    union_by_name=True,
    filename=True)
  order by Ccode, Dcode, Year
) to 'data/LEAs.parquet'
  (FORMAT parquet, COMPRESSION zstd, ROW_GROUP_SIZE 100_000)