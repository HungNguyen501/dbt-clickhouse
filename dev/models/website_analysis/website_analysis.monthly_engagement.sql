{{ 
    config(
        tags=["monthly"],
        alias='monthly_engagement',
        materialized="incremental",
        inserts_only=True
    )
}}

with tbl_visits_tracking as (
    select 
        domain,
        browser_id_hash, 
        os_name,
        number_clicks, 
        count_sessions,
        count_pageviews,
        sum_duration
    from 
        {{ ref('website_analysis.visits_tracking') }}
    where
        toYYYYMM(event_date) = toYYYYMM(toDate('{{ get_date(var("date")) }}'))
),
tbl_final as (
    select      
        tbl1.domain, 
        tbl1.visits_number, 
        tbl1.unique_visitors_number, 
        tbl1.visit_duration,
        tbl1.pageviews_number, 
        tbl1.visits_number_by_os, 
        round(tbl1.pageviews_number/tbl1.visits_number, 2)as page_per_visit, 
        case 
            when tbl2.category is not null and tbl2.category <> '' then tbl2.category
            else 'Unknown'
        end as industry
    from (
        select
            domain, 
            sum(count_sessions) visits_number, 
            count(distinct browser_id_hash) as unique_visitors_number, 
            sum(sum_duration) as visit_duration,
            sum(count_pageviews) as pageviews_number,
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
        {{ source('website_analysis', 'domain_categories') }} as tbl2
    using domain
)

select 
	toYYYYMM(toDate('{{ get_date(var("date")) }}')) as month, 
	domain, 
    visits_number,
    unique_visitors_number,
    visit_duration,
    pageviews_number,
    page_per_visit, 
    visits_number_by_os, 
    industry,
	dense_rank() over (partition by industry order by unique_visitors_number desc, pageviews_number desc) as industry_rank, 
	dense_rank() over (order by unique_visitors_number desc, pageviews_number desc) as global_rank
from
	tbl_final