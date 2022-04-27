
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
        closed_at-created_at as days_issue_open,
        LEN(requested_reviewers) as requested_reviewers_count
    from pull_requests
),

issues as (
    select
        id as issue_id,
        number as issue_number,
        user_id,
        repository_id,
        milestone_id
    from issues

),

pull_request_stats as (
    select
        node_id,
        comments
    from pull_request_stats
),

pull_request_assignees as (
    select
        node_id,
        login
    from pull_request_assignees
),

pull_request_reviews as (
    select
        node_id,
        MIN(submitted_at)
    from pull_request_reviews
    group by 1
),

pull_request_union as (

    select
        *
    from pull_request
    left join issues on pull_request.node_id = issues.node_id
    left join pull_request_stats on pull_request.node_id = pull_request_stats.node_id
    left join pull_request_assignees on pull_request.node_id = pull_request_assignees.node_id
    left join pull_request_reviews on pull_request.node_id = pull_request_reviews.node_id

),

select * from pull_request_union

