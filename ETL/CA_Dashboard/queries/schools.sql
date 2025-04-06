create or replace table schools as 
select
    CDSCode as cds,
    StatusType,
    County,
    District,
    case 
        when School = 'No Data' then NULL
        else School
    end as School,
    case 
        when ClosedDate = 'No Data' then NULL
        else ClosedDate
    end as ClosedDate,
    case 
        when Latitude = 'No Data' then NULL
        else Latitude::float
    end as Latitude,
    case 
        when Longitude = 'No Data' then NULL
        else Longitude::float
    end as Longitude,

from read_csv('data/pubschls.txt');