--total number of trips ending in service_zones 'Airports' or 'EWR'
with trips_with_locations as (
    select
        t.dropoff_datetime,
        loc.service_zone
    from {{ ref('mart__fact_all_taxi_trips') }} as t
    left join {{ ref('mart__dim_locations') }} as loc
        on t.dolocationid = loc.locationid
)

select 
    count(*) as total_trips_ending_in_airports_or_ewr
from trips_with_locations
where service_zone IN ('Airports', 'EWR')