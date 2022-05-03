select
    type as committer_type,
    login as committer_username,
    *
from {{ var('commits_committer') }}