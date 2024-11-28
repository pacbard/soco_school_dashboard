
# Sonoma County School Accountability Dashboard Data

Each year, the California Department of Eduucation releases school accountability data through the California School Dashboard.

This website reports these data for Sonoma County Schools.

<Alert status=warning>
The California Department of Education (CDE) has yet to release the list of schools that qualify for differentiated assistance.

Currently, we identify all districts and schools where at least one subgroup scored Very Low on one or more indicators as eligible for differentiated assistance.

Please note that this indicator does not represent an official designation by the CDE. We will update the dataset once the CDE releases the list of eligible districts and schools.
</Alert>



```sql sonoma
select
    cds, 
    districtname,
    max(case when accountabilitymet = 'Y' then diffAssistance end) as diffAssistance,
    '/' || cds as districtLink
from CA_Dashboard.dash
where
    rtype = 'D'
    and
    reportingyear = 2024
group by all
order by districtname
```

<DataTable data={sonoma} search=true rows=all link=districtLink>
    <Column id=districtname title="District Name"/>
    <Column id=diffAssistance title="Differentiated Assistance"/>
    <Column id=districtLink contentType=link linkLabel="Details →" align=center/>
</DataTable>
