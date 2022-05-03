with issues as (
    select
        issue_id,
        state,
        title,
        issue_number,
        author_association,
        comments,
        created_at_timestamp,
        updated_at_timestamp,
        closed_at_timestamp,
        _airbyte_issues_hashid
    from {{ ref('stg_github_issues_tmp') }}
),

issue_assignees as (
    select
        assignee_username,
        _airbyte_issues_hashid
    from {{ ref('stg_github_issue_assignees_tmp') }}
),

users as (
    select
        user_id,
        author_username,
        _airbyte_issues_hashid
    from {{ ref('stg_github_issues_user_tmp') }}
),

issues_unioned as (
    select
        issues.issue_id,
        issues.state,
        issues.title,
        issues.issue_number,
        users.author_username,
        issues.author_association,
        issue_assignees.assignee_username,
        issues.comments,
        ({{ dbt_utils.datediff('issues.created_at_timestamp', 'issues.closed_at_timestamp', 'minute') }}/1440) as days_issue_open,
        created_at_timestamp,
        updated_at_timestamp,
        closed_at_timestamp
    from issues
    left join issue_assignees on issue_assignees._airbyte_issues_hashid = issues._airbyte_issues_hashid
    left join users on users._airbyte_issues_hashid = issues._airbyte_issues_hashid
)

select * from issues_unioned