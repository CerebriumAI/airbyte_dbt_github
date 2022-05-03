select
    id as user_id,
    login as username,
    *
from {{ var('commit_comments_user') }}