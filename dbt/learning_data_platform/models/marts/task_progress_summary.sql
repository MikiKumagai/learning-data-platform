{{ config(materialized='table') }}

SELECT
    task_name,
    ROUND(progress_value / total_count, 4) AS progress_rate,
    progress_date,
    progress_unit
FROM {{ ref('int_learning_progress') }}

QUALIFY ROW_NUMBER() OVER (
    PARTITION BY task_id
    ORDER BY progress_date DESC
) = 1