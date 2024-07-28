--Write a query to pivot the results by borough.
--CTE for aggregate based on borough
SELECT *
FROM {{ ref('mart__fact_trips_by_borough') }}
--using pivot column to generate a table with borough as the columns, and a single row with a count of trips
PIVOT (
    --first identify distinct borough and specify
    SUM(trips) FOR borough IN ('EWR','Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island','Unknown')
);
