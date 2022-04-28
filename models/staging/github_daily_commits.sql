WITH commits_author AS (
	SELECT
		_airbyte_commits_hashid,
		id as author_id,
		type as author_type,
		login as author_username
	FROM {{ var('commits_author') }}
),


commits_committer AS (
	SELECT
		_airbyte_commits_hashid,
		type as committer_type,
		login as committer_username
	FROM {{ var('commits_committer') }}
),

commits AS (
    SELECT
        sha,
        created_at,
        repository,
        author_id,
        author_type,
        author_username,
        committer_type,
        committer_username
    FROM {{ var('commits') }}
    LEFT JOIN commits_author USING(_airbyte_commits_hashid)
    LEFT JOIN commits_committer USING(_airbyte_commits_hashid)
)

SELECT
	date_trunc('day', created_at) AS date,
	repository,
	author_id,
	author_type,
	author_username,
	committer_type,
	committer_username,
	count(*) as commits
FROM
	commits
GROUP BY
	1,2,3,4,5,6,7