select 
    *
from {{ var('commits') }}
where author != '{}'