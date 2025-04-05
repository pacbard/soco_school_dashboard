
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

<Gauge 
    value='{year.ALL_color}'
    name='All Students'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{#if year.AA_score }

<Gauge 
    value='{year.AA_color}'
    name='Black / Af-Am'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{/if}

{#if year.AI_score }

<Gauge 
    value='{year.AI_color}'
    name='Am In/Alaska Native'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{/if}

{#if year.AS_score }

<Gauge 
    value='{year.AS_color}'
    name='Asian'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{/if}

{#if year.FI_score }

<Gauge 
    value='{year.FI_color}'
    name='Filipino'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{/if}

{#if year.HI_score }

<Gauge 
    value='{year.HI_color}'
    name='Hisp / Latino'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{/if}

{#if year.MR_score }

<Gauge 
    value='{year.MR_color}'
    name='Multiple Races'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{/if}

{#if year.PI_score }

<Gauge 
    value='{year.PI_color}'
    name='Pacific Islander'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{/if}

{#if year.WH_score }

<Gauge 
    value='{year.WH_color}'
    name='White'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{/if}

</Grid>

{/each}

# Student Subgroups

{#each cds_wide as year}

<Grid cols=6>

<Gauge 
    value='{year.ALL_color}'
    name='All Students'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{#if year.EL_score }

<Gauge 
    value='{year.EL_color}'
    name='Language Learners'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{/if}

{#if year.LTEL_score }

<Gauge 
    value='{year.LTEL_color}'
    name='Long Term EL'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{/if}

{#if year.RFP_score }

<Gauge 
    value='{year.RFEP_color}'
    name='Reclassified EL'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{/if}

{#if year.EO_score }

<Gauge 
    value='{year.EO_color}'
    name='English Only'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{/if}

{#if year.FOS_score }

<Gauge 
    value='{year.FOS_color}'
    name='Foster Youth'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{/if}

{#if year.HOM_score }

<Gauge 
    value='{year.HOM_color}'
    name='Homeless'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{/if}

{#if year.SED_score }

<Gauge 
    value='{year.SED_color}'
    name='Soc-Econ Dis'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
/>

{/if}

{#if year.SWD_score }

<Gauge 
    value='{year.SWD_color}'
    name='Stu w/ Disabilities'
    colors={[[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']]}
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
    <Column id=2024_diffAssistance title="Differentiated Assistance" colGroup=2024 align=center/>
    <Column id=2024_color title=Level colGroup=2024 align=center contentType=colorscale colorScale={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2024_score title=Score colGroup=2024 align=center fmtColumn=groupFormat/>
    <Column id=2023_color title=Level colGroup=2023 align=center contentType=colorscale colorScale={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2023_score title=Score colGroup=2023 align=center fmtColumn=groupFormat/>
    <Column id=2022_color title=Level colGroup=2022 align=center contentType=colorscale colorScale={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2022_score title=Score colGroup=2022 align=center fmtColumn=groupFormat/>
    <Column id=2019_color title=Level colGroup=2019 align=center contentType=colorscale colorScale={['#CE2F2C', '#EE7C37', '#F5BC42', '#41934C', '#4B6AC9']} colorBreakpoints={[1,2,3,4,5]} />
    <Column id=2019_score title=Score colGroup=2019 align=center fmtColumn=groupFormat/>
</DataTable>

<LinkButton url={'/CA-dashboard/'+params.cds}>
    Return 
</LinkButton>