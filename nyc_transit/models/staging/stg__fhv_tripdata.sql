-- Define a CTE named 'source' to select all columns from the 'fhv_tripdata' table
with source as (
    select * from {{ source('main', 'fhv_tripdata') }}
),
-- Define a second CTE named 'renamed' to perform column renaming and type casting.
renamed as (
    select
        trim(upper(dispatching_base_num)) as  dispatching_base_num, --some ids are lowercase
        --convert datatime columns into timestamp type
        pickup_datetime,
        dropoff_datetime,
        --keep ID VAR data type
        PUlocationID,
        DOlocationID,
        --drop SR_Flag because the columns contain no value
        trim(upper(affiliated_base_number)) as affiliated_base_number,
        filename
    from source
)
-- Select all columns from the 'renamed' CTE.
select * from renamed