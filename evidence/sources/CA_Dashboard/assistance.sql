select
  *,
  case
    when studentgroup = 'ALL' and N_ones = 1 then 'Yes'
    when studentgroup <> 'ALL' and N_ones > 1 then 'Yes'
    else 'No'
  end as differentiatedAssistance
from differentiatedAssistance
where
left(cds, 2) = 49