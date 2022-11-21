{{ 
    config(
        tags=["daily"],
        alias='visits_tracking',
        materialized="incremental",
        inserts_only=True
    )
}}

with tbl_agg_browser_clicks_data as 
(
    select
        *
    from
        {{ ref('website_analysis.agg_browser_clicks_data') }}
    where 
        event_date = toDate('{{ get_date(var("date")) }}')
)

select
    event_date, 
    now() as processed_time, 
    domain,
    browser_id,
    browser_id_hash, 
    os_name,
    regions,
    referral_hosts, 
	number_clicks, 
    length(stats) as count_sessions,
    arrayReduce('sum', arrayMap(x -> x.1, stats)) as count_pageviews,
    arrayReduce('sum', arrayMap(x -> x.2, stats)) as sum_duration
from (
    select 
        event_date, 
        domain,
        browser_id,
        browser_id_hash, 
        os_name,
        regions,
        arrayMap(host -> (host, countEqual(referrer_hosts, host)), arrayDistinct(referrer_hosts)) AS referral_hosts, 
        number_clicks,
        arrayMap((x, index) -> if((index = 1) or (timelines[index] - timelines[index-1] > 60*30), 1, 0), timelines, arrayEnumerate(timelines)) split_rules,
        arraySplit((x, y) -> y, timelines, split_rules) as sessions,
        arrayFilter(
            x -> x.1 > 1,
		    arrayMap(x -> (length(x), x[length(x)] - x[1]), sessions)
		) as stats
    from
        tbl_agg_browser_clicks_data
)
where 
    length(stats) > 0