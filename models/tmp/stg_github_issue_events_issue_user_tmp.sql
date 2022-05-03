select
    id as user_id,
    login as username,
    *
from {{ var('issue_events_issue_user') }}