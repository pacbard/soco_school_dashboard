# Mapping Performance

```sql indicators
select distinct
    indicator,
    case
        when indicator = 'MATH' then 'CAASPP Math'
        when indicator = 'ELA' then 'CAASPP ELA'
        when indicator = 'ELPI' then 'English Language Learner Progress'
        when indicator = 'SUS' then 'Suspension Rates'
        when indicator = 'CHRON' then 'Chronic Absenteism'
        when indicator = 'GRAD' then 'Graduation Rate'
        when indicator = 'CCI' then 'College and Career Readiness'
    end as indicatorName,
    case
        when indicator = 'MATH' then 1
        when indicator = 'ELA' then 2
        when indicator = 'ELPI' then 3
        when indicator = 'SUS' then 4
        when indicator = 'CHRON' then 5
        when indicator = 'GRAD' then 6
        when indicator = 'CCI' then 7
    end as indicatorOrder,
from CA_Dashboard.dash
order by indicatorOrder
```

<Dropdown data={indicators} name=indicator value=indicator label=indicatorName/>

```sql dash
select
    cds,
    schoolname,
    color,
    latitude::float as latitude,
    longitude::float as longitude
from CA_Dashboard.dash
where
    reportingyear = 2024
    and
    indicator = '${inputs.indicator.value}'
    and
    studentgroup = 'ALL'
    and
    color is not null
    and
    schoolname is not null
    and
    latitude is not null
    and
    longitude < -120
```

<PointMap
    data={dash}
    lat=latitude
    long=longitude
    value=color
    pointName=schoolname
    colorPalette={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']}
    min=1
    max=5
    height=600
/>

