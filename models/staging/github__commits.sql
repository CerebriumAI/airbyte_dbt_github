{{ config(materialized='table', schema=var('target_schema')) }}

with pr_commits as (
    select
        sha,
        pull_number as number
    from
        {{ var('pull_request_commits') }}
),

pr as (
    select
        id AS pr_id,
        number as pr_number,
        sha
    from
        {{ var('pull_requests') }}
    left join pr_commits using(number)
),

commits_author as (
    select
        _airbyte_commits_hashid,
        id as author_id,
        type as author_type,
        login as author_username
    from {{ var('commits_author') }}
),


commits_committer as (
    select
        _airbyte_commits_hashid,
        type as committer_type,
        login as committer_username
    from {{ var('commits_committer') }}
),

commits_commit as (
    select
        _airbyte_commits_hashid,
        comment_count,
        message
    from {{ var('commits_commit') }}
),

commits as (
    select
        sha,
        created_at,
        repository,
        pr_id,
        pr_number,
        author_id,
        author_type,
        author_username,
        committer_type,
        committer_username,
        comment_count,
        message
    from
        {{ var('commits') }}
    left join pr using(sha)
    left join commits_author USING(_airbyte_commits_hashid)
    left join commits_committer USING(_airbyte_commits_hashid)
    left join commits_commit USING(_airbyte_commits_hashid)
)

select * from commits