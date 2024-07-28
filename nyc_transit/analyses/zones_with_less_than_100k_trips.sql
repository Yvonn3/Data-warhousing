--Write a query which finds all the Zones where there are less than 100000 trips.
WITH trip_counts_by_zone AS (
    SELECT 
        dl.zone,
         --count the trips       
        COUNT(*) AS trip_count
    FROM {{ ref('mart__fact_all_taxi_trips') }} ft
    --join with dim location to get location columns
    JOIN {{ ref('mart__dim_locations') }} dl ON ft.pulocationid = dl.locationid
    GROUP BY dl.zone
)

SELECT
    zone,
    trip_count
FROM trip_counts_by_zone
WHERE trip_count < 100000
ORDER BY trip_count DESC