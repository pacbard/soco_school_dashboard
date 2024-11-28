-- CHRON
create or replace table CHRON_2024 as 
  select * from read_csv(
    '2024_prerelease/CHRONIC_2024.txt',
    delim = '\t',
    header = true
  );

create or replace table CHRON_2023 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/chronicdownload2023.txt',
    delim = '\t',
    header = true
  );

create or replace table CHRON_2022 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/chronicdownload2022.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table CHRON_2019 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/chronicdownload2019.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table CHRON_2018 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/chronicdownload2018.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace view CHRON as 
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box from CHRON_2024
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box from CHRON_2023
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, null as changelevel, statuslevel as color, null as box from CHRON_2022
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box from CHRON_2019
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box from CHRON_2018
  ;