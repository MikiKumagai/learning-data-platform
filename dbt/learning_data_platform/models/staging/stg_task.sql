SELECT
    id AS task_id,
    name AS task_name,
    progress_unit_id,
    progress_type_id,
    total_count,
    progress,
    active,
    is_wordbook
FROM {{ source('learning', 'task') }}