-- Define a CTE named 'source' to select all columns from the 'central_park_weather' table
with source as (
    select * from {{source('main', 'central_park_weather') }}
),
-- Define a second CTE named 'renamed' to perform column renaming and type casting.
renamed as (
    select
    station,
    name,
    -- Convert 'date' column to a date type
    date::date as date, 
    -- Convert columns to a double type
    awnd:: double as awnd,
    prcp::double as prcp,
    snow:: double as snow,
    snwd:: double as snwd,
    -- Convert temperature columns to a int type
    tmax::int as tmax,
    tmin::int as tmin,
    filename
    from source
)
-- Select all columns from the 'renamed' CTE.
select * from renamed
