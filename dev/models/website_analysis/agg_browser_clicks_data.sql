{{ 
    config(
        tags=["daily"],
        materialized="incremental",
        inserts_only=True
    )
}}

with tbl_browser_click_data as 
(
    select 
            *, 
            domainWithoutWWW(URLDomain) as domain, 
            redirect
    from
            browser_clicks.data
    where
        event_date = toDate('{{ get_date(var("date")) }}')
        and url <> ''
        and domain <> ''
        and (transition != 255)
        and status = 200
)

select
    toDate('{{ get_date(var("date")) }}') as event_date,
    now() as processed_time, 
    domain,
    browser_id,
    first_value(browser_id_hash) as browser_id_hash, 
    os_name,
    regions,
    arrayFilter(
        x -> x <> '', 
        arrayConcat(
            groupArray(domainWithoutWWW(referer)), 
            groupArray(domainWithoutWWW(prev_url)),
            groupArray(domainWithoutWWW(redirect))
        )
    ) AS referer_hosts,
    count(1) as number_clicks, 
    arraySort(groupArray(toUnixTimestamp(browser_time))) timelines
from 
		tbl_browser_click_data
group by
    domain,
    browser_id,
    os_name,
    regions

