SELECT
    task_id,
    progress_value,
    progress_date
FROM {{ source('learning', 'progress') }}