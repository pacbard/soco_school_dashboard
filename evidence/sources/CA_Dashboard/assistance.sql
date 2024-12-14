select
  differentiatedAssistance.*,
  case
    when right(differentiatedAssistance.cds, 7) = '0000000' and studentgroup = 'ALL' and N_ones = 1 then 'Yes'
    when right(differentiatedAssistance.cds, 7) = '0000000' and studentgroup <> 'ALL' and N_ones > 1 then 'Yes'
    when right(differentiatedAssistance.cds, 7) = '0000000' then 'No' 
    when differentiatedAssistance.reportingyear = 2024 and ESSA_2024.AssistanceStatus2024 is not null then ESSA_2024.AssistanceStatus2024
    when differentiatedAssistance.reportingyear = 2023 and ESSA_2024.AssistanceStatus2024 is not null then ESSA_2024.AssistanceStatus2023
    when differentiatedAssistance.reportingyear = 2022 and ESSA_2024.AssistanceStatus2024 is not null then ESSA_2024.AssistanceStatus2022
    when differentiatedAssistance.reportingyear = 2021 and ESSA_2024.AssistanceStatus2024 is not null then ESSA_2024.AssistanceStatus2021
    when differentiatedAssistance.reportingyear = 2020 and ESSA_2024.AssistanceStatus2024 is not null then ESSA_2024.AssistanceStatus2020
    when differentiatedAssistance.reportingyear = 2019 and ESSA_2024.AssistanceStatus2024 is not null then ESSA_2024.AssistanceStatus2019
    when differentiatedAssistance.reportingyear = 2018 and ESSA_2024.AssistanceStatus2024 is not null then ESSA_2024.AssistanceStatus2018
    else 'N/A'
  end as differentiatedAssistance,
from differentiatedAssistance
  left join ESSA_2024 on ESSA_2024.cds = differentiatedAssistance.cds
where
left(differentiatedAssistance.cds, 2) = 49
order by differentiatedAssistance.reportingyear, differentiatedAssistance.cds, differentiatedAssistance.studentgroup