with pull_request_commits as (
    select
        sha,
        number
    from {{ ref('stg_github_pull_request_commits_tmp') }}
),

pull_request as (
    select
        pull_request_id,
        pull_request_number,
        sha
    from
        {{ ref('stg_github_pull_requests_tmp') }}
    left join pull_request_commits using(number)
),

commits_author as (
    select
        _airbyte_commits_hashid,
        author_id,
        author_type,
        author_username
    from {{ ref('stg_github_commits_author_tmp') }}
),

commits_committer as (
    select
        _airbyte_commits_hashid,
        committer_type,
        committer_username
    from {{ ref('stg_github_commits_committer_tmp') }}
),

commits_commit as (
    select
        _airbyte_commits_hashid,
        comment_count,
        message
    from {{ ref('stg_github_commits_commit_tmp') }}
),

commits as (
    select *
    from {{ ref('stg_github_commits_tmp') }}
),

github_commits as (
    select
        sha,
        repository,
        pull_request_id,
        pull_request_number,
        author_id,
        author_type,
        author_username,
        committer_type,
        committer_username,
        comment_count,
        message,
        created_at
    from commits
    left join pull_request using(sha)
    left join commits_author USING(_airbyte_commits_hashid)
    left join commits_committer USING(_airbyte_commits_hashid)
    left join commits_commit USING(_airbyte_commits_hashid)
    
)

select * from github_commits