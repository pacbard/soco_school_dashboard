select
  dashboard.*,
  latitude::float as latitude,
  longitude::float as longitude
from dashboard
  left join schools on rtype = 'S' and right(schools.cds, 7) = right(dashboard.cds, 7)
where
    dashboard.countyname = 'Sonoma'
order by
  dashboard.cds, dashboard.reportingyear, dashboard.indicator, dashboard.studentgroup