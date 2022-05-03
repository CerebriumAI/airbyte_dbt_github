with stargazers_users as (
    select
        _airbyte_stargazers_hashid,
        is_site_admin,
        user_type,
        username
    from
        {{ ref('stg_github_stargazers_user_tmp') }}
),

stargazers as (
    select *
    from {{ ref('stg_github_stargazers_tmp') }}
),

github_stargazers as (
    select
        starred_at,
        repository_name,
        user_id,
        user_type,
        username,
        is_site_admin
    from stargazers
    left join stargazers_users using(_airbyte_stargazers_hashid)
)

select * from github_stargazers