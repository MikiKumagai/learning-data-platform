SELECT
    progress_date,
    COUNT(*) AS progress_count,
    SUM(progress_value) AS total_progress
FROM {{ ref('int_learning_progress') }}
GROUP BY progress_date
ORDER BY progress_date