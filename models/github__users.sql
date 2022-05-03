with commit_comments_user as (
    select
        id as user_id,
        url,
        type,
        login as username
    from {{ ref('stg_github_commit_comments_user_tmp') }}
),

commit_comment_reactions_user as (
    select
        id as user_id,
        url,
        type,
        login as username
    from {{ ref('stg_github_commit_comment_reactions_user') }}
),

issue_comment_reactions_user as (
    select
        id as user_id,
        url,
        type,
        login as username
    from {{ ref('stg_github_issue_comment_reactions_user') }}
),

issue_events_issue_user as (
    select
        id as user_id,
        url,
        type,
        login as username
    from {{ ref('stg_github_issue_events_issue_user') }}
),

issue_reactions_user as (
    select 
        id as user_id,
        url,
        type,
        login as username
    from {{ ref('stg_github_issue_reactions_user') }}
),

issues_user as (
    select
        id as user_id,
        url,
        type,
        login as username
    from {{ ref('stg_github_issues_user') }}
),

pull_request_comment_reactions_user as (
    select
        id as user_id,
        url,
        type,
        login as username
    from {{ ref('stg_github_pull_request_comment_reactions_user') }}
),

pull_requests_user as (
    select
        id as user_id,
        url,
        type,
        login as username
    from {{ ref('stg_github_pull_requests_user') }}
),

review_comments_user as (
    select
        id as user_id,
        url,
        type,
        login as username
    from {{ ref('stg_github_review_comments_user') }}
),

reviews_user as (
    select
        id as user_id,
        url,
        type,
        login as username
    from {{ ref('stg_github_reviews_user') }}
),

stargazers_user as (
    select
        id as user_id,
        url,
        type,
        login as username
    from {{ ref('stg_github_stargazers_user') }}
),

users_unioned as (
    select * from commit_comments_user
    union all 
        select * from commit_comment_reactions_user
    union all 
        select * from issue_comment_reactions_user
    union all
        select * from issue_events_issue_user
    union all
        select * from issue_reactions_user
    union all
        select * from issues_user
    union all
        select * from pull_request_comment_reactions_user
    union all 
        select * from pull_requests_user
    union all
        select * from review_comments_user
    union all
        select * from reviews_user
    union all
        select * from stargazers_user
    
),

users as (
    select *
    from users_unioned
    group by 1,2,3,4
)

select * from users