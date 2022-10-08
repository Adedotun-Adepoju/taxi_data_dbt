{{ config(materialized='table') }}

WITH trips_data AS (
    SELECT * FROM {{ ref('fact_trips') }}
)

SELECT 
    --Revenue grouping
    pickup_zone AS revenue_zone,
    DATE_TRUNC(pickup_datetime, day) AS revenue_day,
    service_type,

    --Revenue calculation
    SUM(fare_amount) AS revenue_daily_fare,
    SUM(extra) AS revenue_daily_extra,
    SUM(mta_tax) AS revenue_daily_mta_tax,
    SUM(tip_amount) AS revenue_daily_tip_amount,
    SUM(tolls_amount) AS revenue_daily_tolls_amount,
    SUM(ehail_fee) AS revenue_daily_ehail_fee,
    SUM(improvement_surcharge) AS revenue_daily_improvement_surcharge,
    SUM(total_amount) AS revenue_daily_total_amount,
    SUM(congestion_surcharge) AS revenue_daily_congestion_surcharge,

    --Additional calculations
    COUNT(tripid) AS total_daily_trips,
    AVG(passenger_count) AS avg_daily_passenger_count,
    AVG(trip_distance) AS avg_daily_trip_distance

    FROM trips_data
    GROUP BY 1,2,3