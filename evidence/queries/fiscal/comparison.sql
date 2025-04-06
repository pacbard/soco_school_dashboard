select
    case
        when left(comparison.CDcode, 2) = '49' then 'Sonoma County'
        when comparison.ADA::float / district.ADA::float between (1 - ${inputs.distance}) and (1 + ${inputs.distance}) then 'ADA'
        else null
    end as Match,
    comparison.CDcode,
    avg(comparison.ADA) as ADA,
from ${comparison_data} as comparison
    cross join ${district_data} as district
where 
    Match in ${inputs.comparison.value}
    and
    comparison.ADA > 0
group by all
order by comparison.CDcode, Match