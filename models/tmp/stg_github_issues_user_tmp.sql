select
    id as user_id,
    login as author_username,
    *
from {{ var('issues_user') }}