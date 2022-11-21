{{ 
    config(
        materialized='table'
    )
}}

select * from {{ ref('dbt_test_tbl1') }}
