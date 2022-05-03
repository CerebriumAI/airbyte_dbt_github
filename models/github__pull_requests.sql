with pull_requests as (
    select
        id as pull_request_id,
        _airbyte_pull_requests_hashid,
        node_id,
        title,
        state,
        locked,
        repository as repository_name,
        url as link_url,
        created_at,
        updated_at,
        closed_at,
        jsonb_array_length(requested_reviewers) as requested_reviewers_count
    from {{ ref('stg_github_pull_requests_tmp') }}
),

pull_request_users as (
    select 
        id as author_user_id,
        login as author_username,
        _airbyte_pull_requests_hashid
    from {{ ref('stg_github_pull_requests_user_tmp') }}
),

issues as (
    select
        id as issue_id,
        node_id,
        number as issue_number,
        milestone,
        _airbyte_issues_hashid
    from {{ ref('stg_github_issues_tmp') }}

),

pull_request_stats as (
    select
        node_id,
        comments,
        commits
    from {{ ref('stg_github_pull_request_stats_tmp') }}
),

pull_request_reviews as (
    select
        pull_request_url,
        MIN(submitted_at) as first_review
    from {{ ref('stg_github_reviews_tmp') }}
    group by 1
),

pull_request_union as (

    select
        pull_requests.pull_request_id,
        issues.issue_id,
        pull_request_users.author_user_id,
        pull_request_users.author_username,
        issues.issue_number,
        pull_requests.state,
        pull_requests.title,
        pull_requests.repository_name,
        pull_requests.link_url,
        pull_request_stats.commits,
        pull_request_stats.comments,
        pull_requests.requested_reviewers_count,
        ({{ dbt_utils.datediff('pull_requests.created_at', 'pull_requests.closed_at', 'minute') }}/1440) as days_pull_request_open,
        ({{ dbt_utils.datediff('pull_requests.created_at', 'pull_request_reviews.first_review', 'minute') }}/1440) as days_until_first_review,
        pull_requests.closed_at as closed_at_timestamp,
        pull_requests.created_at as created_at_timestamp,
        pull_requests.updated_at as updated_at_timestamp
    from pull_requests
    left join pull_request_users on pull_requests._airbyte_pull_requests_hashid = pull_request_users._airbyte_pull_requests_hashid
    left join issues on pull_requests.node_id = issues.node_id
    left join pull_request_stats on pull_requests.node_id = pull_request_stats.node_id
    left join pull_request_reviews on pull_requests.link_url = pull_request_reviews.pull_request_url

)

select * from pull_request_union

