{{ config(materialized='table') }}

WITH learning_data AS (
    SELECT
        p.task_id,
        t.name AS task_name,
        t.total_count,
        p.progress_value,
        p.progress_date,
        pu.name AS progress_unit
    FROM `learning-data-platform-505213.learning.progress` AS p
    JOIN `learning-data-platform-505213.learning.task` AS t
        ON p.task_id = t.id
    JOIN `learning-data-platform-505213.learning.progress_unit` AS pu
        ON t.progress_unit_id = pu.id
)

SELECT
    task_name,
    ROUND(progress_value / total_count, 4) AS progress_rate,
    progress_date,
    progress_unit
FROM learning_data

QUALIFY ROW_NUMBER() OVER (
    PARTITION BY task_id
    ORDER BY progress_date DESC
) = 1