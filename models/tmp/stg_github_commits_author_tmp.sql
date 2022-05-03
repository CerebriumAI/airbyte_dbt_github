select
    id as author_id,
    type as author_type,
    login as author_username,
    *
from {{ var('commits_author') }}