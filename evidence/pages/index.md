---
title: California School Dashboard - Data
---

```sql srcs_long
select distinct
    indicator,
    left(reportingyear, 4)::int as reportingyear,
    cds,
    rtype,
    countyname,
    case
        when trim(schoolname) = '' then null
        else schoolname
    end as schoolname,
    case
        when trim(charter_flag) = '' then null
        else charter_flag
    end as charter_flag,
    case
        when trim(coe_flag) = '' then null
        else coe_flag
    end as coe_flag,
    case
        when trim(dass_flag) = '' then null
        else dass_flag
    end as dass_flag,
    studentgroup,
    currstatus,
    statuslevel,
    changelevel,
    color,
    box
from CA_Dashboard.dash
where 
    cds = '49402530000000'
    and
    studentgroup = 'ALL'
    and
    left(reportingyear, 4)::int <> 2020
    and
    left(reportingyear, 4)::int > 2018
order by
    left(reportingyear, 4) desc
```

```sql srcs_wide
pivot ${srcs_long}
on indicator
using
    max(currstatus) as status,
    max(statuslevel) as level,
    max(changelevel) as change,
    max(color) as color,
    max(box) as box
```

{#each srcs_wide as year}

### {year.reportingyear}

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


# Overview

```sql srcs_year
with pivoted as (
pivot ${srcs_long} as dash
on ReportingYear
using 
    max(currstatus) as score,
    max(statuslevel) as level,
    max(color) as color,
    max(changelevel) as changelevel,
    max(box) as box
)
select
    *,
    case
        when indicator = 'MATH' then 'CAASPP Math'
        when indicator = 'ELA' then 'CAASPP ELA'
        when indicator = 'ELPI' then 'English Language Learner Progress'
        when indicator = 'SUS' then 'Suspension Rates'
        when indicator = 'CHRON' then 'Chronic Absenteism'
        when indicator = 'GRAD' then 'Graduation Rate'
        when indicator = 'CCI' then 'College and Career Readiness'
    end as indicatorName,
    case
        when indicator = 'MATH' then 1
        when indicator = 'ELA' then 2
        when indicator = 'ELPI' then 3
        when indicator = 'SUS' then 4
        when indicator = 'CHRON' then 5
        when indicator = 'GRAD' then 6
        when indicator = 'CCI' then 7
    end as indicatorOrder,
    case
        when indicator = 'MATH' then '##0.0" points"'
        when indicator = 'ELA' then '##0.0" points"'
        when indicator = 'ELPI' then '##0.0"%"'
        when indicator = 'SUS' then '##0.0"%"'
        when indicator = 'CHRON' then '##0.0"%"'
        when indicator = 'GRAD' then '##0.0"%"'
        when indicator = 'CCI' then '##0.0"%"'
    end as indicatorFormat,
    '/equity/' || indicator as indicatorLink 
from pivoted
order by indicatorOrder desc
```

<DataTable data={srcs_year} sort=indicatorOrder link=indicatorLink>
    <Column id=indicatorName/>
    <Column id=2024_color title=Level colGroup=2024 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2024_score title=Score colGroup=2024 align=center fmtColumn=indicatorFormat/>
    <Column id=2023_color title=Level colGroup=2023 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2023_score title=Score colGroup=2023 align=center fmtColumn=indicatorFormat/>
    <Column id=2022_color title=Level colGroup=2022 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2022_score title=Score colGroup=2022 align=center fmtColumn=indicatorFormat/>
    <Column id=2019_color title=Level colGroup=2019 align=center contentType=colorscale scaleColor={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2019_score title=Score colGroup=2019 align=center fmtColumn=indicatorFormat/>
</DataTable>