select
    id as label_id,
    _airbyte_issues_hashid
from {{ var('labels') }}