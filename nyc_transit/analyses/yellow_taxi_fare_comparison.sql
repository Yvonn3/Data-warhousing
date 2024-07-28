--Write a query to compare an individual fare to the zone, borough and overall average fare using the fare_amount in yellow taxi trip data.
--first join with dim_location to get location column info
with yellow_taxi_fares as(
    SELECT y.fare_amount,
        dl.zone AS pickup_zone,
        dl.borough AS pickup_borough
    FROM {{ ref('stg__yellow_tripdata') }} y
    JOIN {{ ref('mart__dim_locations') }} dl ON y.pulocationid = dl.locationid
    --choose yellopw taxi
),
-- write a CTE to calculate average for zone, borough and all
fare_avg as(
    SELECT
        fare_amount,
        pickup_zone,
        pickup_borough,
        -- Calculate average fare for each zone
        AVG(fare_amount) OVER (PARTITION BY pickup_zone) AS zone_avg_fare,
        -- Calculate average fare for each borough
        AVG(fare_amount) OVER (PARTITION BY pickup_borough) AS borough_avg_fare,
        -- Calculate overall average fare
        AVG(fare_amount) OVER () AS all_avg_fare
    FROM yellow_taxi_fares
)

SELECT
fare_amount,
zone_avg_fare,
borough_avg_fare,
all_avg_fare,
-- Calculate difference from average datas
fare_amount -zone_avg_fare as diff_from_zone_avg_fare,
fare_amount -borough_avg_fare as diff_from_borugh_avg_fare,
fare_amount -all_avg_fare as diff_from_all_avg_fare
From fare_avg

