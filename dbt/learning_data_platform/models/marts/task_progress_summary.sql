-- タスクごとの最新進捗率をまとめるマート。
-- 現在どのタスクがどれくらい進んでいるかを一覧するために使う。
{{ config(materialized='table') }}

SELECT
    task_name,
    progress_date,
    progress_unit,
    ROUND(progress_value / total_count, 4) AS progress_rate
FROM {{ ref('int_learning_progress') }}

QUALIFY ROW_NUMBER() OVER (
    PARTITION BY task_id
    ORDER BY progress_date DESC
) = 1
