--Use Window functions with QUALIFY and ROW_NUMBER to remove duplicate rows.
--Prefer rows with a later time stamp
WITH events AS (
    SELECT *
    FROM {{ ref('mart__fact_events') }}
)
select * from events
qualify row_number()
--within a partition-event_id, we choose the latest
--order by insert_timestamp to get the latest timestamp as the first
        over (partition by event_id
              order by insert_timestamp desc)
=1  
order by event_id