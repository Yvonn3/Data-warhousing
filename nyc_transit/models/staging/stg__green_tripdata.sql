-- Define a CTE named 'source' to select all columns from the 'green_tripdata' table
with source as (
    select * from {{ source('main', 'green_tripdata') }}
),
renamed as (
    select
        VendorID::VARCHAR as VendorID,
        lpep_pickup_datetime,
        lpep_dropoff_datetime,
        --convert to boolean using macros
        {{ yn_to_boolean('store_and_fwd_flag') }} AS store_and_fwd_flag,
        --convert to int. unique values:1,2,3,4,5,99
        RatecodeID::int as RatecodeID,
        PULocationID,
        DOLocationID,
        --convert count columns to int
        passenger_count::int as passenger_count,
        trip_distance,
        --keep expenses columns as double
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        ehail_fee,
        improvement_surcharge,
        total_amount,
        --convert into int. unique values: 1,2,3,4,5
        payment_type::int as payment_type,
        --convert to int        
        trip_type::int as trip_type,
        congestion_surcharge::double as congestion_surcharge,
        filename
    from source
)
-- Select all columns from the 'renamed' CTE.
select * from renamed
