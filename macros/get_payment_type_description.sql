{#
    This macro returns the description of the payment type
#}

{% macro get_payment_type_description(payment_type) -%}

    CASE {{ payment_type }}
        WHEN 1 THEN 'Credit card'
        WHEN 2 THEN 'Cash'
        WHEN 3 THEN 'No charge'
        WHEN 4 THEN 'dispute'
        WHEN 5 THEN 'unknown'
        WHEN 6 THEN 'voided trip'
    END
    
{%- endmacro %}