
with pull_request as (

    select
        node_id,
        title,
        state,
        locked,
        repository,
        "user"->>'id' as author_user_id,
        "user"->>'login' as author_username,
        url as link_url,
        created_at,
        updated_at,
        closed_at,
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
        comments,
        commits
    from github_cerebrium_airbyte.pull_request_stats
),

pull_request_reviews as (
    select
        pull_request_url,
        MIN(submitted_at) as first_review
    from github_cerebrium_airbyte.reviews
    group by 1
),

pull_request_union as (

    select
        issues.issue_id,
        issues.user_id,
        issues.issue_number,
        pull_request.state,
        pull_request.title,
        pull_request.repository,
        pull_request.link_url,
        pull_request_stats.commits,
        pull_request_stats.comments,
        pull_request.requested_reviewers_count,
        round((EXTRACT(epoch from pull_request.closed_at-pull_request.created_at)/3600)::decimal,2) as days_issue_open,
        round((EXTRACT(epoch from pull_request_reviews.first_review - pull_request.created_at)/3600)::decimal,2) as days_until_first_review,
        pull_request.closed_at,
        pull_request.created_at,
        pull_request.updated_at
    from pull_request
    left join issues on pull_request.node_id = issues.node_id
    left join pull_request_stats on pull_request.node_id = pull_request_stats.node_id
    left join pull_request_reviews on pull_request.link_url = pull_request_reviews.pull_request_url

)

select * from pull_request_union

