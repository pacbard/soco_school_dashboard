-- GRAD
create or replace table GRAD_2024 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/GRADdownload2024.txt',
    delim = '\t',
    header = true
  );

create or replace table GRAD_2023 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/GRADdownload2023.txt',
    delim = '\t',
    header = true
  );

create or replace table GRAD_2022 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/GRADdownload2022.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table GRAD_2021 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/GRADdownload2021.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table GRAD_2020 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/GRADdownload2020.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table GRAD_2019 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/GRADdownload2019.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table GRAD_2018 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/GRADdownload2018.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table GRAD_2017 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/GRADdownload2017f.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace view GRAD as 
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, accountabilitymet from GRAD_2024
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, null as accountabilitymet from GRAD_2023
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, null as changelevel, statuslevel as color, null as box, null as accountabilitymet from GRAD_2022
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, null as statuslevel, null as changelevel, null as color, null as box, null as accountabilitymet from GRAD_2021
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, null as statuslevel, null as changelevel, null as color, null as box, null as accountabilitymet from GRAD_2020
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, null as accountabilitymet from GRAD_2019
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, null as accountabilitymet from GRAD_2018
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, null as dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, null as accountabilitymet from GRAD_2017
  ;