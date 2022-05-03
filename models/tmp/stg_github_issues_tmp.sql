select
    id as issue_id,
    number as issue_number,
    issues.created_at as created_at_timestamp,
    issues.updated_at as updated_at_timestamp,
    issues.closed_at as closed_at_timestamp,
    *
from {{ var('issues') }}