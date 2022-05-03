select
    id as issue_id,
    number as issue_number,
    *
from {{ var('issues') }}