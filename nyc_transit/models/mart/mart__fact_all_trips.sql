with trips_renamed as (
    -- The following lines combine data from multiple trip data tables using 'union all'

    -- Select bike trip data
    select 
        'bike' as type, 
        started_at_ts, 
        ended_at_ts
    from {{ ref('stg__bike_data') }}

    union all

    -- Select FHV trip data
    select 
        'fhv' as type, 
        pickup_datetime as started_at_ts, 
        dropoff_datetime as ended_at_ts
    from {{ ref('stg__fhv_tripdata') }}

    union all

    -- Select FHVHV trip data
    select 
        'fhvhv' as type, 
        pickup_datetime as started_at_ts, 
        dropoff_datetime as ended_at_ts
    from {{ ref('stg__fhvhv_tripdata') }}

    union all

    -- Select green taxi trip data
    select 
        'green' as type, 
        lpep_pickup_datetime as started_at_ts, 
        lpep_dropoff_datetime as ended_at_ts
    from {{ ref('stg__green_tripdata') }}

    union all

    -- Select yellow taxi trip data
    select 
        'yellow' as type, 
        tpep_pickup_datetime as started_at_ts, 
        tpep_dropoff_datetime as ended_at_ts
    from {{ ref('stg__yellow_tripdata') }}
)

-- Select data from the 'trips_renamed' CTE
select 
    type,
    started_at_ts,
    ended_at_ts,
    datediff('minute', started_at_ts, ended_at_ts) as duration_min,
    datediff('second', started_at_ts, ended_at_ts) as duration_sec
from trips_renamed
