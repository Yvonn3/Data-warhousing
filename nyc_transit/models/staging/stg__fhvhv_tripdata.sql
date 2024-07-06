-- Define a CTE named 'source' to select all columns from the 'fhv_tripdata' table
with source as (
    select * from {{ source('main', 'fhvhv_tripdata') }}
),
renamed as (
    select
        --keep VAR, because it contains alphabet and numbers
        hvfhs_license_num,
        dispatching_base_num,
        originating_base_num,
        --convert datatime columns into timestamp type
        request_datetime::timestamp as request_datetime,
        on_scene_datetime::timestamp as on_scene_datetime,
        pickup_datetime::timestamp as pickup_datetime,
        dropoff_datetime::timestamp as dropoff_datetime,
        --keep ID VAR data type
        PULocationID,
        DOLocationID,

        trip_miles::double as trip_miles,
        --convert into int type
        trip_time::int as trip_time,
        --convert expense columns into double type        
        base_passenger_fare::double as base_passenger_fare,
        tolls::double as tolls,
        bcf::double as bcf,
        sales_tax::double as sales_tax,
        congestion_surcharge::double as congestion_surcharge,
        airport_fee::double as airport_fee,
        tips::double as tips,
        driver_pay::double as driver_pay,
        --unique values of flag: Y N
        --use macro to convert into true/false
        {{ yn_to_boolean('shared_request_flag') }} AS shared_request_flag_bool,
        {{ yn_to_boolean('shared_match_flag') }} AS shared_match_flag_bool,
        {{ yn_to_boolean('access_a_ride_flag') }} AS access_a_ride_flag_bool,
        {{ yn_to_boolean('wav_request_flag') }} AS wav_request_flag_bool,
        {{ yn_to_boolean('wav_match_flag') }} AS wav_match_flag_bool,
        filename
    from source
)
-- Select all columns from the 'renamed' CTE.
select * from renamed