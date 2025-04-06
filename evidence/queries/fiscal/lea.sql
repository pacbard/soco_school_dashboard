select
    ccode,
    dcode,
    trim(dname) as district,
    Year::int as year,
    cast(
    case
        when K12ADA is NULL and ifnull(RegularADA::decimal(10, 2), 0) + ifnull(SpecialEdADA::decimal(10, 2), 0) + ifnull(ROCPADA::decimal(10, 2), 0) + ifnull(AdultEdADA::decimal(10, 2), 0) = 0 then 0
        when K12ADA is NULL then ifnull(RegularADA::decimal(10, 2), 0) + ifnull(SpecialEdADA::decimal(10, 2), 0) + ifnull(ROCPADA::decimal(10, 2), 0) + ifnull(AdultEdADA::decimal(10, 2), 0)
        else K12ADA
    end
    as decimal(10,2)) as ADA
from CA_fiscal.LEA