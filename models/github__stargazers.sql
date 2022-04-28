with stargazers_users as (
    select
        _airbyte_stargazers_hashid,
        site_admin as is_site_admin,
        type as user_type,
        login as username
    from
        {{ var('stargazers_user') }}
),

stargazers as (
    select
        starred_at,
        repository as repository_name,
        user_id,
        user_type,
        username,
        is_site_admin
    from
        {{ var('stargazers') }}
    left join stargazers_users using(_airbyte_stargazers_hashid)
)

select * from stargazers