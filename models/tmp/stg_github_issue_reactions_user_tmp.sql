select 
    id as user_id,
    login as username,
    *
from {{ var('issue_reactions_user') }}