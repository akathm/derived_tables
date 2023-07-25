with token_swaps as (select platform
                          , CONCAT(token_in_symbol, ' > ', token_out_symbol) as token_swap
                          , count(labs.txn_hash)                             as frequency
                          , sum(usd_amount)                                  as volume_usd
                     from uniswap.labs_swaps labs
                              left join uniswap.protocol_swaps protocol
                                        ON protocol.txn_hash = labs.txn_hash
                     --where platform = 'Mobile'
                     --where platform = 'Web'
                     group by 1, 2
                     order by 3 desc)
select platform
       , count(distinct token_swap) as count_unique_swaps
       , sum(volume_usd) as sum_volume_usd
       , count_unique_swaps / sum_volume_usd as usd_volume_per_swap
from token_swaps
group by 1
