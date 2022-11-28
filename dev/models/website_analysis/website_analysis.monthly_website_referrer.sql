{{ 
    config(
        tags=["monthly"],
        alias='monthly_website_referrer',
        materialized="incremental",
        inserts_only=True
    )
}}

with tbl_visits_tracking as (
    select
       domain,
       referral_hosts
    from
        {{ ref('website_analysis.visits_tracking') }}
    where
        toYYYYMM(event_date) = toYYYYMM(toDate('{{ get_date(var("date")) }}'))
),
tbl_process as (
    select 
        domain, 
        obj_referral_hosts.1 as referrer,
        sum(obj_referral_hosts.2) as refer_number
    from (
        select
            domain, 
            arrayJoin(referral_hosts) as obj_referral_hosts
        from 
            tbl_visits_tracking
    )
    group by 
        domain,
        obj_referral_hosts.1
),
tbl_final as (
    select
        tbl1.domain,
        tbl1.referrer,
        case 
            when tbl2.category is not null and tbl2.category <> '' then tbl2.category
            else 'Unknown'
        end as referrer_industry,
        tbl1.refer_number
    from 
        tbl_process as tbl1
    left join  
        {{ source('website_analysis', 'domain_industries') }} as tbl2
    on tbl1.referrer = tbl2.domain
)

select 
    toYYYYMM(toDate('{{ get_date(var("date")) }}')) as month,
    *
from
    tbl_final
