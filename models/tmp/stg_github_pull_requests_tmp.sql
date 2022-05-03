select
    id as pull_request_id,
    repository as repository_name,
    url as link_url,
    number as pull_request_number
    *
from {{ var('pull_requests') }}