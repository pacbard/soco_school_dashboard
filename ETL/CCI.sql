-- CCI
create or replace table CCI_2024 as 
  select * from read_csv(
    '2024_prerelease/CCI_2024.txt',
    delim = '\t',
    header = true
  );

create or replace table CCI_2023 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/ccidownload2023.txt',
    delim = '\t',
    header = true
  );

create or replace table CCI_2022 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/ccidownload2022.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table CCI_2019 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/ccidownload2019.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table CCI_2018 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/ccidownload2018.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table CCI_2017 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/ccidownload2017f.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace view CCI as 
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box from CCI_2024
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, null as changelevel, statuslevel as color, null as box from CCI_2023
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, null as currstatus, null as statuslevel, null as changelevel, null as color, null as box from CCI_2022
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box from CCI_2019
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box from CCI_2018
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, null as dass_flag, studentgroup, currstatus, statuslevel, null as changelevel, statuslevel as color, null as box from CCI_2017
  ;