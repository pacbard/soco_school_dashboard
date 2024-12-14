attach 'md:';
use CA_Dashboard;

create or replace table ESSA_2024 as 
  select * from read_csv(
    'ETL/ESSA/essa.csv',
    delim = ',',
    header = true
  )
  order by countyname, districtname, schoolname
  ;