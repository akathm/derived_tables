with swap_events as (SELECT mobile_events.unicorn_id
                          , coalesce (platform, 'Mobile') as platform
                          , count(event_time) AS n_swap_events
                          , count(txn_hash)   AS n_txns
                     FROM uniswap.mobile_events
                              LEFT JOIN uniswap.labs_swaps
                                        ON mobile_events.unicorn_id = labs_swaps.unicorn_id
                     WHERE event_name = 'Swap Quote Received'
                     GROUP BY 1, 2

                     UNION

                     SELECT web_events.unicorn_id
                          , coalesce (platform, 'Web') as platform
                          , count(event_time)
                          , count(txn_hash) AS n_txns
                     FROM uniswap.web_events
                              LEFT JOIN uniswap.labs_swaps
                                        ON web_events.unicorn_id = labs_swaps.unicorn_id
                     WHERE event_name = 'Swap Quote Received'
                     GROUP BY 1, 2)
, final as (
select platform
        , case when n_swap_events >= 1000 then '1000 or More'
            when n_swap_events >= 500 then '500-999 '
            when n_swap_events >= 250 then '250-499 '
            when n_swap_events >= 100 then '100-249'
            when n_swap_events >= 50 then '50-99 '
            when n_swap_events >= 25 then '25-49'
            else '< 25'
            end AS swap_events_bucketed
        , sum(n_swap_events) as total_swap_events
        , sum(n_txns) as total_txns
    from swap_events
    group by 1, 2
    )
select platform
     , swap_events_bucketed
     , total_swap_events
     , total_txns
     , total_txns/total_swap_events*100 as pct_resulting_in_txn
from final
order by 1, length(swap_events_bucketed)
