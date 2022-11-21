{{ 
    config(
        materialized='incremental', 
        inserts_only=True
    )
}}

with tbl_browser_click_data as 
(
    select 
            *, 
            redirect
    from
            browser_clicks.data
    where
        event_date = toDate('{{ get_date(var("date")) }}')
        and url <> ''
        and (transition != 255)
        and status = 200
)

select
    toDate('{{ get_date(var("date")) }}') as event_date,
    domainWithoutWWW(URLDomain) as domain,
    browser_id,
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
    arraySort(groupArray(toUnixTimestamp(browser_time))) timelines,
	count(1) as number_clicks
from 
		tbl_browser_click_data
group by
    domain,
    browser_id,
    os_name,
    regions

