---
queries:
    - lea: fiscal/lea.sql
    - district_data: fiscal/district_data.sql
    - comparison_data: fiscal/comparison_data.sql
    - comparison: fiscal/comparison.sql
---

# ADA Comparison

<Card title="Comparison Group Settings" >

```sql years
select distinct Year from ${lea}
```

```sql percentage
FROM generate_series(1, 50)
select
    generate_series / 100 as percentage,
    0.02 as defaultValue
```

<Dropdown data={years} name=years value=Year multiple=true defaultValue={[2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023]}/>

<Dropdown name=comparison multiple=true selectAllByDefault=true >
    <DropdownOption value="Sonoma County"/>
    <DropdownOption value="ADA" />
</Dropdown>

<Slider data={percentage} range=percentage step=0.01 defaultValue=defaultValue title="Distance from district" name=distance fmt=pct0/>

</Card>

```sql ada
select 'District' as Match, CDcode from ${district_data} as district
union by name
select Match, CDcode from ${comparison}
```

```sql ADA
select
    case
        when Match = 'District' then district
        else Match
    end as Match,
    district,
    ("2023" - "2017") / "2017" as delta,
    "2017" as "2017-18",
    "2018" as "2018-19",
    "2019" as "2019-20",
    "2020" as "2020-21",
    "2021" as "2021-22",
    "2022" as "2022-23",
    "2023" as "2023-24",
    case
        when Match = 'District' then 1
        when Match = 'Sonoma County' then 2
        when Match = 'ADA' then 3
        else 8
    end as sortOrder
    
from (
    pivot (select * from ${lea} as lea join ${ada} as ada on ada.CDcode = lea.Ccode || lea.Dcode)
    on Year
    using max(ADA)
)
order by sortOrder, district
```

<DataTable data={ADA} groupBy=Match subtotals=true groupsOpen=false wrapTitles=true sort=sortOrder>
    <Column id=district title=District/>
    <Column id=delta title="2017 to 2023 Change" totalAgg=weightedMean weightCol=2017-18 fmt=pct2 contentType=delta />
    <Column id=2017-18 totalAgg=mean fmt=num0/>
    <Column id=2018-19 totalAgg=mean fmt=num0/>
    <Column id=2019-20 totalAgg=mean fmt=num0/>
    <Column id=2020-21 totalAgg=mean fmt=num0/>
    <Column id=2021-22 totalAgg=mean fmt=num0/>
    <Column id=2022-23 totalAgg=mean fmt=num0/>
    <Column id=2023-24 totalAgg=mean fmt=num0/>
</DataTable>

