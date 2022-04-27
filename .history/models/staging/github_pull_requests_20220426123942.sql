
with pull_request as (

    select
        id,
        title,
        state,
        locked,
        created_at,
        updated_at,
        closed_at,
        closed_at-created_at as 'days_until_closed',
    from pull_requests
),

