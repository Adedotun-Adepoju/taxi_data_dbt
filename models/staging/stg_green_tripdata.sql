{{ config(materialized='table') }}

SELECT 
    --identifiers
    {{ dbt_utils.surrogate_key(['vendorid', 'lpep_pickup_datetime']) }} as tripid,
    CAST(vendorid AS integer) AS vendorid, 
    CAST(ratecodeid AS integer) AS ratecodeid,
    CAST(pulocationid AS integer) AS pickup_locationid,
    CAST(dolocationid AS integer) AS dropoff_locationid,

    --timestamps
    CAST(lpep_pickup_datetime AS timestamp) AS pickup_datetime,
    CAST(lpep_dropoff_datetime AS timestamp) AS dropoff_datetime,

    --trip info 
    store_and_fwd_flag,
    CAST(passenger_count AS integer) AS passenger_count,
    CAST(trip_distance AS numeric) AS trip_distance,
    CAST(trip_type AS integer) AS trip_type,
    
    --payment info
    CAST(payment_type AS integer) AS payment_type,
    {{ get_payment_type_description('payment_type') }} AS payment_type_description,
    CAST(fare_amount AS numeric) AS fare_amount,
    CAST(extra AS numeric) AS extra,
    CAST(mta_tax AS numeric) AS mta_tax,
    CAST(tip_amount AS numeric) AS tip_amount,
    CAST(ehail_fee AS numeric) AS ehail_fee,
    CAST(tolls_amount AS numeric) AS tolls_amount,
    CAST(improvement_surcharge AS numeric) AS improvement_surcharge,
    CAST(total_amount AS numeric) AS total_amount,
    CAST(congestion_surcharge AS numeric) AS congestion_surcharge

FROM {{ source('staging','external_green_partitioned') }}
WHERE vendorid is not null 

-- dbt build --m <model.sql> --var 'is_test_run: false'
{% if var('is_test_run', default=true) %}

    limit 100

{% endif %}