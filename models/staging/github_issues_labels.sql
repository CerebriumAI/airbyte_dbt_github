with issues as (
    select *
    from {{ var('issues') }}

),

labels as (
    select *
    from {{ var('labels') }}
),

issue_labels as (
    select 
        issue_id,
        label_id
    from issues
    left join labels on issues._airbyte_issues_hashid = labels._airbyte_issues_hashid
)

select * from issue_labels