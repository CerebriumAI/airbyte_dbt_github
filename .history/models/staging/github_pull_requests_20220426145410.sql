
with pull_request as (

    select
        node_id,
        title,
        state,
        locked,
        repository,
        html_url as link_url,
        created_at,
        updated_at,
        closed_at,
        closed_at-created_at as days_issue_open,
        jsonb_array_length(requested_reviewers) as requested_reviewers_count
    from github_cerebrium_airbyte.pull_requests
),

issues as (
    select
        id as issue_id,
        node_id,
        number as issue_number,
        user_id,
        milestone
    from github_cerebrium_airbyte.issues

),

pull_request_stats as (
    select
        node_id,
        comments
    from github_cerebrium_airbyte.pull_request_stats
),

pull_request_assignees as (
    select
        node_id,
        login
    from github_cerebrium_airbyte.pull_requests_assignees
),

pull_request_reviews as (
    select
        node_id,
        MIN(submitted_at)
    from github_cerebrium_airbyte.reviews
    group by 1
),

pull_request_union as (

    select
        issues.issue_id,
        issues.user_id,
        pull_request.issue_number,
        pull_request.state,
        pull_request.title,
        pull_request.repository,
        pull_request.is_locked,
        pull_request.link_url,
        pull_request_stats.comments,
        pull_requests_assignees.login,
        pull_request.requested_reviewers_count,
        (pull_request.closed_at - pull_request.created_at) as days_issue_open,
        (pull_request_reviews.min_submitted_at - pull_request.created_at) as days_until_first_review,
        pull_request.closed_at,
        pull_request.created_at,
        pull_request.updated_at,
    from pull_request
    left join issues on pull_request.node_id = issues.node_id
    left join pull_request_stats on pull_request.node_id = pull_request_stats.node_id
    left join pull_request_assignees on pull_request.node_id = pull_request_assignees.node_id
    left join pull_request_reviews on pull_request.node_id = pull_request_reviews.node_id

)

select * from pull_request_union

