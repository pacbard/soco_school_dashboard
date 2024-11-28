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