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
        user_id,
        repository_name,
        user_type,
        username,
        is_site_admin,
        max(starred_at) as starred_at
    from stargazers
    left join stargazers_users using(_airbyte_stargazers_hashid)
    group by 1,2,3,4,5
)

select * from github_stargazers