WITH pr_commits AS (
	SELECT
		sha,
		pull_number as number
	FROM
		{{ var('pull_request_commits') }}
),

pr AS (
	SELECT
		id AS pr_id,
		number as pr_number,
		sha
	FROM
		{{ var('pull_requests') }}
	LEFT JOIN pr_commits USING(number)
)

SELECT
	sha as commit_hash,
	created_at,
	repository,
	pr_id,
	pr_number,
	author->>'id' as author_id,
	author->>'type' as author_type,
	author->>'login' as author_username,
	committer->>'type' as committer_type,
	committer->>'login' as comitter_username,
	commit->>'comment_count' as comment_count,
	commit->>'message' as message
FROM
	{{ var('commits') }}.commits
LEFT JOIN pr USING(sha)