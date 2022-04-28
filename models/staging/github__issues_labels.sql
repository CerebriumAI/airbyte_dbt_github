{{ config(materialized='table', schema=var('target_schema')) }}

with issues as (
    select
        id as issue_id,
        _airbyte_issues_hashid
    from {{ var('issues') }}

),

labels as (
    select
        id as label_id,
        _airbyte_issues_hashid
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