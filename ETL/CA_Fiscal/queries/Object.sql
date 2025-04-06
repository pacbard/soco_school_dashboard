-- Object
load https;

copy (
  select
    case
      when filename LIKE '%SACS2003%' THEN regexp_extract(filename, '([0-9]{4})_[0-9]{2}.parquet$', 1)
      else '20' || substr(regexp_extract(filename, '([0-9]{4}).*parquet$', 1), 1, 2)
    end as FiscalYear,
    code as Object,
    title as Description,
    filename,
  from read_parquet('data/sacs/processed/parquet/Object/*.parquet', 
                    union_by_name=True, filename=True)
  order by FiscalYear, Object
) to 'data/Object.parquet'
  (FORMAT parquet, COMPRESSION zstd, ROW_GROUP_SIZE 100_000)