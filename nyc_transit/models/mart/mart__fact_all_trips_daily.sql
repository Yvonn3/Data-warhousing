select 
    type,
    -- Truncate the timestamp to the day and convert it to date
    date_trunc('day', started_at_ts)::date as date,
    -- Count the number of trips
    count (*) as trips,
    avg(duration_min) as average_trip_duration_min
from {{ ref('mart__fact_all_trips') }}
-- Group the results by type and date
group by all