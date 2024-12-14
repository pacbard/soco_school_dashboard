attach 'md:';
use CA_Dashboard;

create or replace table CA_Dashboard.ESSA_2024 as 
  select * from read_csv(
    'ETL/ESSA/essa.csv',
    delim = ',',
    header = true
  )
  order by countyname, districtname, schoolname
  ;