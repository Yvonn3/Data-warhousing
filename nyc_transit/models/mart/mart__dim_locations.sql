select 
    {{dbt_utils.star(ref('taxi+_zone_lookup'))}}
    --select all columns using dbt_utils.star
from {{ref('taxi+_zone_lookup')}}