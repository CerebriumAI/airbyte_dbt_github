
with pull_request as (

    select
        id,
        title,
        state,
        locked,
        repository,
        html_url as link_url,
        created_at,
        updated_at,
        closed_at,
        closed_at-created_at as 'days_issue_open',

    from pull_requests
),

issues as (
    select
        id as issue_id,
        number as issue_number,
        user_id,
        repository_id,
        milestone_id,
    from issues

),

pull_request_stats as (
    select
        node_id,
        comments,
    from pull_request_stats
),

pull_request_reviewers as (
    select 
        node_id,
        count(distinct login) as reviewers,
    from pull_request_reviewers
    group by 1
),

pull_request_union_issues as (

    select *
    from pull_request
    left join issues on pull_request.node_id = issues.node_id

)

