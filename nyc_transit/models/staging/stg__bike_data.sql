-- Define a CTE named 'source' to select all columns from the 'bike_data' table
with source as (
    select * from {{ source('main', 'bike_data') }}
),
-- Define a second CTE named 'renamed' to perform column renaming and type casting.
renamed as (
    select
        --Convert into int
        tripduration::int as tripduration,
        --Convert time columns into timestamp
        starttime::timestamp as starttime,
        stoptime::timestamp as stoptime,
        --not select columns
        --"start station id"
        --"start station name"
        --"start station latitude"
        --"start station longitude"
        --"end station id"
        --"end station name"
        --"end station latitude"
        --"end station longitude"
        bikeid as bikeid,
        --Unique value: Subscriber, Customer . Therefore keep the datatype as VAR.
        usertype,
        --Convert into int
        "birth year"::int as birth_year,
        --Unique value: 0,1,2. Convert into int
        gender::int as gender,
        --keep id as VAR
        ride_id,
         --Unique value:  electric_bike, classic_bike, docked_bike. Therefore keep the datatype as VAR.
        rideable_type,
        --Convert time columns into timestamp
        started_at::timestamp as started_at,
        ended_at::timestamp as ended_at,
        --keep id/latitude/longtitude/name columns as VAR
        start_station_name,
        start_station_id,
        end_station_name,
        end_station_id,
        start_lat,
        start_lng,
        end_lat,
        end_lng,
        --unique value: casual, member, therefore keep the datatype as VAR.
        member_casual,
        filename
    from source
)
-- Select all columns from the 'renamed' CTE.
select * from renamed
