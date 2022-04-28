SELECT
	date_trunc('day', starred_at) AS date,
	repository,
	count(*) as stars
FROM
	github_lowlighter_demo.stargazers
GROUP BY
	date_trunc('day', starred_at),
	repository