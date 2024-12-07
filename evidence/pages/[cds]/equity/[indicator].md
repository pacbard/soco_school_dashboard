
# Equity Dashboard for {params.indicator}

```sql cds_years
select distinct
    cast(cast(reportingyear as int) as varchar) as reportingyear
from CA_Dashboard.dash
where
    dash.cds = '${params.cds}'
    and
    dash.indicator = '${params.indicator}'
    and
    left(dash.reportingyear, 4)::int not in (2020, 2021)
    and
    left(dash.reportingyear, 4)::int > 2018
order by reportingyear desc
```

<ButtonGroup data={cds_years} name=year_filter value=reportingyear defaultValue="2024"/>


```sql cds_long
    select
        dash.reportingyear::int as reportingyear,
        dash.studentgroup,
        dash.studentgroup as groupname,
        grouplabel,
        labelgroup,
        dash.currstatus,
        dash.changelevel,
        case 
            when dash.statuslevel = 0 then null
            else dash.statuslevel
        end as level,
        dash.color,
        assistance.diffAssistance
    from CA_Dashboard.dash
        left join (select reportingyear, cds, indicator, studentgroup, differentiatedAssistance as diffAssistance from CA_Dashboard.assistance) as assistance on assistance.cds = '${params.cds}' and assistance.indicator = '${params.indicator}' and dash.reportingyear = assistance.reportingyear and dash.studentgroup = assistance.studentgroup
    where
        dash.cds = '${params.cds}'
        and
        dash.indicator = '${params.indicator}'
        and
        left(dash.reportingyear, 4)::int <> 2020
        and
        left(dash.reportingyear, 4)::int > 2018
    order by reportingyear
```

```sql cds_wide
pivot (select * from ${cds_long} where reportingyear = ${inputs.year_filter}) as dash
on studentgroup
using 
    max(groupname) as group,
    max(labelgroup) as labelgroup,
    max(grouplabel) as grouplabel,
    max(currstatus) as score,
    max(changelevel) as change, 
    max(level) as level,
    max(color) as color,
    max(diffAssistance) as diffAssistance
order by ReportingYear desc
```

# Student Ethnicity

{#each cds_wide as year}

<Grid cols=6>

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
            value: year.ALL_color,
            name: 'All Students' 
            }
        ]
        }
    ]
    }
}
/>

{#if year.AA_score }
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
            value: year.AA_color,
            name: 'Black / Af-Am' 
            }
        ]
        }
    ]
    }
}
/>
{/if}

{#if year.AI_score }
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
            value: year.AI_color,
            name: 'Am In/Alaska Nat' 
            }
        ]
        }
    ]
    }
}
/>
{/if}

{#if year.AS_score }
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
            value: year.AS_color,
            name: 'Asian' 
            }
        ]
        }
    ]
    }
}
/>
{/if}

{#if year.FI_score }
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
            value: year.FI_color,
            name: 'Filipino' 
            }
        ]
        }
    ]
    }
}
/>
{/if}

{#if year.HI_score }
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
            value: year.HI_color,
            name: 'Hispanic / Latino' 
            }
        ]
        }
    ]
    }
}
/>
{/if}

{#if year.MR_score }
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
            value: year.MR_color,
            name: 'Multiple Races' 
            }
        ]
        }
    ]
    }
}
/>
{/if}

{#if year.PI_score }
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
            value: year.PI_color,
            name: 'Pacific Islander' 
            }
        ]
        }
    ]
    }
}
/>
{/if}

{#if year.WH_score }
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
            value: year.WH_color,
            name: 'White' 
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

# Student Subgroups

{#each cds_wide as year}

<Grid cols=6>

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
            value: year.ALL_color,
            name: 'All Students' 
            }
        ]
        }
    ]
    }
}
/>

{#if year.EL_score }
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
            value: year.EL_color,
            name: 'English Learners' 
            }
        ]
        }
    ]
    }
}
/>
{/if}

{#if year.LTEL_score }
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
            value: year.LTEL_color,
            name: 'Long Term EL' 
            }
        ]
        }
    ]
    }
}
/>
{/if}

{#if year.RFP_score }
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
            value: year.RFP_color,
            name: 'Reclassified' 
            }
        ]
        }
    ]
    }
}
/>
{/if}

{#if year.EO_score }
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
            value: year.EO_color,
            name: 'English Only' 
            }
        ]
        }
    ]
    }
}
/>
{/if}

{#if year.FOS_score }
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
            value: year.FOS_color,
            name: 'Foster Youth' 
            }
        ]
        }
    ]
    }
}
/>
{/if}

{#if year.HOM_score }
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
            value: year.HOM_color,
            name: 'Homeless' 
            }
        ]
        }
    ]
    }
}
/>
{/if}

{#if year.SED_score }
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
            value: year.SED_color,
            name: 'Soc-Econ Dis' 
            }
        ]
        }
    ]
    }
}
/>
{/if}

{#if year.SWD_score }
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
            value: year.SWD_color,
            name: 'Stu w/ Disabilities' 
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

# Overview

```sql cds_groups
with pivoted as (
    pivot ${cds_long} as dash
    on reportingYear
    using 
        max(currstatus) as score,
        max(changelevel) as change,
        max(level) as level,
        max(color) as color,
        max(diffAssistance) as diffAssistance
)
select
    *,
    case
        when '${params.indicator}' = 'MATH' then '##0.0" points"'
        when '${params.indicator}' = 'ELA' then '##0.0" points"'
        when '${params.indicator}' = 'ELPI' then '##0.0"%"'
        when '${params.indicator}' = 'SUS' then '##0.0"%"'
        when '${params.indicator}' = 'CHRO' then '##0.0"%"'
        when '${params.indicator}' = 'GRAD' then '##0.0"%"'
        when '${params.indicator}' = 'CCI' then '##0.0"%"'
    end as groupFormat,
from pivoted
```

<DataTable data={cds_groups} rows=All groupBy=labelgroup groupType=section wrapTitles=true>
    <Column id=labelgroup title=Group/>
    <Column id=grouplabel title="Student Subgroup" />
    <Column id=2024_color title=Level colGroup=2024 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2024_score title=Score colGroup=2024 align=center fmtColumn=groupFormat/>
    <Column id=2024_diffAssistance title="Differentiated Assistance" colGroup=2024 align=center/>
    <Column id=2023_color title=Level colGroup=2023 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2023_score title=Score colGroup=2023 align=center fmtColumn=groupFormat/>
    <Column id=2022_color title=Level colGroup=2022 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2022_score title=Score colGroup=2022 align=center fmtColumn=groupFormat/>
    <Column id=2019_color title=Level colGroup=2019 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2019_score title=Score colGroup=2019 align=center fmtColumn=groupFormat/>
</DataTable>

<LinkButton url={'/'+params.cds}>
    Return 
</LinkButton>