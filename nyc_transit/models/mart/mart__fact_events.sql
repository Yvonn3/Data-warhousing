--select all columns from events.csv
SELECT
    insert_timestamp,
    event_id,
    event_type,
    user_id,
    event_timestamp
FROM {{ref('events')}}