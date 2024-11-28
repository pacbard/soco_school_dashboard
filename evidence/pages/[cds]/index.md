```sql cds_name
select distinct
    coalesce(schoolname, districtname) as name
from CA_Dashboard.dash
where cds = '${params.cds}'
```

# School Dashboard for {cds_name[0].name}


```sql cds_long
select distinct
    indicator,
    reportingyear::int as reportingyear,
    cds,
    rtype,
    countyname,
    schoolname,
    charter_flag,
    coe_flag,
    dass_flag,
    studentgroup,
    currstatus,
    statuslevel,
    changelevel,
    color,
    box,
    diffAssistance
from CA_Dashboard.dash
where 
    cds = '${params.cds}'
    and
    left(reportingyear, 4)::int <> 2020
    and
    left(reportingyear, 4)::int > 2018
order by
    left(reportingyear, 4) desc
```

```sql cds_wide
pivot (select * from ${cds_long} where studentgroup = 'ALL' and reportingyear = 2024)
on indicator
using
    max(currstatus) as status,
    max(statuslevel) as level,
    max(changelevel) as change,
    max(color) as color,
    max(box) as box,
    max(diffAssistance) as diffAssistance
```

{#each cds_wide as year}

<Grid cols=6>

{#if year.MATH_color}

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
            value: year.MATH_color,
            name: 'CAASPP Math' 
            }
        ]
        }
    ]
    }
}
/>

{/if}

{#if year.ELA_color}
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
            value: year.ELA_color,
            name: 'CAASPP ELA'
            }
        ]
        }
    ]
    }
}
/>

{/if}

{#if year.ELPI_color}

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
            value: year.ELPI_color,
            name: 'EL Progress' 
            }
        ]
        }
    ]
    }
}
/>

{/if}

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
            value: year.SUS_color,
            name: 'Suspensions' 
            }
        ]
        }
    ]
    }
}
/>

{#if year.Chron_color}

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
            value: year.Chron_color,
            name: 'Absenteism' 
            }
        ]
        }
    ]
    }
}
/>

{/if}

{#if year.GRAD_color }

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
            value: year.GRAD_color,
            name: 'Graduation' 
            }
        ]
        }
    ]
    }
}
/>

{/if}

{#if year.CCI_level > 0}

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
            value: year.CCI_color,
            name: 'College & Career' 
            }
        ]
        }
    ]
    }
}
/>
{/if}

</Grid>

{/each}


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
    '/${params.cds}/equity/' || pivoted.indicator as indicatorLink 
from pivoted
    join diffAssistance on diffAssistance.indicator = pivoted.indicator
order by indicatorOrder desc
```

<DataTable data={cds_year} sort=indicatorOrder link=indicatorLink wrapTitles=true>
    <Column id=indicatorName title="Indicator" wrapTitles=true/>
    <Column id=2024_color title=Level colGroup=2024 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2024_score title=Score colGroup=2024 align=center fmtColumn=indicatorFormat/>
    <Column id=2024_diffAssistance title="Differential Assistance" colGroup=2024 align=center fmtColumn=indicatorFormat/>
    <Column id=2023_color title=Level colGroup=2023 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2023_score title=Score colGroup=2023 align=center fmtColumn=indicatorFormat/>
    <Column id=2022_color title=Level colGroup=2022 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2022_score title=Score colGroup=2022 align=center fmtColumn=indicatorFormat/>
    <Column id=2019_color title=Level colGroup=2019 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2019_score title=Score colGroup=2019 align=center fmtColumn=indicatorFormat/>
</DataTable>

{#if params.cds.substr(params.cds.length - 7) == '0000000' }

# School-Level Results

```sql schools
select distinct
    cds,
    schoolname,
    max(case when accountabilitymet = 'Y' then diffAssistance end) as diffAssistance,
    '/' || cds as schoolLink
from CA_Dashboard.dash
where
    left(cds, 7) = left(${params.cds}, 7)
    and
    reportingyear = 2024
    and
    rtype = 'S'
group by all
order by schoolname
```

<DataTable data={schools} search=true rows=all link=schoolLink>
    <Column id=schoolname title="School Name"/>
    <Column id=diffAssistance title="Differentiated Assistance"/>
    <Column id=schoolLink contentType=link linkLabel="Details →" align=center/>
</DataTable>

<LinkButton url='/'>
    Return to home page
</LinkButton>

{:else}

<LinkButton url={'/'+params.cds.substr(0, 7) + '0000000'}>
    Return to district page
</LinkButton>

{/if}
