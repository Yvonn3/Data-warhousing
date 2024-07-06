-- Define a CTE named 'source' to select all columns from the 'fhv_bases' table
with source as (
    select * from {{ source('main', 'fhv_bases') }}
),
renamed as (
    select
    --keep VAR, Sample:B03249, containing alphabet and numbers
        base_number,
    --keep name/ category as VAR
        base_name,
        dba,
        dba_category,
        filename
    from source
)
-- Select all columns from the 'renamed' CTE.
select * from renamed