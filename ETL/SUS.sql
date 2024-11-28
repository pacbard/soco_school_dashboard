-- SUS
create or replace table SUS_2024 as 
  select * from read_csv(
    '2024_prerelease/SUSPENSION_2024.txt',
    delim = '\t',
    header = true
  );

create or replace table SUS_2023 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/SUSPdownload2023.txt',
    delim = '\t',
    header = true
  );

create or replace table SUS_2022 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/SUSPdownload2022.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table SUS_2019 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/SUSPdownload2019.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table SUS_2018 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/SUSPdownload2018.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table SUS_2017 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/SUSPdownload2017f.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace view SUS as 
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, accountabilitymet from SUS_2024
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, null as accountabilitymet from SUS_2023
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, null as changelevel, statuslevel as color, null as box, null as accountabilitymet from SUS_2022
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, null as accountabilitymet from SUS_2019
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, null as accountabilitymet from SUS_2018
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, null as dass_flag, studentgroup, currstatus, statuslevel, null as changelevel, statuslevel as color, null as box, null as accountabilitymet from SUS_2017
  ;