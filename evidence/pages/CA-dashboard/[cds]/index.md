```sql cds_name
select distinct
    coalesce(schoolname, districtname) as name
from CA_Dashboard.dash
where cds = '${params.cds}'
```

# School Dashboard for {cds_name[0].name}

```sql cds_years
select distinct
    cast(cast(reportingyear as int) as varchar) as reportingyear
from CA_Dashboard.dash
where
    left(dash.reportingyear, 4)::int not in (2020, 2021)
    and
    left(dash.reportingyear, 4)::int > 2018
order by reportingyear desc
```

<ButtonGroup data={cds_years} name=year_filter value=reportingyear defaultValue="2024"/>

```sql cds_long
select distinct
    dash.indicator,
    dash.reportingyear::int as reportingyear,
    dash.cds,
    dash.rtype,
    dash.countyname,
    dash.schoolname,
    dash.charter_flag,
    dash.coe_flag,
    dash.dass_flag,
    dash.studentgroup,
    dash.grouplabel,
    dash.labelgroup,
    dash.currstatus,
    dash.statuslevel,
    dash.changelevel,
    dash.color,
    dash.box,
    assistance.diffAssistance,
    case
        when dash.indicator = 'MATH' then 'CAASPP Math'
        when dash.indicator = 'ELA' then 'CAASPP ELA'
        when dash.indicator = 'ELPI' then 'English Language Learner Progress'
        when dash.indicator = 'SUS' then 'Suspension Rates'
        when dash.indicator = 'CHRON' then 'Chronic Absenteism'
        when dash.indicator = 'GRAD' then 'Graduation Rate'
        when dash.indicator = 'CCI' then 'College and Career Readiness'
    end as indicatorName,
    case
        when dash.indicator = 'MATH' then 'CAASPP Math'
        when dash.indicator = 'ELA' then 'CAASPP ELA'
        when dash.indicator = 'ELPI' then 'EL Progress'
        when dash.indicator = 'SUS' then 'Suspension Rates'
        when dash.indicator = 'CHRON' then 'Chronic Absenteism'
        when dash.indicator = 'GRAD' then 'Graduation Rate'
        when dash.indicator = 'CCI' then 'College & Career'
    end as indicatorShortName,
    case
        when dash.indicator = 'MATH' then 1
        when dash.indicator = 'ELA' then 2
        when dash.indicator = 'ELPI' then 3
        when dash.indicator = 'SUS' then 4
        when dash.indicator = 'CHRON' then 5
        when dash.indicator = 'GRAD' then 6
        when dash.indicator = 'CCI' then 7
    end as indicatorOrder,
from CA_Dashboard.dash
    left join (select reportingyear, cds, indicator, studentgroup, max(differentiatedAssistance) as diffAssistance from CA_Dashboard.assistance group by all) as assistance on dash.cds = assistance.cds and dash.reportingyear = assistance.reportingyear and dash.indicator = assistance.indicator and dash.studentgroup = assistance.studentgroup
where 
    dash.cds = '${params.cds}'
    and
    left(dash.reportingyear, 4)::int <> 2020
    and
    left(dash.reportingyear, 4)::int > 2018
order by
    left(dash.reportingyear, 4) desc
```

```sql cds_results
select
    indicator,
    indicatorShortName as name,
    currstatus as status,
    statuslevel as level,
    changelevel as change,
    color,
    box,
    diffAssistance
from ${cds_long} 
where 
    studentgroup = 'ALL' 
    and reportingyear = ${inputs.year_filter}
    and currstatus is not null
order by indicatorOrder
```

<Grid cols=6>

{#each cds_results as indicator}

<ECharts height="130px" config={
    {
    series: [
        {
        type: 'gauge',
        startAngle: 180,
        endAngle: 0,
        center: ['50%', '75%'],
        radius: '90%',
        min: 0.5,
        max: 5.5,
        splitNumber: -1,
        title: {
            offsetCenter: [0, '30%'],
            fontSize: 14
        },
        axisLine: {
            lineStyle: {
            width: 6,
            color: [
                [0.2, '#CE2F2C'],
                [0.4, '#EE7C37'],
                [0.60, '#F5BC42'],
                [0.80, '#41934C'],
                [1, '#4B6AC9']
            ]
            }
        },
        pointer: {
            icon: 'path://M12.8,0.7l12,40.1H0.7L12.8,0.7z',
            length: '12%',
            width: 20,
            offsetCenter: [0, '-60%'],
            itemStyle: {
            color: 'auto'
            }
        },
        detail: {
            fontSize: 30,
            offsetCenter: [0, '-15%'],
            valueAnimation: true,
            formatter: function (value) {
            return value + '';
            },
            color: 'inherit'
        },
        data: [
            {
            value: indicator.color,
            name: indicator.name 
            }
        ]
        }
    ]
    }
}
/>

{/each}

</Grid>

# Equity Overview

```sql equity
pivot (select 
    indicator, studentgroup, labelgroup, grouplabel, currstatus, statuslevel, color, changelevel, box, max(diffAssistance) as diffAssistance 
    from ${cds_long} 
    where 
        color is not null 
        and 
        reportingyear = ${inputs.year_filter}
    group by all
    )
on indicator
using
    max(currstatus) as score,
    max(statuslevel) as level,
    max(color) as color,
    max(changelevel) as changelevel,
    max(box) as box
order by grouplabel
```

<DataTable data={equity} link=indicatorLink wrapTitles=true rows=all groupBy=labelgroup subtotals=false>
    <Column id=grouplabel title="Student Subgroup"/>
    <Column id=diffAssistance title="Differentiated Assistance" align=center fmtColumn=indicatorFormat/>

{#if equity[0].ELA_color}
    <Column id=ELA_color title="SBAC ELA" align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
{/if}
{#if equity[0].MATH_color}
    <Column id=MATH_color title="SBAC MATH" align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
{/if}
{#if equity[0].ELPI_color}
    <Column id=ELPI_color title="EL Progress" align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
{/if}
{#if equity[0].GRAD_color}
    <Column id=GRAD_color title="Graduation Rate" align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
{/if}
{#if equity[0].CCI_color}
    <Column id=CCI_color title="College & Career Readiness" align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
{/if}
{#if equity[0].CHRON_color}
    <Column id=CHRON_color title="Chronic Absenteism" align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
{/if}
{#if equity[0].SUS_color}
    <Column id=SUS_color title="Suspension Rates" align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
{/if}
</DataTable>

{#if params.cds.substr(params.cds.length - 7) == '0000000' }

# Historical Overview

```sql cds_year
with 
pivoted as (
    pivot (select * exclude (diffAssistance) from ${cds_long} where studentgroup = 'ALL')
    on ReportingYear
    using 
        max(currstatus) as score,
        max(statuslevel) as level,
        max(color) as color,
        max(changelevel) as changelevel,
        max(box) as box
),
diffAssistance as (
    select 
        indicator, 
        max(diffAssistance) as "2024_diffAssistance" 
    from ${cds_long} 
    where reportingyear = 2024 
    group by all
)
select
    *,
    case
        when pivoted.indicator = 'MATH' then 'CAASPP Math'
        when pivoted.indicator = 'ELA' then 'CAASPP ELA'
        when pivoted.indicator = 'ELPI' then 'English Language Learner Progress'
        when pivoted.indicator = 'SUS' then 'Suspension Rates'
        when pivoted.indicator = 'CHRON' then 'Chronic Absenteism'
        when pivoted.indicator = 'GRAD' then 'Graduation Rate'
        when pivoted.indicator = 'CCI' then 'College and Career Readiness'
    end as indicatorName,
    case
        when pivoted.indicator = 'MATH' then 1
        when pivoted.indicator = 'ELA' then 2
        when pivoted.indicator = 'ELPI' then 3
        when pivoted.indicator = 'SUS' then 4
        when pivoted.indicator = 'CHRON' then 5
        when pivoted.indicator = 'GRAD' then 6
        when pivoted.indicator = 'CCI' then 7
    end as indicatorOrder,
    case
        when pivoted.indicator = 'MATH' then '##0.0" points"'
        when pivoted.indicator = 'ELA' then '##0.0" points"'
        when pivoted.indicator = 'ELPI' then '##0.0"%"'
        when pivoted.indicator = 'SUS' then '##0.0"%"'
        when pivoted.indicator = 'CHRON' then '##0.0"%"'
        when pivoted.indicator = 'GRAD' then '##0.0"%"'
        when pivoted.indicator = 'CCI' then '##0.0"%"'
    end as indicatorFormat,
    '/CA-dashboard/${params.cds}/equity/' || pivoted.indicator as indicatorLink 
from pivoted
    join diffAssistance on diffAssistance.indicator = pivoted.indicator
order by indicatorOrder desc
```

<DataTable data={cds_year} sort=indicatorOrder link=indicatorLink wrapTitles=true>
    <Column id=indicatorName title="Indicator" wrapTitles=true/>
    <Column id=2024_diffAssistance title="Differentiated Assistance" colGroup=2024 align=center fmtColumn=indicatorFormat/>
    <Column id=2024_color title=Level colGroup=2024 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2024_score title=Score colGroup=2024 align=center fmtColumn=indicatorFormat/>
    <Column id=2023_color title=Level colGroup=2023 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2023_score title=Score colGroup=2023 align=center fmtColumn=indicatorFormat/>
    <Column id=2022_color title=Level colGroup=2022 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2022_score title=Score colGroup=2022 align=center fmtColumn=indicatorFormat/>
    <Column id=2019_color title=Level colGroup=2019 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2019_score title=Score colGroup=2019 align=center fmtColumn=indicatorFormat/>
</DataTable>

# School-Level Results

```sql schools
select distinct
    dash.cds,
    dash.schoolname,
    max(assistance.diffAssistance) as diffAssistance,
    '/' || dash.cds as schoolLink
from CA_Dashboard.dash
    left join (select reportingyear, cds, max(differentiatedAssistance) as diffAssistance from CA_Dashboard.assistance group by all) as assistance on dash.cds = assistance.cds and dash.reportingyear = assistance.reportingyear
where
    left(dash.cds, 7) = left(${params.cds}, 7)
    and
    dash.reportingyear = 2024
    and
    dash.rtype = 'S'
group by all
order by schoolname
```

<DataTable data={schools} search=true rows=all link=schoolLink>
    <Column id=schoolname title="School Name"/>
    <Column id=diffAssistance title="Differentiated Assistance"/>
    <Column id=schoolLink title="Equity Dashboard" contentType=link linkLabel="Details →" align=center/>
</DataTable>

<LinkButton url='/'>
    Return to home page
</LinkButton>

{:else}

<LinkButton url={'/'+params.cds.substr(0, 7) + '0000000'}>
    Return to district page
</LinkButton>

{/if}
