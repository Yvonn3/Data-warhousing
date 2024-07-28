--Write a query to calculate the 7 day moving average precipitation for every day in the weather data.
--The 7 day window should center on the day in question (for each date, the 3 days before, the date & 3 days after).

with moving_average AS (
    SELECT 
        date,
        prcp,
        --calculate average percipitation within each seven days for moving average
        AVG(prcp) OVER (
            ORDER BY date
            ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
        ) AS centered_7day_avg_prcp
    FROM {{ ref('stg__central_park_weather') }}
    ORDER BY date
)

SELECT 
    date,
    prcp AS daily_precipitation,
    ROUND(centered_7day_avg_prcp, 2) AS centered_7day_avg_precipitation
FROM moving_average
ORDER BY date