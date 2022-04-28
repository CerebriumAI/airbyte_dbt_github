SELECT
	date_trunc('day', created_at) AS date,
	repository,
	author->>'id' as author_id,
	author->>'type' as author_type,
	author->>'login' as author_username,
	committer->>'type' as committer_type,
	committer->>'login' as comitter_username,
	count(*) as commits
FROM
	{{ var('commits') }}
GROUP BY
	1,2,3,4,5,6