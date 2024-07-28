--Write a query to determine if days immediately preceding precipitation or snow
--had more bike trips on average than the days with precipitation or snow.
--CTE to identify days with precipitation or snow
WITH weather_days AS (
    SELECT 
        date,
        prcp,
        snow,
        LAG(prcp, 1) OVER (ORDER BY date) AS prev_prcp,
        LAG(snow, 1) OVER (ORDER BY date) AS prev_snow
    FROM {{ ref('stg__central_park_weather') }}
),

--CTE to identify days immediately preceding precipitation or snow
preceding_days AS (
    SELECT 
        date,
        CASE 
            WHEN prcp > 0 OR snow > 0 THEN 'Rainy Day or Snowy Day'
            WHEN prev_prcp > 0 OR prev_snow > 0 THEN 'Day Before Rain or Snow'
            ELSE 'No Precipitation or Snow'
        END AS day_type
    FROM weather_days
),

-- CTE to join bike trips with the identified days
bike_trips_with_weather AS (
    SELECT 
         started_at_ts::date AS trip_date,
        COUNT(*) AS trip_count,
        pd.day_type
    FROM {{ ref('mart__fact_all_bike_trips') }} ft
    JOIN preceding_days pd ON started_at_ts::date = pd.date
    GROUP BY started_at_ts::date , pd.day_type
),

-- CTE to calculate average bike trips for each day type
average_trips AS (
    SELECT 
        day_type,
        AVG(trip_count) AS avg_trip_count
    FROM bike_trips_with_weather
    WHERE day_type IN ('Rainy Day or Snowy Day', 'Day Before Rain or Snow')
    GROUP BY day_type
)

-- Final query to compare average trips
SELECT 
    day_type,
    avg_trip_count
FROM average_trips
ORDER BY 
    CASE 
        WHEN day_type = 'Rainy Day or Snowy Day' THEN 1
        WHEN day_type = 'Day Before Rain or Snow' THEN 2
    END;
