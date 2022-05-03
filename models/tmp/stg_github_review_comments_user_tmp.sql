 select
    id as user_id,
    login as username,
    *
from {{ var('review_comments_user') }}