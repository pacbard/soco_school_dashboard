select
    ccode || dcode as CDcode,
    avg(COLUMNS(* EXCLUDE (Year, ccode, dcode, district)))
from ${lea}
where 
    Year in ${inputs.years.value}
    and
    CDcode <> '${params.cdcode}'
group by all