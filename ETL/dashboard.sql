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
  case
    when 
      sum(
        case
          when color = 1 then 1
          when color > 1 then 0
        end 
      ) over (partition by reportingyear, cds, studentgroup) >= 2 then 'Yes'
    else 'No'
  end as differentiatedAssistance
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
