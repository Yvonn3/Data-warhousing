select
    started_at_ts,
    ended_at_ts,
    -- Calculate the duration of the trip in minutes
    datediff('minute', started_at_ts, ended_at_ts) as duration_min,
    -- Calculate the duration of the trip in seconds
    datediff ('second', started_at_ts, ended_at_ts) as duration_sec,
    start_station_id,
    end_station_id
from {{ref('stg__bike_data')}}
