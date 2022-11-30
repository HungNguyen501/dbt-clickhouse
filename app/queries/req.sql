--------------------------------------------Marketing Channels--------------------------------------------
select 
    website, 
    marketing_channels, 
    count(), 
    uniqExact(browser_id)
from 
(
    select 
        browser_id, 
        browser_time, 
        domainWithoutWWW(URLDomain) as website, 
        url , 
        referer , 
        redirects,
        case when referer ='' and empty(redirects) then 'Direct'
            when domainWithoutWWW(referer) in ('coccoc.com','google.com','google.com.vn','duckduckgo.com','bing.com') and extractURLParameter(url,'utm_campaign')='' then 'Organic Search'
            when domainWithoutWWW(referer) in ('coccoc.com','google.com','google.com.vn','duckduckgo.com','bing.com') and extractURLParameter(url,'utm_campaign')<>'' then 'Paid Search'
            when domainWithoutWWW(referer) in ('mail.google.com','mail.yahoo.com') then 'Email'
            when domainWithoutWWW(referer) in ('facebook.com','l.facebook.com','t.co','l.instagram.com','youtube.com','l.messenger.com','chat.zalo.me') then 'Social'
            when domainWithoutWWW(referer) in ('cityadsclick.com','context.qc.coccoc.com','googleadservices.com','ad.doubleclick.net') 
                or domainWithoutWWW(if(indexOf(redirects,'about:blank#blocked')=1,redirects[2],redirects[1])) in ('cityadsclick.com','context.qc.coccoc.com','googleadservices.com','ad.doubleclick.net') then 'Display Ads'
            when  domainWithoutWWW(referer) not like '%shopee.vn' then 'Referrals' 
            else 'Others' 
        end as marketing_channels
    from 
        browser_clicks.data 
    where 
        event_date = yesterday()
        and domainWithoutWWW(URLDomain) = 'shopee.vn' 
        and domainWithoutWWW(referer) not like ('%.shopee.vn')
        and domainWithoutWWW(referer) <>'shopee.vn' 
)
group by 
    marketing_channels, 
    website





--------------------------------------------Organic Search Terms vs Paid Search Terms--------------------------------------------

--- Cốc Cốc Search
select query, case when type not like 'ads%' then 'Organic Keywords'
when type like 'ads%' then 'Paid Keywords' end as search_type, 
domainWithoutWWW(url) as website, 
replaceRegexpOne(cutQueryStringAndFragment(url),'/$','') as url_,
avg(if(type like 'ads%',if(s_pos+1=0,1,s_pos+1),if(pos+1=0,1,pos+1))) as avg_position, count() as traffic 
from coccoc_search.serp_clicks sc where event_date = yesterday() 
and website = 'tiki.vn' 
group by query, search_type , website, url_
order by traffic desc

-- Google search
select 
query,
case when item_type not in ('ads','bottom-ad','top-ad') then 'Organic Keywords'
when  item_type in ('ads','bottom-ad','top-ad') then 'Paid Keywords' end as search_type, 
domainWithoutWWW(url_click) as website, 
replaceRegexpOne(cutQueryStringAndFragment(url ),'/$','') as url_click,
avg(pos+1) as avg_position, count() as traffic 
from 
(select serp_id, type as click_type, item_type , item_index as pos, url , browser_id 
from google_search.serp_clicks where event_date = yesterday()  ) as a 
left join 
(select serp_id , query,  type as serp_type, domainWithoutWWW(domain) as site_search from google_search.serp_pages sp  where event_date = yesterday()) b 
using serp_id 
where serp_type in ('gvideosearch', 'gsearch')
and website = 'tiki.vn' 
group by query, search_type , website, url_click
order by traffic desc

-- Cốc CỐc search
select website, query, search_type, url,
uniqExact(reqid) as volume 
from
(select reqid , query, 'organic' as search_type,  
replaceRegexpOne(cutQueryStringAndFragment(urls),'/$','') as url,
domainWithoutWWW(url) as website
from coccoc_search.serp array join result.url as urls
where event_date = yesterday()
and query = 'fpt shop'  
union all 
select  reqid , query, 'paid' as search_type, 
replaceRegexpOne(cutQueryStringAndFragment(urls),'/$','') as url,
domainWithoutWWW(url) as website 
from coccoc_search.serp array join  arrayJoin(ads.url) as urls
where event_date = yesterday()
and query = 'fpt shop') 
where website = 'fptshop.com.vn'
group by website, query, search_type, url

-- Google Search
select   query, 
case when serp_page_type not in ('ads','bottom-ad','top-ad') then 'organic'
when  serp_page_type in ('ads','bottom-ad','top-ad') then 'paid' end as search_type,  
replaceRegexpOne(cutQueryStringAndFragment(url),'/$','') as url_show,
domainWithoutWWW(url) as website ,
uniqExact(serp_id ) as volume 
from google_search.serp_items
where event_date = yesterday()
and serp_page_type <> 'video-yserp-box'
and query = 'fpt shop' 
and website = 'fptshop.com.vn'
group by website, query, search_type, url_show



----------------------------------Outgoing Traffic----------------------------------
select  website, outgoing_domain ,outgoing_url , count() as traffic
from 
(select browser_id, browser_time, domainWithoutWWW(URLDomain) as outgoing_domain, outgoing_url,
coalesce(referer_domain,redirect_domain,prev_url_domain) as website, 
coalesce(referer,if(indexOf(redirects,'about:blank#blocked')=1,redirects[2],redirects[1]),prev_url) as website_url,
NULLIF(domainWithoutWWW(referer),'') as referer_domain,
NULLIF(domainWithoutWWW(prev_url),'') as prev_url_domain,
NULLIF(domainWithoutWWW(if(indexOf(redirects,'about:blank#blocked')=1,redirects[2],redirects[1])),'') as redirect_domain
from browser_clicks.data where event_date = yesterday()
and website = 'shopee.vn'  
and outgoing_domain<>'shopee.vn' 
and brand = 'coccoc' and transition <> 255
)
group by website,outgoing_domain,outgoing_url
order by traffic desc






