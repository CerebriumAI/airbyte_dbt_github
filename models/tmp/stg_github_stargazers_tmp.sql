select
    repository as repository_name,  
    *
from {{ var('stargazers') }}