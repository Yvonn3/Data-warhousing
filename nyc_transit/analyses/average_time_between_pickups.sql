-- Find the average time between taxi pick ups per zone
--Use lead or lag to find the next trip per zone for each record
--then find the time difference between the pick up time for the current record and the next
--then use this result to calculate the average time between pick ups per zone.
WITH pickups_with_next AS (
    SELECT 
        ft.pickup_datetime,
        dl.zone,
        --using lead to get next pickup datetime within each zone
        LEAD(ft.pickup_datetime) OVER (
            PARTITION BY dl.zone 
            ORDER BY ft.pickup_datetime
        ) AS next_pickup_datetime
    FROM {{ ref('mart__fact_all_taxi_trips') }} ft
    JOIN {{ ref('mart__dim_locations') }} dl ON ft.pulocationid = dl.locationid
),
time_between_pickups AS (
    SELECT
        zone,
-- Calculate the duration between two pickup time in seconds
        DATEDIFF('second', pickup_datetime, next_pickup_datetime) AS seconds_between_pickups
    FROM pickups_with_next
    --exception handling
    WHERE next_pickup_datetime IS NOT NULL
)

SELECT
    zone,
    AVG(seconds_between_pickups) AS avg_seconds_between_pickups,
    AVG(seconds_between_pickups) / 60 AS avg_minutes_between_pickups
FROM time_between_pickups
GROUP BY zone
ORDER BY avg_seconds_between_pickups