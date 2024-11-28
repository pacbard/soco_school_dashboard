---
title: California School Dashboard - Data
---

# School Accountability Dashboard Data

Each year, the California Department of Eduucation releases school accountability data through the California School Dashboard.

This website reports these data for Sonoma County Schools.

```sql sonoma
select
    cds, 
    districtname,
    '/' || cds as districtLink
from CA_Dashboard.dash
where
    rtype = 'D'
group by all
order by districtname
```

<DataTable data={sonoma} search=true rows=all link=districtLink>
    <Column id=districtname title="District Name"/>
    <Column id=districtLink contentType=link linkLabel="Details →" align=center/>
</DataTable>