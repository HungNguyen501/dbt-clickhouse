{{ 
    config(
        tags=["daily"],
        alias='agg_browser_clicks_data',
        materialized="incremental",
        inserts_only=True
    )
}}

with tbl_browser_click_data as 
(
    select 
        browser_id,
        browser_id_hash,
        os_name,
        regions,
        domainWithoutWWW(coalesce( 
	        NULLIF(referer,''), 
	        if( indexOf( redirects, 'about:blank#blocked') = 1, redirects[2], redirects[1] ), 
	        NULLIF(prev_url,'') )
		) as referer_host,
        browser_time, 
        domainWithoutWWW(URLDomain) as domain
    from
        {{ source('browser_clicks', 'data') }}
    where
        event_date = toDate('{{ get_date(var("date_run")) }}')
        and url <> ''
        and (transition != 255)
        and status = 200
        and brand = 'coccoc'
)

select
    toDate('{{ get_date(var("date_run")) }}') as event_date,
    now() as processed_time, 
    domain,
    browser_id,
    first_value(browser_id_hash) as browser_id_hash, 
    os_name,
    regions,
    groupArray(referer_host) as referrer_hosts,
    count(1) as number_clicks, 
    arraySort(groupArray(toUnixTimestamp(browser_time))) timelines
from 
		tbl_browser_click_data
group by
    domain,
    browser_id,
    os_name,
    regions

