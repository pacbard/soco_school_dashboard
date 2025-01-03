create or replace table CA_Dashboard.ESSA_2024 as 
  select * from read_csv(
    'data/essa.csv',
    delim = ',',
    header = true
  )
  order by countyname, districtname, schoolname
  ;