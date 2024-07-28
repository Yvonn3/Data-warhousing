--Make a query which finds taxi trips which don’t have a pick up location_id in the locations table. Return the count(..) of total # of such trips
SELECT 
count(ft.*) as non_valid_records
from  {{ ref('mart__fact_all_taxi_trips') }} ft
LEFT JOIN {{ ref('mart__dim_locations') }} dl
ON ft.pulocationid = dl.locationid
--select data whose location_id 
where dl.locationid is null