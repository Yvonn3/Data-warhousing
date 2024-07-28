--Write a query to calculate the 7 day moving min, max, avg, sum for precipitation and snow for every day in the weather data, defining the window only once.
--The 7 day window should center on the day in question (for each date, the 3 days before, the date & 3 days after).
--CTE for calculating average
with moving_stats AS (
    SELECT 
        date,
        prcp,
        snow,
        MIN(prcp) OVER w AS prcp_7day_min,
        MAX(prcp) OVER w AS prcp_7day_max,
        AVG(prcp) OVER w AS prcp_7day_avg,
        SUM(prcp) OVER w AS prcp_7day_sum,
        MIN(snow) OVER w AS snow_7day_min,
        MAX(snow) OVER w AS snow_7day_max,
        AVG(snow) OVER w AS snow_7day_avg,
        SUM(snow) OVER w AS snow_7day_sum
    FROM {{ ref('stg__central_park_weather') }}
    --for reuse the partition definition, define window function here
    WINDOW w AS (
        ORDER BY date
        ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
    )
)

SELECT 
    date,
    prcp AS daily_precipitation,
    snow AS daily_snow,
    ROUND(prcp_7day_min, 2) AS prcp_7day_min,
    ROUND(prcp_7day_max, 2) AS prcp_7day_max,
    ROUND(prcp_7day_avg, 2) AS prcp_7day_avg,
    ROUND(prcp_7day_sum, 2) AS prcp_7day_sum,
    ROUND(snow_7day_min, 2) AS snow_7day_min,
    ROUND(snow_7day_max, 2) AS snow_7day_max,
    ROUND(snow_7day_avg, 2) AS snow_7day_avg,
    ROUND(snow_7day_sum, 2) AS snow_7day_sum
FROM moving_stats
ORDER BY date