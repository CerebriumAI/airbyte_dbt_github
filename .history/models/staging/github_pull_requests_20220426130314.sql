
with pull_request as (

    select
        id,
        title,
        state,
        locked,
        repository,
        created_at,
        updated_at,
        closed_at,
        closed_at-created_at as 'days_until_closed',
    from pull_requests
),

issues as (
    select
        id as issue_id,
        user_id,
        repository_id,
        milestone_id,
    from issues

),

pull_request_union_issues as (

    select *
    from pull_request
    left join issues on pull_request.node_id = issues.node_id

)

