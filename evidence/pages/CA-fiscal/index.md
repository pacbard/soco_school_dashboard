# Fiscal Indicators

This project displays fiscal data for California school districts. Users can select a group of comparable districts and view their financial indicators. The data is presented in an interactive dashboard, allowing for easy comparison and analysis.

```sql districts
select distinct
    LEA.ccode,
    LEA.dcode,
    LEA.dname,
    '/CA-fiscal/' || LEA.ccode || lea.dcode as district_link
from CA_Fiscal.LEA
where
    ccode = 49
    and
    year = 2023
order by dname
```

<DataTable data={districts} rows=all link=district_link>
    <Column id=dname title=District/>
</DataTable>

