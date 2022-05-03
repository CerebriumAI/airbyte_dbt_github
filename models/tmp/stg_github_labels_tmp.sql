select
    id as label_id,
    *
from {{ var('labels') }}