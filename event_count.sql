SELECT 
                        'Mobile'                           as platform
                         , DATE_TRUNC('HOUR', event_time)  as event_time
                         , event_name                      as event_type
                         , count(event_time)               as num_events
                    FROM uniswap.mobile_events
                    GROUP BY 1, 2, 3

                    UNION ALL

                    SELECT 'Web'                           as platform
                         , DATE_TRUNC('HOUR', event_time)  as event_time
                         , event_name                      as event_type
                         , count(event_time)               as num_events
                    FROM uniswap.web_events
                    GROUP BY 1, 2, 3
