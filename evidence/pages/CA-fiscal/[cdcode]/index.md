---
queries:
    - lea: fiscal/lea.sql
---

```sql district
select * from ${lea} as LEA where LEA.ccode || LEA.dcode = '${params.cdcode}'
```

# <Value data={district} column=district/>

<LinkButton url='/CA-fiscal/{params.cdcode}/comparison-group'>
Comparable Districts
</LinkButton>

# Average Daily Attendance

```sql chart_stats
select
    floor(min(ADA::int) / 1000) * 1000 as min_ADA,
    ceiling(max(ADA::int) / 1000) * 1000 as max_ADA
from ${district}
```

<LineChart
    data={district}
    x=year
    y=ADA
    yMin={chart_stats[0].min_ADA}
    yMax={chart_stats[0].max_ADA}
    title="Average Daily Attendance"
/>

# Budget

```sql fund
select distinct 
    Fund 
from CA_fiscal.ledger 
where ledger.CDScode = '${params.cdcode}' order by Fund
```

<ButtonGroup title=Fund data={fund} name=fund value=fund defaultValue='01' />

```sql ledger
select
    ledger.FiscalYear,
    case
        when ledger.Object in ('1100', '1200', '1900') then 'Certificated Teacher Salaries'
        when ledger.Object in ('1300') then 'Certificated Admin Salaries'
        when ledger.Object in ('2100', '2200', '2400', '2900') then 'Classified Staff Salaries'
        when ledger.Object in ('2300') then 'Classified Admin Salaries'
        when ledger.Object between '3000' and '3999' then 'Benefits'
        when ledger.Object between '4000' and '4999' then 'Books and Supplies'
        when ledger.Object between '5000' and '5999' then 'Services and Operating Costs'
        when ledger.Object between '6000' and '6999' then 'Capital Outlay and Equipment'
        when ledger.Object between '7000' and '7999' then 'Other Costs'
    end as Object,
    sum(ledger.Total) as Total,
    sum(ledger.Total / TotalExpenses) as Expense_Percentage,
    sum(ledger.Total / TotalRevenue) as Revenue_Percentage,
    left(ledger.Object, 1) as Sort
from CA_fiscal.ledger
    join (select FiscalYear, CDScode, sum(Total) as TotalExpenses from CA_fiscal.ledger where Object <= '7999' and Fund = ${inputs.fund} group by all) as expenses
        on expenses.FiscalYear = ledger.FiscalYear and expenses.CDScode = ledger.CDScode
    join (select FiscalYear, CDScode, sum(Total) as TotalRevenue from CA_fiscal.ledger where Object between '8000' and '8999' and Fund = ${inputs.fund} group by all) as Revenue
        on Revenue.FiscalYear = ledger.FiscalYear and Revenue.CDScode = ledger.CDScode
where
    ledger.CDScode = '${params.cdcode}'
    and Object <= '7999'
    and Fund = ${inputs.fund}
group by all
order by Sort, ledger.FiscalYear, Object
```

<DataTable data={ledger} groupBy=FiscalYear subtotals=true groupsOpen=false >
    <Column id=Object/>
    <Column id=Total fmt=usd0/>
    <Column id=Expense_Percentage fmt=pct2/> 
    <Column id=Revenue_Percentage fmt=pct2/> 
</DataTable>


<AreaChart
    title="Expense Percentage by Object"
    data={ledger}
    x=FiscalYear
    y=Total
    series=Object
    type=stacked100
    chartAreaHeight=500
/>
