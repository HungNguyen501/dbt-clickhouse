{{ 
    config(
        materialized='table' 
    )
}}

select 
    event_date, 
    event_time, 
    processed_time, 
    metrics_hash, 
    ipv4, 
    brand, 
    os_name 
from 
    browser_clicks.data
limit 50