{% set today = run_started_at.astimezone(modules.pytz.timezone('Asia/Ho_Chi_Minh')).strftime('%Y-%m-%d') %}
{% if var('trigger_monthly_model') or today == get_format_date(today, 'YYYY-MM-01') %}
    {{ config(tags=["daily"]) }}
{% endif %}

{% set date_run_at = get_date(var("date_run")) %}

with tbl_visits_tracking as (
    select
        domain,
        browser_id_hash,
        dictGet('regions', 'province_name', toUInt64(regions[2])) province_name,
        count_sessions,
        count_pageviews,
        sum_duration,    
        number_clicks
    from
        {{ ref('dim_website_visits_tracking') }}
    where
        toYYYYMM(event_date) = toYYYYMM(toDate('{{ date_run_at }}'))
),
tbl_final as (
    select 
        toYYYYMM(toDate('{{ date_run_at }}')) as month, 
        province_name,
        domain,
        sum(count_sessions) visits_number, 
        count(distinct browser_id_hash) as unique_visitors_number, 
        sum(sum_duration) as visit_duration,
        sum(count_pageviews) as pageviews_number,
        sum(number_clicks) as number_clicks,
        round(pageviews_number/visits_number, 2)as page_per_visit
    from 
        tbl_visits_tracking
    group by 
        province_name,
        domain
)

select * from tbl_final