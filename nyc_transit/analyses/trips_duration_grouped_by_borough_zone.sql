--Calculate the number of trips and average duration by borough and zone
WITH trips_by_borough_and_zone AS (
    SELECT 
        dl.borough,
        dl.zone,
        --count the trips
        COUNT(*) AS trips,
        --calculate the average duration min
        round(avg(ft.duration_min),2) as average_duration_min,
        --calculate the average duration sec
        round(avg(ft.duration_sec),2) as average_duration_sec        
    FROM {{ ref('mart__fact_all_taxi_trips') }} ft
    --join with dim location to get location columns
    JOIN {{ ref('mart__dim_locations') }} dl ON ft.pulocationid = dl.locationid
    --aggregate the count by borough and zone
    GROUP BY (dl.borough,dl.zone)
)

SELECT
    borough,
    zone,
    trips,
    average_duration_min,
    average_duration_sec
FROM trips_by_borough_and_zone
order by borough, zone