-- ELPI
create or replace table ELPI_2024 as 
  select * from read_csv(
    '2024_prerelease/ELPI_2024.txt',
    delim = '\t',
    header = true
  );

create or replace table ELPI_2023 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/elpidownload2023.txt',
    delim = '\t',
    header = true
  );

create or replace table ELPI_2022 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/elpidownload2022.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table ELPI_2019 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/elpidownload2019.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table ELPI_2018 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/elpidownload2018.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table ELPI_2017 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/elpidownload2017f.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace view ELPI as 
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, case when studentgroup = 'EL' then 'ALL' else studentgroup end as studentgroup, currstatus, statuslevel, changelevel, color, box from ELPI_2024
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, 'ALL' as studentgroup, currstatus, statuslevel, changelevel, color, box from ELPI_2023
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, 'ALL' as studentgroup, currstatus, statuslevel, null as changelevel, statuslevel as color, null as box from ELPI_2022
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, 'ALL' as studentgroup, currstatus, statuslevel, null as changelevel, statuslevel as color, null as box from ELPI_2019
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, 'ALL' as studentgroup, null as currstatus, null as statuslevel, null as changelevel, statuslevel as color, null as box from ELPI_2018
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, null as dass_flag, 'ALL' as studentgroup, currstatus, statuslevel, null as changelevel, statuslevel as color, null as box from ELPI_2017
  ;