{{ 
    config(
        materialized='view' 
    )
}}

select toDate('{{ get_date(var('date')) }}') as date_yesterday