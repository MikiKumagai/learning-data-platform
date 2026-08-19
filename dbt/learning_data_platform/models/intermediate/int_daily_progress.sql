WITH progress_with_previous AS (
    SELECT
        task_id,
        task_name,
        progress_date,
        progress_value,
        LAG(progress_value) OVER (
            PARTITION BY task_id
            ORDER BY progress_date
        ) AS previous_progress
    FROM {{ ref('int_learning_progress') }}
)

SELECT
    task_id,
    task_name,
    progress_date,
    progress_value - COALESCE(previous_progress, 0) AS daily_progress
FROM progress_with_previous
ORDER BY task_id, progress_date