    with first_web_event as (
        select labs.unicorn_id
               , min(event_time) as earliest_event
        from uniswap.labs_swaps labs
        LEFT JOIN uniswap.mobile_events mobile
          ON mobile.unicorn_id = labs.unicorn_id
--        LEFT JOIN uniswap.web_events web
--          ON web.unicorn_id = labs.unicorn_id
        WHERE event_time is not null
        GROUP BY 1
      )
    select date_trunc('DAY', event_time)::date as event_time
            , case when earliest_event = event_time then 'new_user'
                   when earliest_event < event_time then 'returning_user' end as event_type
            , count(distinct web.unicorn_id)
    FROM first_web_event
        left join uniswap.mobile_events web
            ON web.unicorn_id = first_web_event.unicorn_id
    GROUP BY 1, 2
