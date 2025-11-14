# Academic Indicators

<Alert status=info>
<b>Differentiated Assistance Eligibility</b>

The California Department of Education (CDE) has yet to release the list of district that qualify for differentiated assistance.

Currently, we identify all districts where at least one subgroup scored Very Low on one or more indicators as eligible for differentiated assistance.

Please note that this indicator does not represent an official designation by the CDE. We will update the dataset once the CDE releases the list of eligible districts.
</Alert>

<Details title='More on Differentiated Assistance'>

Differentiated assistance is a targeted support program provided by the California Department of Education (CDE) to help school districts, county offices of education (COEs), and charter schools improve student outcomes. It is part of California's System of Support, which is a comprehensive approach to school improvement.

## Key points about differentiated assistance:

- Eligibility: Districts, COEs, and charter schools are eligible for differentiated assistance if they meet certain criteria, such as low performance on state or local indicators in multiple priority areas.
- Purpose: The goal of differentiated assistance is to help schools identify and address the root causes of low student performance and to build their capacity to improve student outcomes.
- Support: The CDE provides a variety of support services to eligible schools, including:
    - Technical assistance and training
    - Coaching and mentoring
    - Data analysis and reporting
    - Resource and toolkits
- LCAP Integration: Differentiated assistance is integrated into the Local Control Accountability Plan (LCAP) process, which is a comprehensive planning and accountability framework for California schools.

## How differentiated assistance works:

- Identification: The CDE identifies eligible schools based on their performance on state and local indicators.
- Needs Assessment: The CDE conducts a needs assessment to determine the specific needs of each eligible school.
- Development of a Support Plan: The CDE and the eligible school develop a customized support plan to address the school's needs.
- Implementation of Support: The CDE provides support services to the eligible school, working collaboratively with school leaders and staff.
- Monitoring and Evaluation: The CDE monitors the progress of the eligible school and evaluates the effectiveness of the support services.

By providing targeted support and resources, differentiated assistance aims to help schools improve student outcomes and close achievement gaps.

[CDE website](https://www.cde.ca.gov/ta/ac/cm/leaproposedcrit.asp)

</Details>

```sql sonoma
select
    dash.cds, 
    dash.districtname,
    assistance.diffAssistance as diffAssistance,
    '/CA-dashboard/' || dash.cds as districtLink
from CA_Dashboard.dash
    left join (select reportingyear, cds, max(differentiatedAssistance) as diffAssistance from CA_Dashboard.assistance group by all) as assistance on dash.cds = assistance.cds and dash.reportingyear = assistance.reportingyear
where
    dash.rtype = 'D'
    and
    dash.reportingyear = 2025
group by all
order by districtname
```

<DataTable data={sonoma} search=true rows=all link=districtLink>
    <Column id=districtname title="District Name"/>
    <Column id=diffAssistance title="Differentiated Assistance"/>
    <Column id=districtLink title="District Page" contentType=link linkLabel="Details →" align=center/>
</DataTable>
