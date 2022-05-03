select
    id as user_id,
    login as username,
    *
from {{ var('commit_comment_reactions_user') }}