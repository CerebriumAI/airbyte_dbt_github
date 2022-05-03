select
    pull_number as number,
    *
from
    {{ var('pull_request_commits') }}
