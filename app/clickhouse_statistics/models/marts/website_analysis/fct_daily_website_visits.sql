{{ 
    config(
        tags=["daily"],
        alias='daily_visits',
        materialized="incremental",
        inserts_only=True
    )
}}

with tbl_visits_tracking as (
    select
        domain, 
        count_sessions, 
        browser_id_hash, 
        sum_duration, 
        count_pageviews, 
        number_clicks, 
        os_name
    from
        {{ ref('dim_website_visits_tracking') }}
    where
        event_date = toDate('{{ get_date(var("date_run")) }}')
),
tbl_final as (
    select 
        toDate('{{ get_date(var("date_run")) }}') as event_date, 
        tbl1.*,
        case 
            when tbl2.industry is not null and tbl2.industry <> '' then tbl2.industry
            else 'Unknown'
        end as industry
    from (
        select 
            domain, 
            sum(count_sessions) visits_number, 
            count(distinct browser_id_hash) as unique_visitors_number, 
            sum(sum_duration) as visit_duration,
            sum(count_pageviews) as pageviews_number,
            sum(number_clicks) as number_clicks,
            round(pageviews_number/visits_number, 2)as page_per_visit, 
            map(
                'windows', sumIf(count_sessions, os_name='windows'), 
                'ios', sumIf(count_sessions, os_name='ios'), 
                'android', sumIf(count_sessions, os_name='android'), 
                'ipados', sumIf(count_sessions, os_name='ipados'), 
                'macos', sumIf(count_sessions, os_name='macos')
            ) as visits_number_by_os
        from 
            tbl_visits_tracking
        group by 
            domain
    ) as tbl1
    left join 
        {{ source('website_analysis', 'domain_industries') }} as tbl2
    using domain
)

select * from tbl_final
