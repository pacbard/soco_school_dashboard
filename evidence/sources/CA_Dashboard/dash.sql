with data as (
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
)
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
    currstatus,
    statuslevel,
    changelevel,
    case
      when statuslevel = 0 then null
      when color = 0 then statuslevel
      else color
    end as color,
    box,
    accountabilitymet
from data
where
    countyname = 'Sonoma'
order by
  cds, reportingyear, indicator, studentgroup