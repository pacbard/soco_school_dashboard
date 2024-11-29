create or replace table labels as
select * from read_csv('labels.csv');

create or replace view differentiatedAssistance as
select
  left(reportingyear, 4)::int as reportingyear,
  cds,
  studentgroup,
  indicator,
  statuslevel,
  color,
  sum(
    case
      when color = 1 then 1
      when color > 1 then 0
    end 
  ) over (partition by reportingyear, cds, studentgroup) as N_ones
from 
      (
          select 'CCI' as indicator, CCI.* from CCI
          union
          select 'CHRON' as indicator, CHRON.* from CHRON
          union
          select 'ELA' as indicator, ELA.* from ELA
          union
          select 'MATH' as indicator, MATH.* from MATH
          union
          select 'ELPI' as indicator, ELPI.* from ELPI
          union
          select 'GRAD' as indicator, GRAD.* from GRAD
          union
          select 'SUS' as indicator, SUS.* from SUS
      ) as data
;

create or replace view dashboard as
select
    indicator,
    left(reportingyear, 4)::int as reportingyear,
    cds,
    rtype,
    trim(countyname) as countyname,
    trim(districtname) as districtname,
    case
      when trim(schoolname) = '' then null
      else trim(schoolname)
    end as schoolname,
    case
      when trim(charter_flag) = '' then null
      else trim(charter_flag)
    end as charter_flag,
    case
      when trim(coe_flag) = '' then null
      else trim(coe_flag)
    end as coe_flag,
    case
      when trim(dass_flag) = '' then null
      else trim(dass_flag)
    end as dass_flag,
    studentgroup,
    grouplabel,
    labelgroup,
    currstatus,
    statuslevel,
    changelevel,
    case
      when statuslevel = 0 then null
      when color = 0 then statuslevel
      else color
    end as color,
    box,
    case
        when min(case when accountabilitymet = 'Y' then color end) over (partition by cds, reportingyear) = 1 then 'Yes'
        when min(case when accountabilitymet = 'Y' then color end) over (partition by cds, reportingyear) > 1 then 'No'
        else null
    end as diffAssistance,
    accountabilitymet
from 
    (
        select 'CCI' as indicator, CCI.* from CCI
        union
        select 'CHRON' as indicator, CHRON.* from CHRON
        union
        select 'ELA' as indicator, ELA.* from ELA
        union
        select 'MATH' as indicator, MATH.* from MATH
        union
        select 'ELPI' as indicator, ELPI.* from ELPI
        union
        select 'GRAD' as indicator, GRAD.* from GRAD
        union
        select 'SUS' as indicator, SUS.* from SUS
    ) as data
    join CA_Dashboard.labels on labels.studentsubgroup = data.studentgroup
