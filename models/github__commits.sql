with pull_request_commits as (
    select
        sha,
        pull_number as number
    from {{ ref('stg_github_pull_request_commits_tmp') }}
),

pull_request as (
    select
        id AS pull_request_id,
        number as pull_request_number,
        sha
    from
        {{ ref('stg_github_pull_requests_tmp') }}
    left join pull_request_commits using(number)
),

commits_author as (
    select
        _airbyte_commits_hashid,
        id as author_id,
        type as author_type,
        login as author_username
    from {{ ref('stg_github_commits_author_tmp') }}
),


commits_committer as (
    select
        _airbyte_commits_hashid,
        type as committer_type,
        login as committer_username
    from {{ ref('stg_github_commits_committer_tmp') }}
),

commits_commit as (
    select
        _airbyte_commits_hashid,
        comment_count,
        message
    from {{ ref('stg_github_commits_commit_tmp') }}
),

commmits as (
    select *
    from {{ ref('stg_github_commits_tmp') }}
)

github_commits as (
    select
        sha,
        created_at,
        repository,
        pull_request_id,
        pull_request_number,
        author_id,
        author_type,
        author_username,
        committer_type,
        committer_username,
        comment_count,
        message
    from commits
    left join pull_request using(sha)
    left join commits_author USING(_airbyte_commits_hashid)
    left join commits_committer USING(_airbyte_commits_hashid)
    left join commits_commit USING(_airbyte_commits_hashid)
)

select * from github_commits