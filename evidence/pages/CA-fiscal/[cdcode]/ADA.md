---
queries:
    - comparison: comparative-budget-salary/comparison.sql
    - srcs: comparative-budget-salary/srcs.sql
    - district_data: comparative-budget-salary/district_data.sql
---

# ADA Comparison

<Card title="Comparison Group Settings" >

```sql years
select distinct AcademicYear from warehouse.DQ_enrollment
```

```sql percentage
FROM generate_series(1, 20)
select
    generate_series / 100 as percentage,
    0.02 as defaultValue
```

<ButtonGroup name=srcs>
    <ButtonGroupItem valueLabel="Combine SRCS" value="combine" default=true/>
    <ButtonGroupItem valueLabel="Separate SRCS" value="separate" />
</ButtonGroup>

<Dropdown data={years} name=years value=AcademicYear multiple=true selectAllByDefault=true/>

<Dropdown name=comparison multiple=true selectAllByDefault=true >
    <DropdownOption value="Neighbors"/>
    <DropdownOption value="Sonoma County"/>
    <DropdownOption value="Enrollment" />
    <DropdownOption value="English Learners" />
    <DropdownOption value="Students with Disabilities" />
    <DropdownOption value="Socioeconomically Disadvantaged" /> 
</Dropdown>

<Slider data={percentage} range=percentage step=0.01 defaultValue=defaultValue title="Distance from SRCS" name=distance fmt=pct0/>

</Card>

```sql ADA
select
    Match,
    DistrictName,
    ("2023" - "2016") / "2016" as delta,
    "2016" as "2016-17",
    "2017" as "2017-18",
    "2018" as "2018-19",
    "2019" as "2019-20",
    "2020" as "2020-21",
    "2021" as "2021-22",
    "2022" as "2022-23",
    "2023" as "2023-24",
    case
        when Match = 'Santa Rosa City Schools' then 1
        when Match = 'Neighbors' then 2
        when Match = 'Sonoma County' then 3
        when Match = 'Enrollment' then 4
        when Match = 'English Learners' then 5
        when Match = 'Students with Disabilities' then 6
        when Match = 'Socioeconomically Disadvantaged' then 7
        else 8
    end as sortOrder
    
from (
    pivot (
        select 'Santa Rosa City Schools' as Match, Year as AcademicYear, 'Santa Rosa City Schools' as DistrictName, TS1_ADA::float as ADA from warehouse.DQ_salary where TS1_DNAME ilike 'Santa Rosa%'
        union by name
        select Match, Year as AcademicYear, comp.DistrictName as DistrictName, TS1_ADA::float as ADA from warehouse.DQ_salary as data join ${comparison} as comp on comp.CDSCode = data.CDSCode
    )
    on AcademicYear
    using max(ADA)
)
order by sortOrder
```

<DataTable data={ADA} groupBy=Match subtotals=true groupsOpen=false wrapTitles=true sort=sortOrder>
    <Column id=DistrictName title=District/>
    <Column id=delta title="2016 to 2023 Change" totalAgg=weightedMean weightCol=2016-17 fmt=pct2 contentType=delta />
    <Column id=2016-17 totalAgg=mean fmt=num0/>
    <Column id=2017-18 totalAgg=mean fmt=num0/>
    <Column id=2018-19 totalAgg=mean fmt=num0/>
    <Column id=2019-20 totalAgg=mean fmt=num0/>
    <Column id=2020-21 totalAgg=mean fmt=num0/>
    <Column id=2021-22 totalAgg=mean fmt=num0/>
    <Column id=2022-23 totalAgg=mean fmt=num0/>
    <Column id=2023-24 totalAgg=mean fmt=num0/>
</DataTable>

