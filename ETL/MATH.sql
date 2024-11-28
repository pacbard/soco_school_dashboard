-- MATH
create or replace table MATH_2024 as 
  select * from read_csv(
    '2024_prerelease/MATH_2024.txt',
    delim = '\t',
    header = true
  );

create or replace table MATH_2023 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/MATHdownload2023.txt',
    delim = '\t',
    header = true
  );

create or replace table MATH_2022 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/MATHdownload2022.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table MATH_2019 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/MATHdownload2019.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace table MATH_2018 as 
  select * from read_csv(
    'https://www3.cde.ca.gov/researchfiles/cadashboard/MATHdownload2018.txt',
    delim = '\t',
    header = true,
    ignore_errors=true
  );

create or replace view MATH as 
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, accountabilitymet from MATH_2024
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, null as accountabilitymet from MATH_2023
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, null as changelevel, statuslevel as color, null as box, null as accountabilitymet from MATH_2022
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, null as accountabilitymet from MATH_2019
  union
  select reportingyear, cds, rtype, countyname, districtname, schoolname, charter_flag, coe_flag, dass_flag, studentgroup, currstatus, statuslevel, changelevel, color, box, null as accountabilitymet from MATH_2018
  ;