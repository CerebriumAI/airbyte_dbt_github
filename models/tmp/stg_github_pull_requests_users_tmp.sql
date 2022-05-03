select
    id as author_user_id,
    login as author_username,
    *
from {{ var('pull_requests_user') }}