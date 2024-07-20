--by weekday, count of total trips, trips starting and ending in a different borough, 
--and percentage w/ different start/end
with trips_with_locations as (
    select 
        t.type,
        t.pickup_datetime,
        t.dropoff_datetime,
        sloc.borough as start_borough,
        eloc.borough as end_borough
    from {{ref('mart__fact_all_taxi_trips')}} as t
    -- Join with locations table for start location
    left join {{ ref('mart__dim_locations') }} as sloc
        on t.pulocationid = sloc.locationid
    -- Join with locations table for end location
    left join {{ ref('mart__dim_locations') }} as eloc
        on t.dolocationid = eloc.locationid
),
-- CTE to calculate daily counts and trips between different boroughs
daily_counts as (
    select 
        weekday(pickup_datetime) as weekday,
        count(*) as total_trips,
        -- Count trips where start and end boroughs are different
        sum(case when start_borough != end_borough then 1 else 0 end) as diff_borough_trips
    from trips_with_locations
    group by 1
)
select 
    weekday,
    total_trips,
    diff_borough_trips,
    -- Calculate percentage of trips with different start/end boroughs
    (diff_borough_trips * 100.0 / total_trips) as percent_diff_borough
    
from daily_counts
Order by weekday