{{ 
    config(
        materialized='view'
    )
}}

select * from {{ ref('dbt_test_tbl2') }}
