WITH trips_by_borough AS (
    SELECT 
        dl.borough,
        COUNT(*) AS trips
    FROM {{ ref('mart__fact_all_taxi_trips') }} ft
    --pickup location
    JOIN {{ ref('mart__dim_locations') }} dl ON ft.pulocationid = dl.locationid
    --aggregate the count by borough
    GROUP BY dl.borough
)

SELECT
    borough,
    trips
FROM trips_by_borough