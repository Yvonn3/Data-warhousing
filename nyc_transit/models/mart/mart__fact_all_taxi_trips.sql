with trips_renamed as(
-- The following lines combine data from multiple trip data about taxi tables using 'union all'

select 'fhv' as type, pickup_datetime, dropoff_datetime, pulocationid,dolocationid from
{{ref('stg__fhv_tripdata')}}
union all
select 'fhvhv' as type, pickup_datetime, dropoff_datetime, pulocationid,dolocationid from {{ ref('stg__fhvhv_tripdata') }} union all
select 'green' as type, lpep_pickup_datetime as pickup_datetime, lpep_dropoff_datetime as dropoff_datetime,pulocationid,dolocationid from {{ ref('stg__green_tripdata') }} union all
select 'yellow' as type, tpep_pickup_datetime as pickup_datetime, tpep_dropoff_datetime as dropoff_datetime,pulocationid,dolocationid from {{ref('stg__yellow_tripdata')}}

)
-- Select data from the 'trips_renamed' CTE
select type,
pickup_datetime,
dropoff_datetime,
-- Calculate the duration of the trip in minutes
datediff('minute', pickup_datetime, dropoff_datetime) as duration_min,
-- Calculate the duration of the trip in seconds
datediff ('second', pickup_datetime, dropoff_datetime) as duration_sec,
pulocationid, dolocationid

from trips_renamed