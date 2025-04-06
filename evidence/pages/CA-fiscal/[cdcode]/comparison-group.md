---
queries:
    - lea: fiscal/lea.sql
    - district_data: fiscal/district_data.sql
    - comparison_data: fiscal/comparison_data.sql
    - comparison: fiscal/comparison.sql
---

# Comparison Group

<Details title='Instructions'>

On this page, you can explore what districts compare to ....

By default, we use the average for the past eight years. You can adjust the years used in the comparison in the school year drowpdown.

Finally, you can use the slider to adjust the distance from the district value by percentage. The default value is 2%.

</Details>

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

```sql comparable
select
    Match,
    dname,
    dtype,
    comp.ADA
from ${comparison} as comp
    join CA_Fiscal.LEA on comp.CDcode = LEA.Ccode || LEA.Dcode and LEA.year = 2023
order by Match, dname
```

<DataTable data={comparable} rows=all groupBy=Match groupType=section>
    <Column id=Match/>
    <Column id=dname title=District/>
    <Column id=dtype title=Type/>
    <Column id=ADA/>
</DataTable>

