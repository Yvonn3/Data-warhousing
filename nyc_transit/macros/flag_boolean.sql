--This macro converts 'Y' and 'N' string values to boolean TRUE and FALSE respectively.
--It's particularly useful for flag columns
{% macro yn_to_boolean(column_name) %}
    CASE 
        WHEN {{ column_name }} = 'Y' THEN TRUE
        WHEN {{ column_name }} = 'N' THEN FALSE
        ELSE NULL
    END
{% endmacro %}