-- Define a CTE named 'source' to select all columns from the 'fhv_bases' table
with source as (
    select * from {{ source('main', 'fhv_bases') }}
),
renamed as (
    select
    -- clean up the base_num to be properly linked as foreign keys
        trim(upper(base_number)) as base_number,
    --keep name/ category as VAR
        base_name,
        dba,
        dba_category,
        filename
    from source
)
-- Select all columns from the 'renamed' CTE.
select * from renamed