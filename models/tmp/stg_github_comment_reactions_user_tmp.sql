select
    id as user_id,
    login as username,
    *
from {{ var('pull_request_comment_reactions_user') }}