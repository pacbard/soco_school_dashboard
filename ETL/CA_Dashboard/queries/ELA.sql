-- ELA
create or replace table ELA_2025 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/ELAdownload2025.txt',
    delim = '\t',
    header = true
  );

create or replace table ELA_2024 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/ELAdownload2024.txt',
    delim = '\t',
    header = true
  );

create or replace table ELA_2023 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/ELAdownload2023.txt',
    delim = '\t',
    header = true
  );

create or replace table ELA_2022 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/ELAdownload2022.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table ELA_2019 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/ELAdownload2019.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table ELA_2018 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/ELAdownload2018.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace view ELA as 
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, accountabilitymet from ELA_2025
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, accountabilitymet from ELA_2024
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, null as accountabilitymet from ELA_2023
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, null as changelevel, statuslevel as color, null as box, null as accountabilitymet from ELA_2022
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, null as accountabilitymet from ELA_2019
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, null as accountabilitymet from ELA_2018
  ;