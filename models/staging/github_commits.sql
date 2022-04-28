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
),

commits_authors AS (
	SELECT
		_airbyte_commits_hashid,
		id as author_id,
		type as author_type,
		login as author_username
	FROM {{ var('commits_author') }}
),


commits_committers AS (
	SELECT
		_airbyte_commits_hashid,
		type as committer_type,
		login as committer_username
	FROM {{ var('commits_committer') }}
),

commits_commit AS (
	SELECT
		_airbyte_commits_hashid,
		comment_count,
		message
	FROM {{ var('commits_commit') }}
)

SELECT
    sha,
	created_at,
	repository,
	pr_id,
	pr_number,
	author_id,
	author_type,
	author_username,
	committer_type,
	committer_username,
	comment_count,
	message
FROM
	{{ var('commits') }}
LEFT JOIN pr USING(sha)
LEFT JOIN commits_authors USING(_airbyte_commits_hashid)
LEFT JOIN commits_committers USING(_airbyte_commits_hashid)
LEFT JOIN commits_commit USING(_airbyte_commits_hashid)