-- Define a CTE named 'source' to select all columns from the 'fhv_tripdata' table
with source as (
    select * from {{ source('main', 'yellow_tripdata') }}
),
renamed as (
    select
    --convert ID columns into VARCHAR
        VendorID::VARCHAR as VendorID,
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        --convert count columns to int
        passenger_count::int as passenger_count,
        trip_distance,
        --convert into int. unique values: 1,2,3,4,5,6,99
        RatecodeID::int as RatecodeID,
         --convert to boolean using macros
        {{ yn_to_boolean('store_and_fwd_flag') }} AS store_and_fwd_flag,
        PULocationID,
        DOLocationID,
        --convert into int. unique values: 1,2,3,4,5
        payment_type::int as payment_type,
        --expenses columns stay as double type
        fare_amount,
        extra,
        mta_tax
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        congestion_surcharge,
        airport_fee,
        filename
    from source
)
-- Select all columns from the 'renamed' CTE.
select * from renamed
