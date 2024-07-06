-- Define a CTE named 'source' to select all columns from the 'fhv_tripdata' table
with source as (
    select * from {{ source('main', 'fhv_tripdata') }}
),
-- Define a second CTE named 'renamed' to perform column renaming and type casting.
renamed as (
    select
        --keep VAR, because it contains alphabet and numbers
        dispatching_base_num,
        --convert datatime columns into timestamp type
        pickup_datetime::timestamp as pickup_datetime,
        dropOff_datetime::timestamp as dropOff_datetime,
        --keep ID VAR data type
        PUlocationID,
        DOlocationID,
        --drop SR_Flag because the columns contain no value
        --keep VAR, because it contains alphabet and numbers
        Affiliated_base_number,
        filename
    from source
)
-- Select all columns from the 'renamed' CTE.
select * from renamed