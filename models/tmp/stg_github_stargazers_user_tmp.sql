select
    site_admin as is_site_admin,
    type as user_type,
    login as username,
    *
from {{ var('stargazers_user') }}