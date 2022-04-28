with issues as (
    select
        id as issue_id,
        state,
        title,
        number as issue_number,
        author_association,
        comments,
        created_at,
        closed_at,
        updated_at
    from {{ var('issues') }}
),

assignees as (
    select
        login as assignee_username,
        _airbyte_issues_hashid
    from {{ var('assignees') }}
),

users as (
    select
        id as user_id,
        login as user_username,
        _airbyte_issues_hashid
    from {{ ref('issue_user') }}
),

issues_unioned as (
    select
        issues.issue_id,
        issues.state,
        issues.title,
        issues.issue_number,
        users.author_username,
        issues.author_association,
        assignees.assignee_username,
        issues.comments,
        ({{ dbt_utils.datediff('issues.created_at', 'issues.closed_at', 'minute') }}/1440) as days_issue_open,
        issues.created_at as created_at_timestamp,
        issues.updated_at as updated_at_timestamp,
        issues.closed_at as closed_at_timestamp
    from issues
    left join labels on labels._airbyte_issues_hashid = issues._airbyte_issues_hashid
    left join assignees on assignees._airbyte_issues_hashid = issues._airbyte_issues_hashid
    left join users on users._airbyte_issues_hashid = issues._airbyte_issues_hashid
),
)

select * from issues_unioned