select
    login as assignee_username,
    *
from {{ var('issue_assignees') }}