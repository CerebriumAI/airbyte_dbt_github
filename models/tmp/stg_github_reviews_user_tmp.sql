select
    id as user_id,
    login as username,
    *
from {{ var('reviews_user') }}  