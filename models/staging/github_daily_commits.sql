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
	github_lowlighter_demo.commits
GROUP BY
	date_trunc('day', created_at),
	repository,
	author->>'id',
	author->>'type',
	author->>'login',
	committer->>'type',
	committer->>'login'